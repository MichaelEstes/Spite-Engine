cl /c /std:c11 /experimental:c11atomics atomicFFI.c
LIB.EXE /MACHINE:X64 atomicFFI.obj
LINK.EXE /DLL /MACHINE:X64 atomicFFI.obj