ifdef SWIFTPATH
	SWIFTC=$(SWIFTPATH)/swiftc
	SWIFT=$(SWIFTPATH)/swift
else
	SWIFTC=xcrun -sdk macosx swiftc
	SWIFT=swift
endif

MOD=Complex
BIN=main
MODSRC=complex/complex.swift complex/exops.swift
SRC=$(MODSRC) complex/main.swift complex/tap.swift
MODULE=$(MOD).swiftmodule $(MOD).swiftdoc

all: $(BIN)
module: $(MODULE)
clean:
	-rm $(BIN) $(MODULE) lib$(MOD).*
$(BIN): $(SRC)
	$(SWIFTC) $(SRC)
test: $(BIN)
	prove ./main
$(MODULE): $(MODSRC)
	$(SWIFTC) -emit-library -emit-module $(MODSRC) -module-name $(MOD)
repl: $(MODULE)
	$(SWIFT) -I. -L. -l$(MOD)
