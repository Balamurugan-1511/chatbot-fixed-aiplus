import { imageHosts } from "./image-hosts.config.mjs";

/** @type {import('next').NextConfig} */
const nextConfig = {
  // Node server output (not static export) so API routes like
  // /api/enquiries — and future /api/login, /api/register — can run.
  // "standalone" produces a self-contained server in .next/standalone that
  // runs under cPanel's Setup Node.js App (see server.js and DEPLOY.md).
  //output: "standalone",

  // Pins the workspace root to this project folder so Next.js stops
  // guessing based on other lockfiles it finds elsewhere on the machine
  // (e.g. C:\Users\bala\package-lock.json).
  outputFileTracingRoot: import.meta.dirname,

  productionBrowserSourceMaps: false,

  eslint: {
    ignoreDuringBuilds: true,
  },

  images: {
    unoptimized: true,
    remotePatterns: imageHosts,
    minimumCacheTTL: 60,
    qualities: [75, 85, 100],
  },
};

export default nextConfig;