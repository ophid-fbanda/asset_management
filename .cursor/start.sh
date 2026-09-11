#!/usr/bin/env bash
# Per-boot reconciliation: make sure the PostgreSQL server is running.
# The backend and frontend run as visible processes via the 'terminals' config.
set -euo pipefail

PG_VERSION=16
PGBIN="/usr/lib/postgresql/${PG_VERSION}/bin"
export PGDATA="${PGDATA:-$HOME/pgdata}"

if "$PGBIN/pg_ctl" -D "$PGDATA" status >/dev/null 2>&1; then
  echo "==> PostgreSQL already running"
  exit 0
fi

# A snapshot taken while the server was running bakes in a postmaster.pid that
# points at a PID from the build pod. Clear it if no server is actually running
# so the fresh boot starts cleanly instead of refusing on a stale lock file.
if [ -f "$PGDATA/postmaster.pid" ]; then
  echo "==> Removing stale postmaster.pid"
  rm -f "$PGDATA/postmaster.pid"
fi

echo "==> Starting PostgreSQL"
"$PGBIN/pg_ctl" -D "$PGDATA" -l "$HOME/pg.log" -o "-p 5432 -k /tmp" -w start
