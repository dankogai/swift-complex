ifdef SWIFTPATH
	SWIFTC=$(SWIFTPATH)/swiftc
	SWIFT=$(SWIFTPATH)/swift
else
	SWIFTC=xcrun -sdk macosx swiftc
	SWIFT=swift
endif

MAIN=main
MODSRC=complex/complex.swift complex/exops.swift
SRC=$(MODSRC) complex/main.swift
MODNAME=Complex
MODULE=Complex.swiftmodule Complex.swiftdoc 
SHLIB=libComplex

all: $(MAIN)
module: $(MODSRC)
clean:
	-rm $(MAIN) $(MODULE) $(MODULE) $(SHLIB).*
$(MAIN): $(SRC)
	$(SWIFTC) $(SRC)
test: $(MAIN)
	prove ./main
$(MODULE): $(MODSRC)
	$(SWIFTC) -emit-library -emit-module $(MODSRC) -module-name $(MODNAME)
repl: $(MODULE)
	$(SWIFT) -I. -L. -lComplex
