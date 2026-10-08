#!/bin/bash
# Start the bloodstream app.
# Reads the course dataset (read-only) and writes results to
# ~/pet_course/derivatives/bloodstream
# Press Ctrl+C to stop the app.

DATA=/neurodesktop-storage/course-material/pet/data/ds004869
SIF=/neurodesktop-storage/course-material/pet/containers/bloodstream.sif
WORK=~/pet_course
HOST=130.238.147.132
# Your Neurodesk port is the first four digits of your user ID
# (this is how neurodesk_hfbi chooses it)
NDPORT=$(id -u | cut -c1-4)

# Find a free port for the app, starting at 3838
PORT=3838
while (echo > /dev/tcp/127.0.0.1/$PORT) 2>/dev/null; do
  PORT=$((PORT + 1))
done
export BLOODSTREAM_SHINY_PORT=$PORT

mkdir -p "$WORK/derivatives"
cd "$WORK" || exit 1

CMD=(apptainer run
  -B "$DATA":/data:ro
  "$SIF"
  --mode interactive
  --bids_dir /data
  --derivatives_dir "$WORK/derivatives")

echo "Running:"
echo "  ${CMD[*]}"
echo
echo "When the app says 'Listening on', open this link in a new browser tab:"
echo
echo "  http://$HOST:$NDPORT/proxy/$PORT/"
echo
echo "Press Ctrl+C here to stop the app."
echo

"${CMD[@]}" 2>&1 | tee "$WORK/bloodstream.log"
