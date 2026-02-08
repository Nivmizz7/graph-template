# Kolotun

Displays a single full-screen SVG diagram and refreshes it automatically. A minimal Node.js server serves `public/index.html` and `public/latest.svg` so the latest version of the diagram is always visible.

## How it is built (rough)

- A static HTML page loads `latest.svg` and forces a refresh every 60 seconds.
- A tiny HTTP server exposes only `/`, `/index.html`, and `/latest.svg`.
- The SVG route disables caching to make updates show up immediately.

## Structure

```
public/
  index.html   # full-screen page with auto refresh
  latest.svg   # diagram displayed
server/
  index.js     # minimal HTTP server
scripts/
  deploy.sh    # optional deploy script
```

## Quests

- Missing in Action
- Clearing the way
- Kolotun
- Come by the Fire
- Knuckle Sandwich
- Stay Frosty
- Skiing with Skier
- Cold Start
- Self-Employed
- A Small Celebration