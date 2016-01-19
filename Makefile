#ifndef SWIFTC
SWIFTC=xcrun -sdk macosx swiftc
#endif
TARGET=main
SRC=complex/*.swift

all:$(TARGET)

clean:
	rm $(TARGET)
$(TARGET): $(SRC)
	$(SWIFTC) $(SRC)
test: $(TARGET)
	prove ./main
