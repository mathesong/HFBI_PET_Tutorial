#!/bin/bash
# View a PETPrep report in your browser.
# Usage:
#   view_petprep.sh sub-01.html   a PETPrep report (one per subject)
#   view_petprep.sh               list all reports
# Starts a small read-only web server; press Ctrl+C to stop it.

DERIV=/neurodesktop-storage/course-material/pet/data/ds004869/derivatives
HOST=130.238.147.132
# Your Neurodesk port is the first four digits of your user ID
# (this is how neurodesk_hfbi chooses it)
NDPORT=$(id -u | cut -c1-4)

# Find a free port for the web server
PORT=8080
while (echo > /dev/tcp/127.0.0.1/$PORT) 2>/dev/null; do
  PORT=$((PORT + 1))
done

if [ -n "$1" ]; then
  REPORT=$(cd "$DERIV" && find petprep -maxdepth 1 -name "$1" | head -1)
  if [ -z "$REPORT" ]; then
    echo "No report called $1. Run without a filename to see all reports."
    exit 1
  fi
else
  REPORT=""
fi

echo "Open this link in a new browser tab:"
echo
echo "  http://$HOST:$NDPORT/proxy/$PORT/${REPORT:-petprep/}"
echo
echo "Press Ctrl+C here when you are done."
echo

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$DERIV" 2>/dev/null
