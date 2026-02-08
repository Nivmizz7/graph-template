const http = require("http");
const fs = require("fs");
const path = require("path");

const port = Number(process.env.PORT) || 3598;
const publicDir = process.env.PUBLIC_DIR
  ? path.resolve(process.env.PUBLIC_DIR)
  : path.join(__dirname, "..", "public");

const routes = new Map([
  ["/", "index.html"],
  ["/index.html", "index.html"],
  ["/latest.svg", "latest.svg"],
]);

function contentType(filePath) {
  if (filePath.endsWith(".html")) return "text/html; charset=utf-8";
  if (filePath.endsWith(".svg")) return "image/svg+xml";
  return "application/octet-stream";
}

function sendNotFound(res) {
  res.statusCode = 404;
  res.setHeader("Content-Type", "text/plain; charset=utf-8");
  res.end("Not found");
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url || "/", `http://${req.headers.host || "localhost"}`);
  const pathname = url.pathname;
  const fileName = routes.get(pathname);

  if (!fileName) {
    sendNotFound(res);
    return;
  }

  const filePath = path.join(publicDir, fileName);
  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      sendNotFound(res);
      return;
    }

    res.statusCode = 200;
    res.setHeader("Content-Type", contentType(filePath));
    if (fileName === "latest.svg") {
      res.setHeader("Cache-Control", "no-store, max-age=0");
    } else {
      res.setHeader("Cache-Control", "no-cache");
    }

    const stream = fs.createReadStream(filePath);
    stream.on("error", () => {
      res.statusCode = 500;
      res.end("Error reading file");
    });
    stream.pipe(res);
  });
});

server.listen(port, () => {
  process.stdout.write(`Kolotun server listening on http://localhost:${port}\n`);
});
