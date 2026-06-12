#!/usr/bin/env bash
set -euo pipefail

title="$*"
if [ -z "$title" ]; then
  echo "Usage: $0 \"Post Title\""
  exit 1
fi

slug=$(echo "$title" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9]/-/g' \
  | sed 's/--*/-/g' \
  | sed 's/^-//;s/-$//')

date=$(date +%y%m%d)
file="src/content/blog/${date}-${slug}.md"

if [ -f "$file" ]; then
  echo "File already exists: $file"
  exit 1
fi

cat > "$file" <<EOF
---
title: "$title"
pubDate: '$(date +%Y-%m-%d)'
tags: []
---

EOF

echo "Created $file"
${EDITOR:-vi} "$file"
