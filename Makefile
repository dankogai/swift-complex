SWIFTC=swiftc
SWIFT=swift
ifdef SWIFTPATH
	SWIFTC=$(SWIFTPATH)/swiftc
	SWIFT=$(SWIFTPATH)/swift
endif
OS := $(shell uname)
ifeq ($(OS),Darwin)
	SWIFTC=xcrun -sdk macosx swiftc
endif

MOD=Complex
BIN=main
MODSRC=complex/complex.swift complex/exops.swift
BINSRC=$(MODSRC) complex/main.swift complex/tap.swift
MODULE=$(MOD).swiftmodule $(MOD).swiftdoc

all: $(BIN)
module: $(MODULE)
clean:
	-rm $(BIN) $(MODULE) lib$(MOD).*
$(BIN): $(BINSRC)
	$(SWIFTC) $(BINSRC)
test: $(BIN)
	prove ./main
$(MODULE): $(MODSRC)
	$(SWIFTC) -emit-library -emit-module $(MODSRC) -module-name $(MOD)
repl: $(MODULE)
	$(SWIFT) -I. -L. -l$(MOD)
