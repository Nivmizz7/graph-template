# graph-template

Displays a single full-screen [draw.io](https://draw.io) SVG diagram and refreshes it automatically. A minimal Node.js server serves `public/index.html` and `public/latest.svg` so the latest version of the diagram is always visible.

## How it is built (rough)

- A static HTML page loads `latest.svg` and forces a refresh every 60 seconds.
- A tiny HTTP server exposes only `/`, `/index.html`, and `/latest.svg`.
- The SVG route disables caching to make updates show up immediately.

## Structure

```
.github/workflows/
  update-license-year.yml # script for update the year in the license
public/
  index.html              # full-screen page with auto refresh
  latest.svg              # diagram displayed
server/
  index.js                # minimal HTTP server
scripts/
  deploy.sh               # optional deploy script
src/
  latest.drawio           # latest draw.io source file
```

## Updating the diagram

Upload or commit a new `src/update.drawio`. The workflow will automatically:

- Convert it to `public/latest.svg`
- Replace `src/latest.drawio` with the new file
- Remove `src/update.drawio`

After the workflow completes, only `src/latest.drawio` remains in the repo.
## License

See [LICENSE](LICENSE).
