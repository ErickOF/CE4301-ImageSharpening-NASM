from PyQt5 import QtWidgets, uic
import sys

from gui.mainwindow import MainWindow


if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    mainwindow = MainWindow()
    mainwindow.show()
    app.exec_()
