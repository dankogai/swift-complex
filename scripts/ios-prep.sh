#!/bin/sh
srcdir=Sources/Complex
dstdir=iOS/Complex.playground/Sources
test -d $dstdir && /bin/rm -r $dstdir
/bin/cp -a $srcdir $dstdir
