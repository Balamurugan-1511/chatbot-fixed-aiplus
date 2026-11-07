// Calls the daily reminder route. Use from a cPanel Cron Job:
//   /home/CPUSER/nodevenv/APPDIR/20/bin/node /home/CPUSER/APPDIR/scripts/run-cron.js
// Needs SITE_URL (or NEXT_PUBLIC_SITE_URL) and CRON_SECRET in the environment
// or in the app's .env file.
// Tiny .env reader (no dependencies) so this works inside the deployed bundle.
const fs = require('fs');
const envFile = require('path').join(__dirname, '..', '.env');
if (fs.existsSync(envFile)) {
  for (const line of fs.readFileSync(envFile, 'utf8').split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$/);
    if (!m || line.trim().startsWith('#')) continue;
    let v = m[2];
    if (/^(".*"|'.*')$/.test(v)) v = v.slice(1, -1);
    if (process.env[m[1]] === undefined) process.env[m[1]] = v;
  }
}

const base = process.env.SITE_URL || process.env.NEXT_PUBLIC_SITE_URL;
const secret = process.env.CRON_SECRET;
if (!base || !secret) {
  console.error('Set SITE_URL (or NEXT_PUBLIC_SITE_URL) and CRON_SECRET.');
  process.exit(1);
}

fetch(`${base.replace(/\/$/, '')}/api/cron/expiry-reminders`, {
  headers: { Authorization: `Bearer ${secret}` },
})
  .then(async (res) => {
    console.log(res.status, await res.text());
    process.exit(res.ok ? 0 : 1);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
