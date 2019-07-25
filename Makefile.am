ACLOCAL_AMFLAGS =-I m4 --install

SUBDIRS = single_include

EXTRA_DIST = bootstrap.sh AUTHORS TODO NEWS README.md json.pc.in

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = json.pc


ChangeLog: NEWS
	git pull; git2cl > ChangeLog
