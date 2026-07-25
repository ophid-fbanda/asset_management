"""Import staff.csv -> staff_profiles + staff_accounts + role 10."""
import csv
import re
from collections import defaultdict

import psycopg2

CSV_PATH = r"C:\Aliens\2026\assem\staff.csv"
DB = dict(host="localhost", port=14577, dbname="assem", user="postgres", password="foxx")


def name_parts(full_name: str):
    parts = [p for p in re.split(r"\s+", full_name.strip()) if p]
    first = re.sub(r"[^A-Za-z]", "", parts[0]).lower()
    surname = re.sub(r"[^A-Za-z]", "", parts[-1]).lower()
    return first, surname


def assign_emails(rows):
    short_groups = defaultdict(list)
    for row in rows:
        first, surname = name_parts(row["full_name"])
        short = f"{first[0]}{surname}@ophid.co.zw"
        short_groups[short].append(row)

    emails = {}
    toedit_n = 1
    for short, group in short_groups.items():
        if len(group) == 1:
            emails[group[0]["id"]] = short
            continue

        long_groups = defaultdict(list)
        for row in group:
            first, surname = name_parts(row["full_name"])
            long_groups[f"{first}.{surname}@ophid.co.zw"].append(row)

        for long_email, long_group in long_groups.items():
            if len(long_group) == 1:
                emails[long_group[0]["id"]] = long_email
            else:
                for row in long_group:
                    emails[row["id"]] = f"toedit{toedit_n}@ophid.co.zw"
                    toedit_n += 1
    return emails


def main():
    with open(CSV_PATH, newline="", encoding="utf-8-sig") as f:
        raw = list(csv.DictReader(f))

    rows = []
    for r in raw:
        rows.append(
            {
                "id": int(r["Code"].strip()),
                "full_name": r["Fullname"].strip(),
                "station_id": int(r["station_id"].strip()),
            }
        )

    emails = assign_emails(rows)

    conn = psycopg2.connect(**DB)
    conn.autocommit = False
    cur = conn.cursor()

    # Ensure pgcrypto for digest()
    cur.execute("CREATE EXTENSION IF NOT EXISTS pgcrypto")

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
    print("toedit emails:")
    for staff_id, email in sorted(emails.items()):
        if email.startswith("toedit"):
            name = next(r["full_name"] for r in rows if r["id"] == staff_id)
            print(f"  {staff_id} {name} -> {email}")


if __name__ == "__main__":
    main()
