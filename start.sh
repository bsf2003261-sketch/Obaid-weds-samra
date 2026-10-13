#!/usr/bin/env bash
# Mac / Linux one-click launcher: installs Node.js if missing, opens the browser, starts the site.
cd "$(dirname "$0")" || exit 1

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is needed to run the site. Trying to install it..."
  if command -v brew >/dev/null 2>&1; then
    brew install node
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y nodejs
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y nodejs
  else
    echo "Automatic install is not available here. Please install Node.js (LTS) from https://nodejs.org and run this again."
    exit 1
  fi
fi

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js could not be installed automatically. Please install it from https://nodejs.org and run this again."
  exit 1
fi

( sleep 2
  if command -v open >/dev/null 2>&1; then open "http://localhost:3000"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "http://localhost:3000" >/dev/null 2>&1
  fi ) &

node server.js
