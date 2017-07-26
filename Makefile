CC=gcc -std=c99
UNAME_V := $(shell uname -v)
OUTFILE=capsled
CCFLAGS=-D _GNU_SOURCE

ifeq ($(findstring Ubuntu,$(UNAME_V)),Ubuntu)
	CCFLAGS += -D TARGET_UBUNTU
else ifeq ($(findstring Debian,$(UNAME_V)),Debian)
	CCFLAGS += -D TARGET_DEBIAN
else ifeq ($(findstring ARCH,$(shell uname -r)),ARCH)
	CCFLAGS += -D TARGET_ARCH
else
	CCFLAGS += -D TARGET_UNKNOWN
endif

all: capsled.c
	$(CC) $(CCFLAGS) -o $(OUTFILE) $^

clean:
	rm -f capsled
install: all
	install -m 0755 capsled /usr/bin/
	if test -x /usr/bin/systemctl && test -d "/etc/systemd/system"; then install -m0644 capsled.service /etc/systemd/system/capsled.service && systemctl daemon-reload && systemctl start capsled.service && systemctl enable capsled.service; fi
