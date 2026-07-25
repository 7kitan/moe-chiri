## scripts

    pnpm new-post "Post Title"   — create a new blog post with YYMMDD prefix
    pnpm publish                    — build + deploy to Cloudflare Workers

## deploy

    pnpm run publish

Runs `astro build` then `npx wrangler deploy`. Requires `npx wrangler login` first.
