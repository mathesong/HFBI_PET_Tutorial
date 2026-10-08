#!/bin/bash
# Open ezBIDS in Chromium on the Neurodesk Desktop.
# Run this in a terminal on the Desktop (not in the JupyterLab terminal).
# Chromium runs on the server, so ezBIDS reads the course data from there,
# and nothing is downloaded to your laptop. ezBIDS needs a Chrome-type
# browser to select folders, which is why we use Chromium, not Firefox.

SIF=/neurodesktop-storage/course-material/pet/containers/chromium.sif
LOG=~/.ezbids-chromium.log

# Your Jupyter login token, so that the browser does not ask for it
TOKEN=$(jupyter server list --json 2>/dev/null | head -1 \
  | python3 -c "import sys, json; print(json.loads(sys.stdin.read())['token'])")

if [ -z "$TOKEN" ]; then
  echo "Could not find your Jupyter token. Is your Neurodesk running?"
  exit 1
fi

echo "Opening ezBIDS in Chromium. The first start can take a minute."
echo "(Chromium's messages go to $LOG)"

# --no-sandbox: Chromium's own sandbox cannot run inside a container
# --test-type: hides the warning bar about --no-sandbox
nohup apptainer exec "$SIF" chromium-browser \
  --no-sandbox --test-type --no-first-run \
  --user-data-dir="$HOME/.ezbids-chromium" \
  "http://localhost:8888/ezbids/?token=$TOKEN" > "$LOG" 2>&1 &
