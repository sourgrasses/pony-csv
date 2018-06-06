build/csv: build csv/*.pony
	ponyc csv -o build --debug

build:
	mkdir build

test: build/csv
	build/csv

clean:
	rm -rf build

.PHONY: clean test
