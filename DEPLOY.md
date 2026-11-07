# Deploying to GoDaddy cPanel

Needs these in your cPanel: **Setup Node.js App** (Node 20+), **MySQL Databases**,
**Cron Jobs**, **Email Accounts**, and a domain with SSL (AutoSSL).

## 1. Create the database
cPanel > MySQL Databases:
1. Create a database (cPanel adds a prefix, e.g. `cpuser_skandaplus`).
2. Create a user with a strong password (e.g. `cpuser_app`).
3. Add the user to the database with ALL PRIVILEGES.

`DATABASE_URL` = `mysql://cpuser_app:PASSWORD@localhost:3306/cpuser_skandaplus`
(URL-encode special characters in the password, e.g. `@` becomes `%40`.)

## 2. Create the tables
On your laptop, in the project folder:

    npm install
    npx prisma migrate diff --from-empty --to-schema prisma/schema.prisma --script > schema.sql

cPanel > phpMyAdmin > select your database > Import > upload `schema.sql`.

(When the schema changes later, generate a new diff the same way, or switch to
`prisma migrate deploy` over SSH.)

## 3. Load the starter data
The seed adds the courses, jobs, blogs, the 6 counselors and (optionally) your admin login.
Run it from your laptop against the cPanel database:
1. cPanel > Remote MySQL > add your laptop's public IP.
2. In a local `.env` set `DATABASE_URL` with host = your server hostname instead of `localhost`,
   plus `ADMIN_SEED_EMAIL` and `ADMIN_SEED_PASSWORD` (10+ characters).
3. `npm run seed` (needs Node 22.18+ on your laptop).
4. Remove your IP from Remote MySQL afterwards.

No admin is created unless both `ADMIN_SEED_*` values are set. Change the password after first login.

## 4. Build the upload package
    NEXT_PUBLIC_SITE_URL=https://your-domain.com bash scripts/package-for-cpanel.sh

This creates `cpanel-deploy.zip`. The site URL is baked into the build, so use the real one.

## 5. Create the Node app
cPanel > Setup Node.js App > Create Application:
- Node.js version: 20 or newer
- Application mode: Production
- Application root: `skandaplus`
- Application URL: your domain
- Application startup file: `server.js`

Then in File Manager, upload `cpanel-deploy.zip` into `/home/cpuser/skandaplus/` and Extract it.
Do NOT click "Run NPM Install": the bundle already contains what it needs.

## 6. Uploads folder
Create a folder outside the app, e.g. `/home/cpuser/skandaplus-uploads`, and set `UPLOAD_DIR` to it.
Profile photos, course covers, materials and resumes are stored there and survive redeploys.

## 7. Environment variables
In the Node app screen, add everything from `.env.example`. Required:
`DATABASE_URL`, `JWT_SECRET` (32+ random chars), `NEXT_PUBLIC_SITE_URL`, `UPLOAD_DIR`,
`CRON_SECRET`, SMTP_*, and the key for your chatbot provider (`AI_PROVIDER=gemini` + `GEMINI_API_KEY`,
or `AI_PROVIDER=claude` + `ANTHROPIC_API_KEY`).

Click Restart. Open your domain.

## 8. Daily reminder cron
cPanel > Cron Jobs, once per day (e.g. `0 3 * * *`):

    SITE_URL=https://your-domain.com CRON_SECRET=your-secret /home/cpuser/nodevenv/skandaplus/20/bin/node /home/cpuser/skandaplus/scripts/run-cron.js

(The exact node path is shown at the top of the Setup Node.js App screen.)
It emails students 7 days before access expires and clears old rate-limit rows.

## 9. Set up the counselor bot
Log in as admin:
1. Courses > a course > page content > fill "Why This Course (chatbot)".
2. Batches > add upcoming batch dates for each course.
3. Chat with the widget: ask fee, duration, next batch. Try "any discount?" and "I want to join" and
   check Chat Handoffs.

Fees, durations and descriptions come from the Courses table, so editing a course updates the bot.

## 10. Mobile app
Point the app's API base URL to `https://your-domain.com`. Login already returns a Bearer token, and the
chatbot takes `{ message, sessionToken, channel: "app" }`. Keep the `sessionToken` from the first reply
and send it with every later message.

## Moving old Supabase data
If the old site has real data: export the Postgres tables to CSV and import them into MySQL, download the
files from the Supabase buckets (profile-photos, course-covers, course-materials, resumes, blog-covers)
into `UPLOAD_DIR/<bucket>/`, and update the stored URLs to `/uploads/<bucket>/<file>`.

## Not covered / to know
- Shared hosting limits: Node apps get limited memory and a low MySQL connection cap (the app uses 5).
- Rate limits and login lockout are stored in MySQL and fail open if the database is unreachable.
