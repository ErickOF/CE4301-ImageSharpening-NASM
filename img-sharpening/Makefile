.PHONY: install uninstall run test build clean

APP_NAME = asm/filter
TEMP_FOLDER = ./temp
UTILS_FOLDER = ./utils
GUI_FOLDER = ./gui
PYCACHE = __pycache__

install:
	sudo apt-get update
	sudo apt-get install nasm
	sudo apt-get install python3
	sudo apt-get install python3-pyqt5
	sudo apt-get install pyqt5-dev-tools
	sudo apt-get install qttools5-dev-tools

	@if [ -d ${TEMP_FOLDER} ]; then \
		echo "Directory ${TEMP_FOLDER} exists."; \
	else \
		echo "Directory ${TEMP_FOLDER} does not exists. Creating..."; \
		mkdir ${TEMP_FOLDER}; \
		@echo "Folder ${TEMP_FOLDER} was created.\033[0m"; \
	fi

	@echo "\e[1;34mInstallation has been successfully completed.\033[0m";

uninstall:
	sudo apt-get remove nasm
	sudo apt-get install python3-pyqt5
	sudo apt-get install pyqt5-dev-tools
	sudo apt-get install qttools5-dev-tools

build:
	@nasm -f elf64 ${APP_NAME}.asm
	@ld -m elf_x86_64 ${APP_NAME}.o -o ${APP_NAME}
	@rm ${APP_NAME}.o

	@if ! [ -d ${TEMP_FOLDER} ]; then \
		mkdir ${TEMP_FOLDER}; \
	fi

	@echo "\e[1;34mBuild has been successfully completed.\033[0m";

run:
	@if ! [ -f ${APP_NAME} ]; then \
		echo "\e[1;34mBuilding app....\033[0m"; \
		nasm -f elf64 ${APP_NAME}.asm; \
		ld -m elf_x86_64 ${APP_NAME}.o -o ${APP_NAME}; \
		echo "\e[1;34mBuild has been successfully completed.\033[0m"; \
	fi

	@if ! [ -d ${TEMP_FOLDER} ]; then \
		mkdir ${TEMP_FOLDER}; \
		echo "Folder ${TEMP_FOLDER} was created.\033[0m"; \
	fi

	@python3 main.py

clean:
	@if [ -d ${TEMP_FOLDER} ]; then \
		rm -r ${TEMP_FOLDER}; \
		echo "Directory ${TEMP_FOLDER} was removed."; \
	fi

	@if [ -d ${UTILS_FOLDER}/${PYCACHE} ]; then \
		rm -r ${UTILS_FOLDER}/${PYCACHE}; \
	fi

	@if [ -d ${GUI_FOLDER}/${PYCACHE} ]; then \
		rm -r ${GUI_FOLDER}/${PYCACHE}; \
	fi

	echo "${PYCACHE} was removed.";

	@if [ -f ${APP_NAME} ]; then \
		rm ${APP_NAME}; \
		echo "${APP_NAME} was removed."; \
	fi

	@echo "\e[1;34mProject was successfully cleaned.\033[0m";

test:
	@nasm -v
	@python3 -V
	@python3 -c "import os; print(os)"
	@python3 -c "import PyQt5; print(PyQt5)"
	@python3 -c "from PyQt5 import QtWidgets; print(QtWidgets)"
	@python3 -c "from PyQt5 import QtGui; print(QtGui)"
	@python3 -c "from PyQt5 import uic; print(uic)"
	@echo "\e[1;34mYour project modules were successfully tested.\033[0m"
