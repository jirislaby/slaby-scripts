prefix=/usr
bindir=$(prefix)/bin
datadir=$(prefix)/share
perllibdir=$(shell eval `perl -V:installsitelib`; echo $$installsitelib)

INSTALL=install
INSTALL_DIR=$(INSTALL) -d
INSTALL_DATA=$(INSTALL) -m 644

BIN_FILES=$(patsubst bin/%,%,$(wildcard bin/*))
DATA_FILES=$(patsubst data/%,%,$(wildcard data/*))
PERLLIB_FILES=StableHelper.pm

all:

clean:

install: bin-install data-install perllib-install
	@:

bin-install:
	$(call install,$(INSTALL),bin/,$(BIN_FILES),$(DESTDIR)/$(bindir)/)

data-install:
	$(call install,$(INSTALL_DATA),data/,$(DATA_FILES),$(DESTDIR)/$(datadir)/slaby-scripts/)

perllib-install:
	$(call install,$(INSTALL_DATA),perl/,$(PERLLIB_FILES),$(DESTDIR)/$(perllibdir)/)

.PHONY: all clean install bin-install data-install perllib-install

# install_dir <dir>
install_dir = $(info [Id] $1) \
	$(shell $(INSTALL_DIR) $1)

# install_file <install_cmd> <src_file> <dest_dir>
install_file = $(info [I] $2 -> $3) \
	$(shell $1 $2 $3)

# install <install_cmd> <src_dir> <file_list> <dest_dir>
install = $(call install_dir,$4) \
	$(foreach file,$3,$(call install_file,$1,$2/$(file),$4))
