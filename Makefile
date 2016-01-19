#ifndef SWIFTC
SWIFTC=xcrun -sdk macosx swiftc
#endif
TARGET=main
SRC=complex/*.swift
MODSRC=complex/complex.swift complex/exops.swift
all:$(TARGET)

clean:
	rm $(TARGET)
$(TARGET): $(SRC)
	$(SWIFTC) $(SRC)
test: $(TARGET)
	prove ./main
# Currently broken
module: $(MODSRC)
	$(SWIFTC) -emit-module $(MODSRC) -module-name Complex
