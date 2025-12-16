CWD ?= $(realpath $(CURDIR))
PROJ = mongoose/tutorials/http/http-server
VERSION ?= 7.20

all: linux macos windows

linux: mongoose
	$(MAKE) -C $(PROJ) example CC=musl-gcc CFLAGS_EXTRA="-static -s -Os"
	mv $(PROJ)/example mongoose_$@

windows: mongoose
	$(MAKE) -C $(PROJ) example \
          CC="docker run --platform linux/amd64 --rm -v $(CWD):$(CWD) -w $(CWD)/$(PROJ) mdashnet/vc98 wine cl" \
          CFLAGS="/MD /nologo /Os" \
          CFLAGS_EXTRA="-UMG_ENABLE_IPV6" \
          OUT=/Femongoose.exe
	mv $(PROJ)/mongoose.exe .

macos: mongoose
	$(MAKE) -C $(PROJ) example CFLAGS_EXTRA="-Os"
	mv $(PROJ)/example mongoose_$@

version:
	echo $(VERSION)

mongoose:
	git clone --depth 1 -b $(VERSION) https://github.com/cesanta/mongoose $@

clean:
	rm -rf mongoose*
