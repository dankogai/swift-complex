#ifndef BUILD
BUILD=xcrun -sdk macosx swiftc
#endif
TARGET=main
SRC=complex/*.swift

all:$(TARGET)

clean:
	rm $(TARGET)
$(TARGET): $(SRC)
	$(BUILD) complex/*.swift
test: $(TARGET)
	prove ./main
