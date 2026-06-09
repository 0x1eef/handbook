PREFIX ?= /usr/local
APPNAME ?= handbook
APPDIR ?= $(PREFIX)/share/$(APPNAME)
RCDIR ?= $(PREFIX)/etc/rc.d
BUNDLE ?= bundle
INSTALL ?= install
MKDIR ?= mkdir -p
RM ?= rm -f
SED ?= sed

APP_FILES = config.ru Gemfile Gemfile.lock LICENSE README.md
APP_DIRS = .bundle bin lib libexec public

.PHONY: install deinstall bundle check-bundle

install: check-bundle
	$(MKDIR) "$(DESTDIR)$(APPDIR)"
	for file in $(APP_FILES); do \
		$(INSTALL) -m 0644 "$$file" "$(DESTDIR)$(APPDIR)/$$file"; \
	done
	for dir in $(APP_DIRS); do \
		rm -rf "$(DESTDIR)$(APPDIR)/$$dir"; \
		cp -R "$$dir" "$(DESTDIR)$(APPDIR)/$$dir"; \
	done
	$(MKDIR) "$(DESTDIR)$(APPDIR)/share/handbook"
	$(INSTALL) -m 0644 share/handbook/database.sqlite3 "$(DESTDIR)$(APPDIR)/share/handbook/database.sqlite3"
	$(MKDIR) "$(DESTDIR)$(RCDIR)"
	$(SED) -e "s|%%APPDIR%%|$(APPDIR)|g" -e "s|%%PREFIX%%|$(PREFIX)|g" \
		etc/rc.d/handbook.in > "$(DESTDIR)$(RCDIR)/handbook"
	chmod 0555 "$(DESTDIR)$(RCDIR)/handbook"

bundle:
	$(BUNDLE) config set path .bundle/gems
	$(BUNDLE) install

check-bundle:
	@test -f .bundle/config || (echo "Run 'make bundle' as an unprivileged user before 'make install'." >&2; exit 1)
	@test -d .bundle/gems || (echo "Run 'make bundle' as an unprivileged user before 'make install'." >&2; exit 1)

deinstall:
	$(RM) "$(DESTDIR)$(RCDIR)/handbook"
	rm -rf "$(DESTDIR)$(APPDIR)"
