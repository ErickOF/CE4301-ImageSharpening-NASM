import numpy as np
from skimage import io

class FileManager:
    def img2file(self, img_path):
        """Convert image to a txt, encoded in 8-bit.

        Paramters:
        ----------------------------------------
        img_path: str
            Image file name.
        """
        # Load image
        img = io.imread(img_path, as_gray=True)
        img = self.img_to_8bit(img)

        # Filename to save encoded image
        filename = './temp/original.txt'

        # Open image
        with open(filename, 'wb+') as file:
            for i in range(len(img)):
                for j in range(len(img[i])):
                    # Convert image to 8-bit and write in file
                    file.write(int(img[i][j]).to_bytes(1, byteorder='big'))

    def img_to_8bit(self, img):
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
