#!/bin/sh

# format source code according to coding style defined in uncrustify.cfg
#
# for more information, see http://uncrustify.sourceforge.net
# and https://github.com/ryanmaxwell/UncrustifyX

# newspeak.io
# Copyright (C) 2013 Jahn Bertsch
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

cd $(dirname $0)
find newspeak -name "*.h" -o -name "*.m" -o -name "*.pch" > uncrustify.input
uncrustify -c uncrustify.cfg --no-backup -l OC -F uncrustify.input
rm uncrustify.input
