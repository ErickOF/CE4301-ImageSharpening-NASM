from distutils.core import setup, Extension

setup(name='pynasm',
    ext_modules=[
        Extension('pynasm', ['linker.c'], extra_objects=['main.o'])
    ]
)
