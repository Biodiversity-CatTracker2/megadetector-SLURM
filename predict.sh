#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --job-name='predict'
#SBATCH --mem=32gb
#SBATCH --ntasks-per-node=48
#SBATCH --error=%J.err
#SBATCH --output=%J.out
#-------------------------------------
# Parent dir where deployments dirs are stored
PARENT_DIRECTORY='PLACEHOLDER_DIR'  # <<<<<<<<<<<<<<<<<<<<<<
REMOTE='PLACEHOLDER_REMOTE'  # <<<<<<<<<<<<<<<<<<<<<<
#-------------------------------------
module unload python
module load anaconda
module load cuda/10.2
module load rclone
conda activate yolov5
#-------------------------------------
if ! [ -f 'md_v5a.0.0.pt' ]; then
  VERS='v5.0/md_v5a.0.0.pt'
  wget "https://github.com/microsoft/CameraTraps/releases/download/${VERS}" \
    -O 'md_v5a.0.0.pt'
fi
#-------------------------------------
DIRECTORIES=$(
  python -c "from glob import glob; \
    print(' '.join(
    [f'\"{x}\"' for x in glob('$PARENT_DIRECTORY/*') if '-results' not in x
    and '-with-detection-original' not in x and 'archived' not in x.lower()]))"
)
#-------------------------------------
for DIRECTORY in ${DIRECTORIES[*]}; do
  python yolov5/detect.py \
    --weights 'md_v5a.0.0.pt' \
    --source "$DIRECTORY" \
    --device 'cpu' \
    --save-txt --save-conf \
    --project "${DIRECTORY}-results" \
    --name ''
done
#-------------------------------------
for DIRECTORY in ${DIRECTORIES[*]}; do
  python filter_results.py "$DIRECTORY" || exit 1
done
#-------------------------------------
for DIRECTORY in ${DIRECTORIES[*]}; do
  rclone cop "${DIRECTORY}-with-detection-original" \
    "$REMOTE":"${PARENT_DIRECTORY}/${DIRECTORY}-with-detection-original" \
    --drive-shared-with-me -P --stats-one-line --transfers 100
done
#-------------------------------------
mkdir -p "${PARENT_DIRECTORY}/archived"
for DIRECTORY in ${DIRECTORIES[*]}; do
  mv "${DIRECTORY}" "${PARENT_DIRECTORY}/archived"
  mv "${DIRECTORY}-results" "${PARENT_DIRECTORY}/archived"
  mv "${DIRECTORY}-with-detection-original" "${PARENT_DIRECTORY}/archived"
done
