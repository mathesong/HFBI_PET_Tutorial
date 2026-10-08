# PET data analysis workshop

Materials for the PET day of the Human Functional Brain Imaging course at Uppsala University (14 October 2026). In the workshop, participants take PET data from raw DICOM files to a pharmacological result: BIDS conversion with ezBIDS, PETPrep outputs, blood processing with bloodstream, kinetic modelling with PETFit, and a Lassen plot.

**Workshop instructions:** WEBSITE_URL

The workshop runs on the course server in Neurodesk, so the commands and paths assume that environment.

## Contents

| Path | What it is |
| --- | --- |
| `*.qmd`, `_quarto.yml` | Source of the instructions website (Quarto) |
| `docs/` | Rendered website, served by GitHub Pages |
| `scripts/` | Helper scripts that participants run on the course server |

### Helper scripts

| Script | What it does |
| --- | --- |
| `setup_pet_course.sh` | Creates `~/pet_course/derivatives` and copies the PETPrep outputs (without report figures) into it |
| `view_petprep.sh`, `view_petsurfer.sh` | Serve a PETPrep or petsurfer report through the Jupyter proxy and print the link |
| `open_ezbids.sh` | Opens ezBIDS in Chromium on the Neurodesk Desktop, logged in, so that ezBIDS can read data on the server |
| `run_bloodstream.sh`, `run_petfit.sh` | Backup launchers for the bloodstream and PETFit apps: run the same commands as the instructions, choose a free port, and print the link |

On the server, the scripts are in `/storage/common/hfbi/pet/scripts` (in Neurodesk: `/neurodesktop-storage/course-material/pet/scripts`).

## Update the website

Edit the `.qmd` files, then render the site into `docs/`:

```bash
quarto render
```

Commit and push both the `.qmd` files and `docs/`. To publish with GitHub Pages, go to **Settings** > **Pages**, choose **Deploy from a branch**, and select the `main` branch and the `/docs` folder.

## Software

- [ezBIDS for PET](https://github.com/openneuropet/ezbids_docker) and [PET2BIDS](https://github.com/openneuropet/PET2BIDS)
- [PETPrep](https://github.com/nipreps/petprep)
- [bloodstream](https://github.com/mathesong/bloodstream)
- [PETFit](https://github.com/mathesong/petfit)
- [Neurodesk](https://www.neurodesk.org)
