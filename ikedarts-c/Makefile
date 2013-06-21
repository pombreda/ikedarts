
CFLAGS+=-Wall -g
exe=ikedarts
# test data
# todo: make a shippable dict for reproducible test
dict=/usr/share/dict/words
doc=README
#doc=/usr/share/doc/bash/FAQ

all: $(exe)

$(exe): ikedarts.o ikedarts_main.o ikedarts.h
	g++ $^ -o $@

clean:
	rm -f *.o $(exe)

clean-data:
	rm -f words.txt words.da test.out

words.txt:
	env LC_ALL=C sort -u $(dict) \
	| awk '{ if (length($$1)>=3) { print } }' \
	> $@

words.da: words.txt
	mkdarts $< $@

test: ikedarts words.da
	head $(doc) | ./ikedarts words.da > test.out
	diff test.out test.ref.out

t:
	cat README | ./ikedarts words.da
