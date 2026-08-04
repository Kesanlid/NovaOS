# NovaOS GRUB Theme Makefile

DESTDIR ?= /boot/grub/themes
THEME := nova

all: background.png

background.png:
	# Create a simple gradient background
	# In production, use an actual wallpaper image
	@echo "Create background.png manually or copy from branding/wallpapers"

install: background.png
	install -dm755 $(DESTDIR)/$(THEME)
	install -m644 theme.txt $(DESTDIR)/$(THEME)/
	install -m644 background.png $(DESTDIR)/$(THEME)/
	install -dm755 $(DESTDIR)/$(THEME)/icons
	install -m644 icons/*.png $(DESTDIR)/$(THEME)/icons/ 2>/dev/null || true

uninstall:
	rm -rf $(DESTDIR)/$(THEME)

.PHONY: all install uninstall
