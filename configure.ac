AC_INIT([echogram], 0.1)
AM_INIT_AUTOMAKE([1.10 no-define foreign dist-xz no-dist-gzip])
AC_PROG_CC
AM_PROG_VALAC([0.26])
PKG_CHECK_MODULES(gtk, [gtk+-3.0 gee-0.8 gio-2.0 glib-2.0])
AC_CONFIG_FILES([Makefile src/Makefile echogram.desktop])

AC_OUTPUT
