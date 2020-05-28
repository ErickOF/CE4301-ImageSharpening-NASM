# Computer Architecture I - Image Sharpening

This project contains an implementation fo the sharpening and over-sharpening filter.

Two kernels was developed based on the Sobel and Emboss filters and the identity and edge
detection kernels.

## Dependencies
* [Make](https://www.gnu.org/software/make/)
* [NASM](https://www.nasm.us/)
* [Python3.x](https://www.python.org/)
* [PyQt5](https://pypi.org/project/PyQt5/)

## Commands
### Instalation
To install all dependecies, only run

```shell
make install
```

To test if you've got all modules installed, only run

```shell
make test
```

and the version of each module will be shown.

### Build
To build the project, only run

```shell
make build
```

### Run
To run the project

```shell
make run
```

**Note:** No need to run the command `make build` before this.
It will build automatically the project if the built is not found.

### Clean
To remove all builts and temp files, only run

```shell
make clean
```

### Uninstall
To remove all installed package, only run

```shell
make uninstall
```
