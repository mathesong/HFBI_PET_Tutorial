#!/bin/bash
# Start a PETFit app.
# Usage:
#   run_petfit.sh regiondef          define regions and combine the TACs
#   run_petfit.sh modelling_plasma   kinetic modelling with your bloodstream input functions
#   run_petfit.sh modelling_ref      kinetic modelling with a reference region
# Reads the course dataset (read-only) and your own files in ~/pet_course.
# Press Ctrl+C to stop the app.

FUNC=$1
case "$FUNC" in
  regiondef|modelling_plasma|modelling_ref) ;;
  *)
    echo "Usage: $0 regiondef | modelling_plasma | modelling_ref"
    exit 1
    ;;
esac

DATA=/neurodesktop-storage/course-material/pet/data/ds004869
SIF=/neurodesktop-storage/course-material/pet/containers/petfit.sif
WORK=~/pet_course
HOST=130.238.147.132
# Your Neurodesk port is the first four digits of your user ID
# (this is how neurodesk_hfbi chooses it)
NDPORT=$(id -u | cut -c1-4)

if [ ! -d "$WORK/derivatives/petprep" ]; then
  echo "No PETPrep outputs in $WORK/derivatives. Run setup_pet_course.sh first."
  exit 1
fi

# Find a free port for the app, starting at 3838
PORT=3838
while (echo > /dev/tcp/127.0.0.1/$PORT) 2>/dev/null; do
  PORT=$((PORT + 1))
done
export PETFIT_SHINY_PORT=$PORT

cd "$WORK" || exit 1

CMD=(apptainer run
  -B "$DATA":/data:ro
  "$SIF"
  --func "$FUNC"
  --bids_dir /data
  --derivatives_dir "$WORK/derivatives")

if [ "$FUNC" = "modelling_plasma" ]; then
  if [ ! -d "$WORK/derivatives/bloodstream" ]; then
    echo "No bloodstream results in $WORK/derivatives. Run bloodstream first."
    exit 1
  fi
  CMD+=(--blood_dir "$WORK/derivatives/bloodstream")
fi

echo "Running:"
echo "  ${CMD[*]}"
echo
echo "When the app says 'Listening on', open this link in a new browser tab:"
echo
echo "  http://$HOST:$NDPORT/proxy/$PORT/"
echo
echo "Press Ctrl+C here to stop the app."
echo

"${CMD[@]}" 2>&1 | tee "$WORK/petfit_$FUNC.log"
