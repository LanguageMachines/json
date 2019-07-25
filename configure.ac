#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT([json],[0.1],[lamasoftware@science.ru.nl]) #also adapt in codemeta.json!
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_SRCDIR([.])
AC_CONFIG_HEADER([config.h])

if test x"${CXXFLAGS+set}" = xset; then
  # the user set CXXFLAGS; don't override it.
  cxx_flags_were_set=true
else
  cxx_flags_were_set=false
fi
if $cxx_flags_were_set; then
  CXXFLAGS=$CXXFLAGS
fi

# Checks for programs.
AC_PROG_CXX([g++ clang++] )

# when running tests, use CXX
AC_LANG([C++])

AC_CONFIG_FILES([
  Makefile
  json.pc
  include/Makefile
  include/nlohmann/Makefile
])
AC_OUTPUT
