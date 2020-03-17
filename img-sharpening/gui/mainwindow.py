import os
from PyQt5 import QtWidgets, QtGui, uic

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
                            '', 'Image files (*.bmp *.jpg *.png)')
        self.imgpath = imgpath[0]
        # Set image text in text edit
        self.teImage.setText(self.imgpath)
        # Show image
        lbOriginal = self.tabOriginal.findChild(QtWidgets.QLabel, 'lbOriginal')
        lbOriginal.setPixmap(QtGui.QPixmap(self.imgpath))

    def __btnFilterOnClick(self):
        # Create temp dir to store temp files
        os.mkdir('temp')
        # Convert loaded image in a file
        FileManager().img2file(self.imgpath)

