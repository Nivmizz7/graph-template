#!/bin/bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BRANCH=prod
PM2_NAME=kolotun-prod

whoami

cd "$ROOT_DIR"

git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull --ff-only origin "$BRANCH"

if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi

if npx pm2 describe kolotun-prod >/dev/null 2>&1; then
  npx pm2 restart kolotun-prod
else
  npx pm2 start npm --name kolotun-prod -- start
fi

npx pm2 save
