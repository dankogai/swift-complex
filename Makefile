ifdef SWIFTPATH
	SWIFTC=$(SWIFTPATH)/swiftc
	SWIFT=$(SWIFTPATH)/swift
else
	SWIFTC=xcrun -sdk macosx swiftc
	SWIFT=swift
endif

MOD=Complex
MAIN=main
MODSRC=complex/complex.swift complex/exops.swift
SRC=$(MODSRC) complex/main.swift complex/tap.swift
MODULE=$(MOD).swiftmodule $(MOD).swiftdoc

all: $(MAIN)
module: $(MODULE)
clean:
	-rm $(MAIN) $(MODULE) lib$(MOD).*
$(MAIN): $(SRC)
	$(SWIFTC) $(SRC)
test: $(MAIN)
	prove ./main
$(MODULE): $(MODSRC)
	$(SWIFTC) -emit-library -emit-module $(MODSRC) -module-name $(MOD)
repl: $(MODULE)
	$(SWIFT) -I. -L. -l$(MOD)
