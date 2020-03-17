from PyQt5 import QtWidgets, uic


class MainWindow(QtWidgets.QMainWindow):
    """Main Window class
    """
    def __init__(self):
        # Call the inherited classes __init__ method
        super(MainWindow, self).__init__()
        # Load the .ui file
        uic.loadUi('./gui/mainwindow.ui', self)
