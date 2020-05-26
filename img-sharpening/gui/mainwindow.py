import os
from PyQt5 import QtWidgets, QtGui, uic
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
        # Show image
        lbOriginal = self.tabOriginal.findChild(QtWidgets.QLabel, 'lbOriginal')
        lbOriginal.setPixmap(QtGui.QPixmap(self.imgpath))

    def __filter(self):
        # Check if folder exists
        if not os.path.exists(self.__TEMP_DIR) and not os.path.isdir(self.__TEMP_DIR):
            # Create temp dir to store temp files
            os.mkdir(self.__TEMP_DIR)

        # Convert loaded image in a file
        FileManager().img2file(self.imgpath)

        # Convert processing images
        sharpening = FileManager().file2img('./temp/sharpening.txt')
        unsharpening = FileManager().file2img('./temp/oversharpening.txt')

        # Set images
        lbSharpening = self.tabSharpening.findChild(QtWidgets.QLabel, 'lbSharpening')
        lbSharpening.setPixmap(QtGui.QPixmap('./temp/sharpening.bmp'))
        lbOverSharpening = self.tabOverSharpening.findChild(QtWidgets.QLabel, 'lbOverSharpening')
        lbOverSharpening.setPixmap(QtGui.QPixmap('./temp/oversharpening.bmp'))

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
