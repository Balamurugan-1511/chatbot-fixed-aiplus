// Startup file for cPanel "Setup Node.js App" (Phusion Passenger).
// scripts/package-for-cpanel.sh puts this next to Next's own server
// (renamed next-server.js). It loads .env if one exists (the cPanel env-var
// screen works too), then starts Next on the port Passenger gives us.
const fs = require('fs');
const path = require('path');

try {
  const envFile = path.join(__dirname, '.env');
  if (fs.existsSync(envFile)) {
    for (const line of fs.readFileSync(envFile, 'utf8').split(/\r?\n/)) {
      const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$/);
      if (!m || line.trim().startsWith('#')) continue;
      let val = m[2];
      if (/^(".*"|'.*')$/.test(val)) val = val.slice(1, -1);
      if (process.env[m[1]] === undefined) process.env[m[1]] = val;
    }
  }
} catch (err) {
  console.error('Could not read .env:', err.message);
}

process.env.NODE_ENV = 'production';
process.env.HOSTNAME = process.env.HOSTNAME || '0.0.0.0';

require('./next-server.js');
