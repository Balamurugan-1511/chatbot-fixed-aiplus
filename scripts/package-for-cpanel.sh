#!/usr/bin/env bash
# Builds the app and assembles a ready-to-upload folder for cPanel's
# "Setup Node.js App". Run on your own machine (Linux/macOS/WSL/Git Bash):
#   NEXT_PUBLIC_SITE_URL=https://your-domain.com bash scripts/package-for-cpanel.sh
# Output: cpanel-deploy/ and cpanel-deploy.zip
set -euo pipefail
cd "$(dirname "$0")/.."

: "${NEXT_PUBLIC_SITE_URL:?Set NEXT_PUBLIC_SITE_URL (your live https URL) before building}"
export DATABASE_URL="${DATABASE_URL:-mysql://build:build@127.0.0.1:3306/build}"
export JWT_SECRET="${JWT_SECRET:-build-time-placeholder-secret-0123456789}"

npm ci
npx prisma generate
npm run build

rm -rf cpanel-deploy cpanel-deploy.zip
mkdir cpanel-deploy
cp -r .next/standalone/. cpanel-deploy/
mv cpanel-deploy/server.js cpanel-deploy/next-server.js
cp server.js cpanel-deploy/server.js
mkdir -p cpanel-deploy/.next
cp -r .next/static cpanel-deploy/.next/static
[ -d public ] && cp -r public cpanel-deploy/public
mkdir -p cpanel-deploy/scripts && cp scripts/run-cron.js cpanel-deploy/scripts/
rm -f cpanel-deploy/.env

(cd cpanel-deploy && zip -qr ../cpanel-deploy.zip .)
echo "Done: cpanel-deploy.zip ($(du -h cpanel-deploy.zip | cut -f1))"
