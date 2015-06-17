PYTHON	   =python
PYPATH	   =python
MLPATH	   =ocaml/src
MLTESTPATH =ocaml/test
DPREFIX	   =/usr/local
DOCMLPATH  =../../doc/generated/ocaml
DOCREFPATH =doc/manual
MLLIBDIR=../../python/bnew

all:	
	@echo "Compiling OCaml part................................................."
	@make -C $(MLPATH) all DEBUG=$(DEBUG)
	@echo "Building python part................................................."
	@make -C $(PYPATH) all


install: all
	@echo "Installing Ocaml part................................................"
	make -C $(MLPATH) LIBDIR=$(MLLIBDIR) install
	@echo "Installing Python part..............................................."
	make -C $(PYPATH) install


test: all
	py.test -q test/test_caml.py
	make -C $(MLTESTPATH) all

doc: all
	@mkdir -p doc/generated
	@echo "Generating OCaml documentation......................................."
	@make -C $(MLPATH) DOCPATH=$(DOCMLPATH) doc 
	@echo "Generating Python documentation......................................"
	@make -C $(PYPATH) doc
	@echo "Generating reference manual.........................................."
	@make -C $(DOCREFPATH) all

clean:
	@echo "Cleaning OCaml part.................................................."
	@make -C $(MLPATH) clean
	@echo "Cleaning python part................................................."
	@make -C $(PYPATH) clean
	echo "Cleaning documentation................................................"
	-rm -rf $(DOCGENPATH)
	-rm -rf $(PYPATH)/tests/__pycache__
	@make -C $(DOCREFPATH) clean


.PHONY: install clean
