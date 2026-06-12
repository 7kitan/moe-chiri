## scripts

    pnpm new-post "Post Title"   — create a new blog post with YYMMDD prefix
    pnpm deploy                  — build + deploy to Cloudflare Workers

## deploy

    pnpm run build
    npx wrangler deploy

Requires `npx wrangler login` first.
