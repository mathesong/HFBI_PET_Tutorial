#!/bin/bash
# View a petsurfer report in your browser.
# Usage:
#   view_petsurfer.sh sub-01_ses-baseline.html   a petsurfer report (one per session)
#   view_petsurfer.sh                            list all reports
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
  REPORT=$(cd "$DERIV" && find petsurfer-bids -maxdepth 1 -name "$1" | head -1)
  if [ -z "$REPORT" ]; then
    echo "No report called $1. Run without a filename to see all reports."
    exit 1
  fi
else
  REPORT=""
fi

echo "Open this link in a new browser tab:"
echo
echo "  http://$HOST:$NDPORT/proxy/$PORT/${REPORT:-petsurfer-bids/}"
echo
echo "Press Ctrl+C here when you are done."
echo

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$DERIV" 2>/dev/null
