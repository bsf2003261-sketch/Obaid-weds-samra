#!/usr/bin/env bash
# Mac / Linux launcher
cd "$(dirname "$0")"
if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is not installed. Get it from https://nodejs.org (LTS) and run this again."
  exit 1
fi
node server.js
