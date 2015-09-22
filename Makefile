clean:
	rm main
main:
	xcrun -sdk macosx swiftc complex/*.swift
test: main
	prove ./main
