import numpy as np
from PIL import Image
from skimage import io


class FileManager:
    """Class to manage all files and conversions related with these
    """
    def file2image(self, filepath):
        """Convert a txt file a image, encoded in 8-bit

        Parameters:
        ------------------------------------
        filepath: str
            Path where file is store
        """
        # Open file in byte mode
        with open(filepath, 'rb') as file:
            # Read all file
            content = file.read()
            # Get rows and columns
            rows = int.from_bytes(content[:2], byteorder='big', signed=False)
            cols = int.from_bytes(content[2:4], byteorder='big', signed=False)

            # Var to store image
            img = []

            for i in range(rows):
                row = []
                for j in range(cols):
                    # Convert byte to int
                    row.append(int.from_bytes(content[4 + i * cols + j:4 +\
                         i * cols + j + 1], byteorder='big', signed=False))
                img.append(np.array(row).astype(np.uint8))

            # Convert to image and save
            img = Image.fromarray(np.array(img, dtype=np.uint8))
            img.save(filepath[:-4] + '.jpg')

    def img2file(self, img_path):
        """Convert image to a txt file, encoded in 8-bit.

        Paramters:
        ----------------------------------------------------------------------
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
            img = img // 2
        return img.astype(np.uint8)
