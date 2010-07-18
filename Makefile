top_srcdir = .
PKG_NAME = mlsound
SOURCES = mlsound.ml
REQUIRES = pfds

include make.common

all: mlsound synth.byte
opt: $(XARCHIVE) synth.opt
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

synth.byte: mlsound.cma synth.cmo
	$(OCAMLC)   -o $@ -package "$(REQUIRES)" -linkpkg $(OCAMLFLAGS) -ccopt libhelper.a unix.cma $^

synth.opt: mlsound.cmxa synth.cmx
	$(OCAMLOPT) -o $@ -package "$(REQUIRES)" -linkpkg $(OCAMLOPTFLAGS) -ccopt libhelper.a unix.cmxa $^


