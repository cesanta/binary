CWD ?= $(realpath $(CURDIR))
VERSION ?= queue

all: linux macos windows

linux: mongoose
	$(MAKE) -C mongoose/examples/http-server PROG=mongoose_$@ CC=musl-gcc CFLAGS_EXTRA="-static -s -Os"
	mv mongoose/examples/http-server/mongoose_$@ .

windows: mongoose
	$(MAKE) -C mongoose/examples/http-server PROG=mongoose.exe \
          CC="docker run --platform linux/amd64 --rm -v $(CWD):$(CWD) -w $(CWD)/mongoose/examples/http-server mdashnet/vc22 wine64 cl" \
          CFLAGS="/MD /nologo"
	mv mongoose/examples/http-server/mongoose.exe .

macos: mongoose
	$(MAKE) -C mongoose/examples/http-server PROG=mongoose_$@ mongoose_$@
	mv mongoose/examples/http-server/mongoose_$@ .

mongoose:
	git clone --depth 1 -b $(VERSION) https://github.com/cesanta/mongoose $@
