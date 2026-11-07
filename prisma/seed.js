import { PrismaClient } from '../src/generated/prisma/client.ts';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';
import bcrypt from 'bcryptjs';
import 'dotenv/config';
import { openPositions } from '../src/lib/openPositions.js';
import { blogPosts } from '../src/lib/blogPosts.js';

// TLS for hosted MySQL (TiDB Cloud, Aiven, etc. refuse plain connections).
function sslOption(url) {
  const q = url.searchParams;
  const on =
    process.env.DATABASE_SSL === 'true' ||
    q.get('ssl') === 'true' ||
    q.has('sslaccept') ||
    /tidbcloud\.com$/i.test(url.hostname);
  return on ? { minVersion: 'TLSv1.2', rejectUnauthorized: true } : undefined;
}

const dbUrl = new URL(process.env.DATABASE_URL);
const adapter = new PrismaMariaDb({
  host: dbUrl.hostname,
  port: Number(dbUrl.port) || 3306,
  user: decodeURIComponent(dbUrl.username),
  password: decodeURIComponent(dbUrl.password),
  database: dbUrl.pathname.replace(/^\//, ''),
  connectionLimit: 3,
  ssl: sslOption(dbUrl),
});
const prisma = new PrismaClient({ adapter });