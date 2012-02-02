ifdef SUDO_USER
USERPREFIX = /home/$(SUDO_USER)
PREFIX = /usr/local
else
USERPREFIX = $(HOME)
PREFIX = $(USERPREFIX)
endif

UPDATECONFDIR = $(USERPREFIX)/.update
CHECKCONFDIR = $(USERPREFIX)/.check
BINDIR = $(PREFIX)/bin

install: install-config install-binary
uninstall: uninstall-config uninstall-binary
install-devel: install-config install-binary-devel

install-config:
	install -d $(UPDATECONFDIR)/funcs
	install -d $(CHECKCONFDIR)/funcs
	install -m 644 config/updaterc $(UPDATECONFDIR)/updaterc
	install -m 644 config/checkrc $(CHECKCONFDIR)/checkrc
install-binary:
	install -Dm 755 update.sh $(BINDIR)/update
	install -Dm 755 check.sh $(BINDIR)/check
	install -Dm 755 run.sh $(BINDIR)/run.sh
install-binary-devel:
	ln -sf $(realpath update.sh) $(BINDIR)/update
	ln -sf $(realpath check.sh) $(BINDIR)/check
	ln -sf $(realpath run.sh) $(BINDIR)/run.sh
uninstall-config:
	rm -r $(UPDATECONFDIR)
	rm -r $(CHECKCONFDIR)
uninstall-binary:
	rm $(BINDIR)/update
	rm $(BINDIR)/check
	rm $(BINDIR)/run.sh
