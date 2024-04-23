EXE := lm4flash

CC ?= gcc
CFLAGS += -Wall

ifeq ($(shell uname),FreeBSD)
LDFLAGS += -lusb
else
CFLAGS += $(shell pkg-config --cflags libusb-1.0)
ifeq ($(USE_STATIC_LIBS),1)
LDFLAGS += -Wl,-Bstatic $(shell pkg-config --static --libs libusb-1.0) -Wl,-Bdynamic
else
LDFLAGS += $(shell pkg-config --libs libusb-1.0)
endif
endif

all: $(EXE)

release: CFLAGS += -O2
release: $(EXE)

debug: CFLAGS += -g -DDEBUG
debug: $(EXE)

$(EXE): $(EXE).c
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

install: $(EXE)
ifndef PREFIX
	$(error PREFIX is not set)
endif
	mkdir -p $(PREFIX)/bin
	install $^ $(PREFIX)/bin/

clean:
	rm -f *.o $(EXE)

.PHONY: all clean
