import numpy as np
from PIL import Image
from skimage import io


class FileManager:
    """Class to manage all files and conversions related with these
    """
    def file2img(self, filepath):
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
            img.save(filepath[:-4] + '.bmp')
        
        return img

    def img2file(self, img_path):
        """Convert image to a txt file, encoded in 8-bit.

        Paramters:
        ----------------------------------------------------------------------
        img_path: str
            Image file name.
        """
        # Load image
        img = io.imread(img_path, as_gray=True)
        img = self.__img_to_8bit(img)

        # Filename to save encoded image
        filename1 = './temp/original.txt'
        filename2 = './temp/sharpening.txt'
        filename3 = './temp/oversharpening.txt'

        # Open file to write
        file1 = open(filename1, 'wb+')
        file2 = open(filename2, 'wb+')
        file3 = open(filename3, 'wb+')

        # Image dimension
        rows, cols = img.shape
        rows_bytes = rows.to_bytes(2, byteorder='big')
        cols_bytes = cols.to_bytes(2, byteorder='big')

        # Write dimensions
        file1.write(rows_bytes)
        file1.write(cols_bytes)
        file2.write(rows_bytes)
        file2.write(cols_bytes)
        file3.write(rows_bytes)
        file3.write(cols_bytes)

        for i in range(rows):
            for j in range(cols):
                # Convert image to 8-bit and write in file
                pixel = int(img[i][j]).to_bytes(1, byteorder='big')
                # Write in file
                file1.write(pixel)
                file2.write(pixel)
                file3.write(pixel)

        # Close files
        file1.close()
        file2.close()
        file3.close()

    def __img_to_8bit(self, img):
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
