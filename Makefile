#ifndef SWIFTC
SWIFTC=xcrun -sdk macosx swiftc
#endif
MAIN=main
MODSRC=complex/complex.swift complex/exops.swift
SRC=$(MODSRC) complex/main.swift
MODNAME=Complex
MODULE=Complex.swiftdoc Complex.swiftmodule libComplex.dylib

all: $(MAIN)
clean:
	-rm $(MAIN) $(MODULE)
$(MAIN): $(SRC)
	$(SWIFTC) $(SRC)
test: $(MAIN)
	prove ./main
module: $(MODSRC)
$(MODULE): $(MODSRC)
	$(SWIFTC) -emit-library -emit-module $(MODSRC) -module-name $(MODNAME)
repl: $(MODULE)
	swift -I. -L. -lComplex
