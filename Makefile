CWD ?= $(realpath $(CURDIR))
VERSION ?= 7.12

all: linux macos windows

linux: mongoose
	$(MAKE) -C mongoose/examples/http-server example CC=musl-gcc CFLAGS_EXTRA="-static -s -Os"
	mv mongoose/examples/http-server/example mongoose_$@

windows: mongoose
	$(MAKE) -C mongoose/examples/http-server example \
          CC="docker run --platform linux/amd64 --rm -v $(CWD):$(CWD) -w $(CWD)/mongoose/examples/http-server mdashnet/vc98 wine cl" \
          CFLAGS="/MD /nologo /Os" \
          CFLAGS_EXTRA="-UMG_ENABLE_IPV6" \
          OUT=/Femongoose.exe
	mv mongoose/examples/http-server/mongoose.exe .

macos: mongoose
	$(MAKE) -C mongoose/examples/http-server example CFLAGS_EXTRA="-Os"
	mv mongoose/examples/http-server/example mongoose_$@

version:
	echo $(VERSION)

mongoose:
	git clone --depth 1 -b $(VERSION) https://github.com/cesanta/mongoose $@

clean:
	rm -rf mongoose*
