# NovaOS SDDM Theme Makefile

DESTDIR ?= /usr/share/sddm/themes
THEME := nova

all:
	@echo "SDDM theme requires QML files - see Main.qml"

install:
	install -dm755 $(DESTDIR)/$(THEME)
	install -m644 theme.conf $(DESTDIR)/$(THEME)/
	install -m644 Main.qml $(DESTDIR)/$(THEME)/
	install -m644 Background.qml $(DESTDIR)/$(THEME)/ 2>/dev/null || true
	install -m644 login.png $(DESTDIR)/$(THEME)/ 2>/dev/null || true
	install -m644 background.png $(DESTDIR)/$(THEME)/ 2>/dev/null || true
	install -m644 logo.png $(DESTDIR)/$(THEME)/ 2>/dev/null || true

uninstall:
	rm -rf $(DESTDIR)/$(THEME)

.PHONY: all install uninstall
