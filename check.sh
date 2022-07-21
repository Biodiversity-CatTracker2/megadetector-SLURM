#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --job-name='check'
#SBATCH --ntasks-per-node=1
#-------------------------------------
CHANNEL="PLACEHOLDER_CHANNEL"
ERR_FILE="PLACEHOLDER_ERR_FILE"

while true; do
  curl "$CHANNEL" -d "$(tail -1 $ERR_FILE)"
  sleep 10
done
