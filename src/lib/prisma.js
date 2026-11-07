import { PrismaClient } from '../generated/prisma/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';

// DATABASE_URL looks like: mysql://USER:PASSWORD@localhost:3306/DBNAME
// On cPanel the user and database names are prefixed with the account name
// (e.g. cpuser_app). URL-encode special characters in the password.

// TLS for hosted MySQL (TiDB Cloud, Aiven, etc. refuse plain connections).
// Turned on by DATABASE_SSL=true, ssl=true / sslaccept=... in DATABASE_URL, or a tidbcloud.com host.
// Off for localhost/cPanel, so the GoDaddy setup is unchanged.
function sslOption(url) {
  const q = url.searchParams;
  const on =
    process.env.DATABASE_SSL === 'true' ||
    q.get('ssl') === 'true' ||
    q.has('sslaccept') ||
    /tidbcloud\.com$/i.test(url.hostname);
  return on ? { minVersion: 'TLSv1.2', rejectUnauthorized: true } : undefined;
}

function makeAdapter() {
  const url = new URL(process.env.DATABASE_URL || 'mysql://localhost/none');
  return new PrismaMariaDb({
    host: url.hostname,
    port: Number(url.port) || 3306,
    user: decodeURIComponent(url.username),
    password: decodeURIComponent(url.password),
    database: url.pathname.replace(/^\//, ''),
    // Shared hosting caps simultaneous MySQL connections (often 25 total),
    // so keep the pool small.
    connectionLimit: 5,
    ssl: sslOption(url),
  });
}

const globalForPrisma = globalThis;
export const prisma = globalForPrisma.prisma || new PrismaClient({ adapter: makeAdapter() });

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}