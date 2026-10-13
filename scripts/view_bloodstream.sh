#!/bin/bash
# View one of your bloodstream reports in your browser.
# Usage:
#   view_bloodstream.sh                       the report in bloodstream/Primary_Analysis
#   view_bloodstream.sh Secondary_Analysis    the report in bloodstream/Secondary_Analysis
# Starts a small read-only web server; press Ctrl+C to stop it.

BLOOD=~/pet_course/derivatives/bloodstream
ANALYSIS=${1:-Primary_Analysis}
HOST=130.238.147.132
# Your Neurodesk port is the first four digits of your user ID
# (this is how neurodesk_hfbi chooses it)
NDPORT=$(id -u | cut -c1-4)

if [ ! -f "$BLOOD/$ANALYSIS/bloodstream_report.html" ]; then
  echo "No report in $BLOOD/$ANALYSIS."
  echo "Your bloodstream analyses are:"
  ls "$BLOOD" 2>/dev/null
  exit 1
fi

# Find a free port for the web server
PORT=8080
while (echo > /dev/tcp/127.0.0.1/$PORT) 2>/dev/null; do
  PORT=$((PORT + 1))
done

echo "Open this link in a new browser tab:"
echo
echo "  http://$HOST:$NDPORT/proxy/$PORT/$ANALYSIS/bloodstream_report.html"
echo
echo "Press Ctrl+C here when you are done."
echo

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$BLOOD" 2>/dev/null
