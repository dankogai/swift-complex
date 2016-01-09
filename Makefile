#ifndef BUILD
BUILD=xcrun -sdk macosx swiftc
#endif

clean:
	rm main
main:
	$(BUILD) complex/*.swift
test: main
	prove ./main
