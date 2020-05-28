import os
from PyQt5 import QtWidgets, QtGui, QtCore, uic
import threading

from utils.filemanager import FileManager


class MainWindow(QtWidgets.QMainWindow):
    """Main Window class
    """
    def __init__(self):
        self.imgpath = os.path.expanduser('~')
        # Call the inherited classes __init__ method
        super(MainWindow, self).__init__()
        # Load the .ui file
        uic.loadUi('./gui/mainwindow.ui', self)
        # Temp fir
        self.__TEMP_DIR = './temp'

        # Input image path
        self.teImage = self.findChild(QtWidgets.QTextEdit, 'teImage')
        self.teImage.setText(self.imgpath)
        self.teImage.setReadOnly(True)

        # Button to load image file
        self.btnOpenImg = self.findChild(QtWidgets.QPushButton, 'btnOpenImg')
        self.btnOpenImg.clicked.connect(self.__btnOpenImgOnClick)

        # Button to Filter images
        self.btnFilter = self.findChild(QtWidgets.QPushButton, 'btnFilter')
        self.btnFilter.clicked.connect(self.__btnFilterOnClick)

        # Label to show status
        self.lbStatus = self.findChild(QtWidgets.QLabel, 'lbStatus')

        # Tabs where images are placed
        self.tabWidget = self.findChild(QtWidgets.QTabWidget, 'tabImages')
        self.tabOriginal = self.tabWidget.findChild(QtWidgets.QWidget,
                                    'tabOriginal')
        self.tabSharpening = self.tabWidget.findChild(QtWidgets.QWidget,
                                    'tabSharpening')
        self.tabOverSharpening = self.tabWidget.findChild(QtWidgets.QWidget,
                                    'tabOverSharpening')

    def __btnOpenImgOnClick(self):
        # Get image path
        imgpath = QtWidgets.QFileDialog.getOpenFileName(self, 'Open image',
                                                '', 'Image files (*.bmp)')
        self.imgpath = imgpath[0]
        # Set image text in text edit
        self.teImage.setText(self.imgpath)
        FileManager().rgb2gray(self.imgpath)
        # Show image
        original = QtGui.QPixmap('./temp/original.bmp').scaled(640, 480, QtCore.Qt.KeepAspectRatio)
        lbOriginal = self.tabOriginal.findChild(QtWidgets.QLabel, 'lbOriginal')
        lbOriginal.setPixmap(QtGui.QPixmap(original))

    def __filter(self):
        # Check if folder exists
        if not os.path.exists(self.__TEMP_DIR) and not os.path.isdir(self.__TEMP_DIR):
            # Create temp dir to store temp files
            os.mkdir(self.__TEMP_DIR)

        # Convert loaded image in a file
        print('Converting image to file...')
        FileManager().img2file(self.imgpath)

        print('Applying sharpening kernel...')
        os.system('cd asm && ./sharpening')
        print('Converting to an image...')
        # Convert processing images
        FileManager().file2img('./temp/sharpening.txt')

        print('Applying oversharpening kernel...')
        os.system('cd asm && ./oversharpening')
        print('Converting to an image...')
        # Convert processing images
        FileManager().file2img('./temp/oversharpening.txt')

        # Set images
        sharpening = QtGui.QPixmap('./temp/sharpening.bmp').scaled(640, 480, QtCore.Qt.KeepAspectRatio)
        lbSharpening = self.tabSharpening.findChild(QtWidgets.QLabel, 'lbSharpening')
        lbSharpening.setPixmap(sharpening)

        oversharpening = QtGui.QPixmap('./temp/oversharpening.bmp').scaled(640, 480, QtCore.Qt.KeepAspectRatio)
        lbOverSharpening = self.tabOverSharpening.findChild(QtWidgets.QLabel, 'lbOverSharpening')
        lbOverSharpening.setPixmap(oversharpening)

        self.lbStatus.setText('Ready!')

    def __btnFilterOnClick(self):
        if os.path.exists(self.imgpath) and os.path.isfile(self.imgpath):
            self.lbStatus.setText('Filtering...')
            t_filter = threading.Thread(target=self.__filter)
            t_filter.start()
        else:
            self.__show_dialog()

    def __show_dialog(self):
        msg = QtWidgets.QMessageBox()
        msg.setIcon(QtWidgets.QMessageBox.Warning)

        msg.setText("You must select an image.")
        msg.setWindowTitle("Image not found!")
        msg.setStandardButtons(QtWidgets.QMessageBox.Ok)
	
        retval = msg.exec_()
