.PHONY: install build uninstall run test

APP_NAME = asm/filter

install:
	sudo apt-get update
	sudo apt-get install nasm
	sudo apt-get install python3
	sudo apt-get install python3-pyqt5
	sudo apt-get install pyqt5-dev-tools
	sudo apt-get install qttools5-dev-tools

uninstall:
	sudo apt-get remove nasm
	sudo apt-get install python3-pyqt5
	sudo apt-get install pyqt5-dev-tools
	sudo apt-get install qttools5-dev-tools

run:
	nasm -f elf64 ${APP_NAME}.asm
	ld -m elf_x86_64 ${APP_NAME}.o -o ${APP_NAME}
	rm ${APP_NAME}.o

test:
	nasm -v
	python3 -V
	python -c "import os"
	python -c "from PyQt5 import QtWidgets"
	python -c "from PyQt5 import QtGui"
	python -c "from PyQt5 import uic"
	@echo "\e[1;34mYour project's modules were correctly tested.\033[0m"
