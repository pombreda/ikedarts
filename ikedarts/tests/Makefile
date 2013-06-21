
all: words.da

dict=/usr/share/dict/words

words.txt:
	env LC_ALL=C sort -u $(dict) \
	| awk '{ if (length($$1)>=3) { print } }' \
	> $@

words.da: words.txt
	mkdarts $< $@

test:
	python test.py

