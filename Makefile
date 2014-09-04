
#ve=$(PWD)/ve
#python=$(ve)/bin/python
python=python

# xx is there a better way to ask python for the include directory path?
python_version=$(shell python --version 2>&1 | sed 's/Python \(.*\)\.[0-9]$$/\1/' )

CFLAGS+=-I../ikedarts -I/usr/include/python$(python_version)

all: $(ve)
	$(python) setup.py build_ext --inplace --debug

$(ve):
	virtualenv $@

clean:
	rm -f *.so TAGS
	rm -fr build *.egg-info dist
	find . -name '*.pyc' -delete
	find . -name '*.darts' -delete

scrub: clean
	rm -fr ve *.egg *.egg-info

_ikedarts.so: 
	$(python) setup.py build_ext --inplace

sdist:
	$(python) setup.py sdist

develop:
	$(python) setup.py develop

# install in a traditional unixy way, just laying out 
# the files, instead of resorting to fragile, cutesy tricks
# like eggs and pth.
root=/
install:
	$(python) setup.py install \
		--root=$(root) \
		--single-version-externally-managed

install0: $(ve)
	$(python) setup.py install

test:
	$(python) setup.py test

etags:
	etags `find $(PWD) -type f -not -name TAGS`

########

t: _ikedarts.so
	$(python) test.py
tt:
	cat README.md | $(python) ikedarts.py ikedarts-c/words.da

p:
	@echo $(python_version)
	@echo $(CFLAGS)

test-build: sdist
	rm -fr tmp
	mkdir -p tmp
	cd tmp; tar xzf $(PWD)/dist/ikedarts-0.1.1.tar.gz
	cd tmp/ikedarts*;  python setup.py build
