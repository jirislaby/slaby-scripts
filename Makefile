prefix=/usr
bindir=$(prefix)/bin

INSTALL=install

BIN_FILES=stableup sussh

all:

clean:

install:
	@echo [I] $(DESTDIR)/$(bindir)/
	@$(INSTALL) -d $(DESTDIR)/$(bindir)/
	@for bin in $(BIN_FILES); do \
		echo "[I] $$bin -> $(DESTDIR)/$(bindir)/"; \
		$(INSTALL) $$bin $(DESTDIR)/$(bindir)/; \
	done

.PHONY: all clean
