ifdef SUDO_USER
USERPREFIX = /home/$(SUDO_USER)
PREFIX = /usr/local
else
USERPREFIX = $(HOME)
PREFIX = $(USERPREFIX)
endif

CONFDIR = $(USERPREFIX)/.update
BINDIR = $(PREFIX)/bin

install: install-config install-binary
uninstall: uninstall-config uninstall-binary
install-devel: install-config install-binary-devel

install-config:
	install -d $(CONFDIR)/funcs
	install -m 644 config/updaterc $(CONFDIR)/updaterc
install-binary:
	install -Dm 755 update.sh $(BINDIR)/update
install-binary-devel:
	ln -sf $(realpath update.sh) $(BINDIR)/update
uninstall-config:
	rm -r $(CONFDIR)
uninstall-binary:
	rm $(BINDIR)/update

