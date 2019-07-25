ACLOCAL_AMFLAGS =-I m4 --install

SUBDIRS = include

EXTRA_DIST = bootstrap.sh AUTHORS TODO NEWS README.md #codemeta.json

ChangeLog: NEWS
	git pull; git2cl > ChangeLog
