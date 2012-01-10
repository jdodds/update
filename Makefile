install:
	install-devel

install-devel:
	ln -sf "$(realpath update.sh)" "$(HOME)/bin/update"
