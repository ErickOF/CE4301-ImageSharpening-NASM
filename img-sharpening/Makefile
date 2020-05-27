.PHONY: install uninstall run test build clean

OVERSHARPENING_FILTER = asm/oversharpening
SHARPENING_FILTER = asm/sharpening
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
	sudo apt-get remove python3-pyqt5
	sudo apt-get remove pyqt5-dev-tools
	sudo apt-get remove qttools5-dev-tools

build:
	@nasm -f elf64 ${SHARPENING_FILTER}.asm
	@ld -m elf_x86_64 ${SHARPENING_FILTER}.o -o ${SHARPENING_FILTER}
	@rm ${SHARPENING_FILTER}.o

	@nasm -f elf64 ${OVERSHARPENING_FILTER}.asm
	@ld -m elf_x86_64 ${OVERSHARPENING_FILTER}.o -o ${OVERSHARPENING_FILTER}
	@rm ${OVERSHARPENING_FILTER}.o


	@if ! [ -d ${TEMP_FOLDER} ]; then \
		mkdir ${TEMP_FOLDER}; \
	fi

	@echo "\e[1;34mBuild has been successfully completed.\033[0m";

run:
	@if ! [ -f ${SHARPENING_FILTER} ]; then \
		nasm -f elf64 ${SHARPENING_FILTER}.asm; \
		ld -m elf_x86_64 ${SHARPENING_FILTER}.o -o ${SHARPENING_FILTER}; \
		rm ${SHARPENING_FILTER}.o; \
		echo "\e[1;34mSharpening filter has been successfully built.\033[0m"; \
	fi

	@if ! [ -f ${OVERSHARPENING_FILTER} ]; then \
		nasm -f elf64 ${OVERSHARPENING_FILTER}.asm; \
		ld -m elf_x86_64 ${OVERSHARPENING_FILTER}.o -o ${OVERSHARPENING_FILTER}; \
		rm ${OVERSHARPENING_FILTER}.o; \
		echo "\e[1;34mOversharpening filter has been successfully built.\033[0m"; \
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

	@if [ -f ${SHARPENING_FILTER} ]; then \
		rm ${SHARPENING_FILTER}; \
		echo "${SHARPENING_FILTER} was removed."; \
	fi

	@if [ -f ${OVERSHARPENING_FILTER} ]; then \
		rm ${OVERSHARPENING_FILTER}; \
		echo "${OVERSHARPENING_FILTER} was removed."; \
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
