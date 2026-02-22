import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Enable Turbopack (required for Next.js 16+)
  turbopack: {},

  // Configure webpack to ignore the external folder
  webpack: (config: any) => {
    config.watchOptions = {
      ...config.watchOptions,
      ignored: ['**/Chinesename.club/**', '**/node_modules/**'],
    };
    return config;
  },
};

export default nextConfig;
