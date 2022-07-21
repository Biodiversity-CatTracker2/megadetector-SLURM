#!/usr/bin/env python
# coding: utf-8

import shutil
import sys
from glob import glob
from pathlib import Path

from tqdm import tqdm


def get_originals(originals_dir: str) -> None:
    labels_dir = f'{originals_dir}-results/labels'
    images = [x for x in glob(f'{originals_dir}/*') if Path(x).is_file()]
    labels = sorted(glob(f'{labels_dir}/*'))
    labels_stem = [Path(x).stem for x in labels]
    images_with_detections = sorted(
        [x for x in images if Path(x).stem in labels_stem])

    print(len(images_with_detections), len(labels))
    assert len(images_with_detections) == len(labels)
    for x, y in zip(images_with_detections, labels):
        assert Path(x).stem == Path(y).stem

    with_detection_dir_original = f'{originals_dir}-with-detection-original'
    Path(with_detection_dir_original).mkdir(exist_ok=True)

    for im in tqdm(images_with_detections):
        shutil.copy2(im, with_detection_dir_original)


if __name__ == '__main__':
    get_originals(sys.argv[1])
