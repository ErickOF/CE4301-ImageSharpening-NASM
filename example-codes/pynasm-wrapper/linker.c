#include <Python.h>


void _function(void);

static PyObject*
pynasm_function(PyObject* self, PyObject* args) {
    if (!PyArg_ParseTuple(args, "")) {
        return NULL;
    }

    _function();
    Py_RETURN_NONE;
}

static PyMethodDef
PyNasmMethods[] = {
    {"function", pynasm_function, METH_VARARGS, "Execute NASM code"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef
PyNasmModule = {
    PyModuleDef_HEAD_INIT,
    "pynasm", /* name of module */
    NULL,     /* module documentation, may be NULL */
    -1,       /* size of per-interpreter state of the module,
                 or -1 if the module keeps state in global variables. */
    PyNasmMethods
};

PyMODINIT_FUNC
PyInit_pynasm(void) {
    return PyModule_Create(&PyNasmModule);
}
