#!/bin/sh

cd $(dirname $0)
find newspeak -name "*.h" -o -name "*.m" -o -name "*.pch" > uncrustify.input
uncrustify -c uncrustify.cfg --no-backup -l OC -F uncrustify.input
rm uncrustify.input
