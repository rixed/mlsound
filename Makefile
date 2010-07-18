top_srcdir = .
PKG_NAME = mlsound
SOURCES = mlsound.ml
REQUIRES = pfds

include make.common

all: mlsound
opt: $(XARCHIVE)
check: $(ARCHIVE) $(XARCHIVE)

clean-spec:
	rm -f mlsound

.PHONY: run
run: mlsound
	rlwrap ./mlsound -rectypes -init init.ml

libhelper.a: helper.o
	$(AR) rcs $@ $^

mlsound: libhelper.a $(ARCHIVE)
	$(OCAMLMKTOP) -package "$(REQUIRES)" -o $@ -ccopt libhelper.a -rectypes -custom unix.cma $(ARCHIVE)

