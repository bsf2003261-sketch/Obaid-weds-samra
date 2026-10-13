/*
 * Tiny local web server for the invitation.
 * - No database, no accounts, no dependencies: only Node.js (v16 or newer).
 * - Serves the /public folder to this laptop AND to any phone/laptop on the same Wi-Fi.
 */
'use strict';
const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');

const PORT = Number(process.env.PORT) || 3000;
const PUBLIC_DIR = path.join(__dirname, 'public');

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
  '.ico': 'image/x-icon',
  '.woff2': 'font/woff2',
  '.txt': 'text/plain; charset=utf-8',
  '.ics': 'text/calendar; charset=utf-8'
};

const SECURITY_HEADERS = {
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'SAMEORIGIN',
  'Referrer-Policy': 'strict-origin-when-cross-origin'
};

function send(res, status, headers, body) {
  res.writeHead(status, Object.assign({}, SECURITY_HEADERS, headers));
  res.end(body);
}

const server = http.createServer((req, res) => {
  if (req.method !== 'GET' && req.method !== 'HEAD') {
    return send(res, 405, { Allow: 'GET, HEAD', 'Content-Type': 'text/plain' }, 'Method not allowed');
  }

  let pathname;
  try {
    pathname = decodeURIComponent(new URL(req.url, 'http://localhost').pathname);
  } catch (e) {
    return send(res, 400, { 'Content-Type': 'text/plain' }, 'Bad request');
  }

  if (pathname === '/healthz') return send(res, 200, { 'Content-Type': 'text/plain' }, 'ok');
  if (pathname.endsWith('/')) pathname += 'index.html';

  const file = path.normalize(path.join(PUBLIC_DIR, pathname));
  if (file !== PUBLIC_DIR && !file.startsWith(PUBLIC_DIR + path.sep)) {
    return send(res, 403, { 'Content-Type': 'text/plain' }, 'Forbidden');
  }

  fs.readFile(file, (err, data) => {
    if (err) return send(res, 404, { 'Content-Type': 'text/plain; charset=utf-8' }, 'Page not found');
    const ext = path.extname(file).toLowerCase();
    send(res, 200, {
      'Content-Type': MIME[ext] || 'application/octet-stream',
      'Cache-Control': ext === '.html' ? 'no-cache' : 'public, max-age=300'
    }, req.method === 'HEAD' ? undefined : data);
  });
});

function lanAddresses() {
  const out = [];
  Object.values(os.networkInterfaces()).forEach((list) => {
    (list || []).forEach((i) => { if (i.family === 'IPv4' && !i.internal) out.push(i.address); });
  });
  return out;
}

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error('\n  Port ' + PORT + ' is already in use. Close the other window running this site,');
    console.error('  or start on another port (Windows: set PORT=3001 then node server.js).\n');
  } else {
    console.error(err);
  }
  process.exit(1);
});

server.listen(PORT, '0.0.0.0', () => {
  console.log('\n  Obaid & Samra - Wedding Invitation is running\n');
  console.log('  On this laptop:               http://localhost:' + PORT);
  lanAddresses().forEach((ip) => console.log('  Other devices (same Wi-Fi):   http://' + ip + ':' + PORT));
  console.log('\n  Keep this window open while guests view the invitation.');
  console.log('  Press Ctrl+C to stop.\n');
});
