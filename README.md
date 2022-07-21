# Megadetector-v5 SLURM

## Getting started

```sh
git clone 'https://github.com/Biodiversity-CatTracker2/megadetector-v5-SLURM.git'
git clone 'https://github.com/ultralytics/yolov5.git'

module load anaconda
conda create -n yolov5 python=3.8 --yes
conda activate yolov5
pip install -r yolov5/requirements.txt
```

## Usage

```sh
cd megadetector-v5-SLURM
```

- Edit `download.sh` to replace the placeholders, then run:

```sh
sbatch download.sh
```

- When download is over, edit `predict.sh` to replace the placeholders, then run:

```sh
sbatch predict.sh
```

- Get the `<jobid>.err` file and create a channel on [notify.run](https://notify.run/), edit `check.sh` to replace the placeholders, then run:

```sh
sbatch check.sh
```

## Notes

- **Remove `--drive-shared-with-me` from `download.sh` and `predict.sh` if the folder is not a shared folder.**
