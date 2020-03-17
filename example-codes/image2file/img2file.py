import numpy as np
from skimage import io


def img_to_file(img, img_path):
    """Convert image to a txt, encoded in 8-bit.

    Paramters:
    ----------------------------------------
    img: ndarray
        Read image in gray scale (2D-array).
    img_path: str
        Image file name.
    """
    # Filename to save encoded image
    filename = img_path[:-4] + '.txt'
    # Open image
    with open(filename, 'wb') as file:
        for i in range(len(img)):
            for j in range(len(img[i])):
                # Convert image to 8-bit and write in file
                file.write(int(img[i][j]).to_bytes(1, byteorder='big'))

def img_to_8bit(img):
    """Convert an image in a 8-bit image.

    Parameters
    ----------------------------------------
    img: ndarray
        Read image in gray scale (2D-array).
    
    Returns
    ----------------------------------------
        The image converted in an 8-bit image.
    """
    # Convert depending of data type
    if img.dtype == np.float64 or img.dtype == np.float32 or img.dtype == np.float16:
        img = 256 * img
    elif img.dtype == np.int16:
        img = img / 2
    return img.astype(np.uint8)


if __name__ == '__main__':
    img_name = input('Image path: ')
    img = io.imread(img_name, as_gray=True)
    img = img_to_8bit(img)

    img_to_file(img, img_name)
