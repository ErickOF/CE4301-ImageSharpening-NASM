import sys
import matplotlib.pyplot as plt
from skimage import io


def plot(imgs):
    plt.subplot(131)
    plt.title('Original')
    plt.imshow(imgs['original'], cmap=imgs['color'])
    plt.subplot(132)
    plt.title('Sharpening')
    plt.imshow(imgs['sharpening'], cmap=imgs['color'])
    plt.subplot(133)
    plt.title('Oversharpening')
    plt.imshow(imgs['oversharpening'], cmap=imgs['color'])
    plt.show()

def parse(argv):
    parms = dict()
    for i in range(0, len(argv), 2):
        key = argv[i]
        if key in ['-o', '--oimg']:
            parms['original'] = io.imread(argv[i + 1], as_gray=True)
            parms['sharpening'] = io.imread('sharpening_' + argv[i + 1], as_gray=True)
            parms['oversharpening'] = io.imread('oversharpening_' + argv[i + 1], as_gray=True)
            parms['color'] = 'g'
    return parms


if __name__ == '__main__':
    args = parse(sys.argv[1:])
    plot(args)
