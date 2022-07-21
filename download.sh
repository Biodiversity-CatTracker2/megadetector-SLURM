#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --job-name='download'
#SBATCH --ntasks-per-node=30
#SBATCH --error=%J.err
#SBATCH --output=%J.out
#-------------------------------------
module load rclone

REMOTE="PLACEHOLDER_REMOTE"
PARENT_DIR="PLACEHOLDER_DIR"
DIRECTORIES=("PLACEHOLDER_SUBDIR_1" "PLACEHOLDER_SUBDIR_2")

for DIRECTORY in $DIRECTORIES; do
  rclone --drive-shared-with-me copy \
    ${REMOTE}:"${PARENT_DIR}/${DIRECTORY}" \
    "${PARENT_DIR}/${DIRECTORY}" -P --transfers 100
done
