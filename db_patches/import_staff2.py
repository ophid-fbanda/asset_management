"""Import staff2.csv -> staff_profiles + staff_accounts + role 10."""
import csv
import re
from collections import defaultdict

import psycopg2

CSV_PATH = r"C:\Aliens\2026\assem\staff2.csv"
DB = dict(host="localhost", port=14577, dbname="assem", user="postgres", password="foxx")


def name_parts(full_name: str):
    parts = [p for p in re.split(r"\s+", full_name.strip()) if p]
    first = re.sub(r"[^A-Za-z]", "", parts[0]).lower() if parts else ""
    surname = re.sub(r"[^A-Za-z]", "", parts[-1]).lower() if parts else ""
    return first, surname


def next_toedit(taken_emails: set[str], start: int = 1) -> tuple[str, int]:
    n = start
    while True:
        email = f"toedit{n}@ophid.co.zw"
        if email not in taken_emails:
            return email, n + 1
        n += 1


def assign_emails(rows, existing_emails: set[str]):
    """
    short xsurname@ -> clash/taken -> firstname.surname@ -> still taken -> toeditN@
    Special: ZNNP+ -> znnp@ophid.co.zw
    """
    taken = set(existing_emails)
    emails = {}
    toedit_n = 1

    # Special-case rows first
    normal = []
    for row in rows:
        if row["full_name"].strip().upper() == "ZNNP+":
            email = "znnp@ophid.co.zw"
            if email in taken:
                email, toedit_n = next_toedit(taken, toedit_n)
            emails[row["id"]] = email
            taken.add(email)
        else:
            normal.append(row)

    short_groups = defaultdict(list)
    for row in normal:
        first, surname = name_parts(row["full_name"])
        short = f"{first[0]}{surname}@ophid.co.zw"
        short_groups[short].append(row)

    for short, group in short_groups.items():
        if len(group) == 1 and short not in taken:
            emails[group[0]["id"]] = short
            taken.add(short)
            continue

        # clash within batch and/or already taken in DB
        long_groups = defaultdict(list)
        for row in group:
            first, surname = name_parts(row["full_name"])
            long_groups[f"{first}.{surname}@ophid.co.zw"].append(row)

        for long_email, long_group in long_groups.items():
            if len(long_group) == 1 and long_email not in taken:
                emails[long_group[0]["id"]] = long_email
                taken.add(long_email)
            else:
                for row in long_group:
                    # if long unique in this subgroup but taken, still escalate that one
                    if len(long_group) == 1:
                        email, toedit_n = next_toedit(taken, toedit_n)
                        emails[row["id"]] = email
                        taken.add(email)
                    else:
                        email, toedit_n = next_toedit(taken, toedit_n)
                        emails[row["id"]] = email
                        taken.add(email)

    # Also: unique short that was skipped because taken in DB (handled above via `short not in taken`)
    # Wait - if len(group)==1 and short IN taken, we went into long_groups path. Good.

    return emails


def main():
    with open(CSV_PATH, newline="", encoding="utf-8-sig") as f:
        raw = list(csv.DictReader(f))

    rows = []
    for r in raw:
        rows.append(
            {
                "id": int(r["id"].strip()),
                "full_name": r["name"].strip(),
                "station_id": int(r["station"].strip()),
            }
        )

    conn = psycopg2.connect(**DB)
    conn.autocommit = False
    cur = conn.cursor()

    cur.execute("CREATE EXTENSION IF NOT EXISTS pgcrypto")
    cur.execute("SELECT lower(staff_email) FROM staff_profiles")
    existing_emails = {r[0] for r in cur.fetchall() if r[0]}

    emails = assign_emails(rows, existing_emails)

    inserted = 0
    skipped = 0
    for row in rows:
        staff_id = row["id"]
        email = emails[staff_id]
        phone = f"263770000{staff_id}"
        password = f"user{staff_id}"

        cur.execute("SELECT 1 FROM staff_profiles WHERE id = %s", (staff_id,))
        if cur.fetchone():
            skipped += 1
            continue

        cur.execute(
            """
            INSERT INTO staff_profiles (id, full_name, staff_email, staff_phone)
            VALUES (%s, %s, %s, %s)
            """,
            (staff_id, row["full_name"], email, phone),
        )
        cur.execute(
            """
            INSERT INTO staff_accounts (staff_profile_id, secret_key)
            VALUES (%s, encode(digest(%s, 'sha256'), 'hex'))
            """,
            (staff_id, password),
        )
        cur.execute(
            """
            INSERT INTO staff_roles (staff_profile_id, role_type_id, role_station_id)
            VALUES (%s, 10, %s)
            """,
            (staff_id, row["station_id"]),
        )
        inserted += 1

    conn.commit()
    cur.execute("SELECT COUNT(*) FROM staff_profiles")
    total = cur.fetchone()[0]
    cur.close()
    conn.close()

    print(f"inserted={inserted} skipped_existing={skipped} staff_profiles_total={total}")
    print("special / escalated emails:")
    for row in rows:
        email = emails[row["id"]]
        short_ok = False
        if row["full_name"].strip().upper() == "ZNNP+":
            print(f"  {row['id']} {row['full_name']} -> {email}")
            continue
        first, surname = name_parts(row["full_name"])
        short = f"{first[0]}{surname}@ophid.co.zw"
        if email != short:
            print(f"  {row['id']} {row['full_name']} -> {email}")


if __name__ == "__main__":
    main()
