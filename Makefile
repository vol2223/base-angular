.PHONY: install

install:
	gem install sass
	git submodule init
	git submodule update
	npm install coffee-script -g
	npm install gulp -g
	npm install
	gulp
