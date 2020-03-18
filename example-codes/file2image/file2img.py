import matplotlib.pyplot as plt
import numpy as np
from skimage import color


def file2image(filepath):
    with open(filepath, 'rb') as file:
        content = file.read()
        rows = int.from_bytes(content[:2], byteorder='big', signed=False)
        cols = int.from_bytes(content[2:4], byteorder='big', signed=False)

        img = []
        for i in range(rows):
            row = []
            for j in range(cols):
                row.append(int.from_bytes(content[4 + i * cols + j:4 + i * cols + j + 1], byteorder='big', signed=False))
            img.append(np.array(row).astype(np.uint8))
    plt.imsave(filepath[:-4] + '.jpg', img)


if __name__ == "__main__":
    filepath = 'lechuza.txt'
    file2image(filepath)
