#!/bin/bash
# Set up your PET course working folder: ~/pet_course
# Copies the PETPrep outputs (TACs and sidecars; no images or report figures) into
# ~/pet_course/derivatives/petprep, so that PETFit can read them and write
# its own results next to them.

set -e

DATA=/neurodesktop-storage/course-material/pet/data/ds004869
WORK=~/pet_course

mkdir -p "$WORK/derivatives/petprep"

echo "Copying PETPrep outputs to $WORK/derivatives/petprep ..."
# The dataset is a DataLad dataset: many files are links, and the images are
# not downloaded. So we copy every file that has content, following links.
# The report figures (.svg, over 600 MB) are skipped: view the reports in the
# course folder instead.
cd "$DATA/derivatives"
find -L petprep -type f ! -name '*.svg' -print0 | xargs -0 cp -L --parents -t "$WORK/derivatives/"

echo "Done. Your working folder:"
du -sh "$WORK/derivatives/petprep"
ls "$WORK/derivatives"
