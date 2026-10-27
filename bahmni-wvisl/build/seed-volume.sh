#!/bin/sh
# Seed a data directory from a tarball baked into the image, on first start only.
# Env: SEED_TAR (tarball path in image), SEED_TARGET (data dir),
#      SEED_MARKER (file whose absence means "needs seeding").
# Then execs args (the original entrypoint + cmd).
set -e
if [ -n "${SEED_TAR:-}" ] && [ -f "$SEED_TAR" ] && [ ! -e "${SEED_MARKER:-/no-such-marker}" ]; then
  echo "[seed] extracting $SEED_TAR into $SEED_TARGET"
  mkdir -p "$SEED_TARGET"
  tar xzf "$SEED_TAR" -C "$SEED_TARGET"
  rm -f "$SEED_TARGET/postmaster.pid"
else
  echo "[seed] skipping (tar missing or marker ${SEED_MARKER:-} exists)"
fi
exec "$@"
