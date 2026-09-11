#!/usr/bin/env bash
# Per-boot reconciliation: make sure the PostgreSQL server is running.
# The backend and frontend run as visible processes via the 'terminals' config.
set -euo pipefail

PG_VERSION=16
PGBIN="/usr/lib/postgresql/${PG_VERSION}/bin"
export PGDATA="${PGDATA:-$HOME/pgdata}"

if ! "$PGBIN/pg_ctl" -D "$PGDATA" status >/dev/null 2>&1; then
  echo "==> Starting PostgreSQL"
  "$PGBIN/pg_ctl" -D "$PGDATA" -l "$HOME/pg.log" -o "-p 5432 -k /tmp" -w start
else
  echo "==> PostgreSQL already running"
fi
