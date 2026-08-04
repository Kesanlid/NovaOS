# NovaOS Plymouth Theme Makefile
# Install with: sudo make install

PREFIX ?= /usr/share/plymouth/themes
THEME := nova

install:
	install -Dm644 $(THEME).plymouth $(DESTDIR)$(PREFIX)/$(THEME)/$(THEME).plymouth
	install -Dm644 $(THEME).script $(DESTDIR)$(PREFIX)/$(THEME)/$(THEME).script
	install -Dm644 $(THEME).grub $(DESTDIR)$(PREFIX)/$(THEME)/$(THEME).grub

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/$(THEME)

.PHONY: install uninstall
