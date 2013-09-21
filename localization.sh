#!/bin/sh -x

# generate localizable strings from interface builder and source files

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

# extract strings from interface builder
ibtool --generate-strings-file Newspeak/en.lproj/InterfaceBuilder.strings Newspeak/en.lproj/MainStoryboard_iPhone.storyboard

# extract strings from source code
genstrings -o Newspeak/en.lproj/ Newspeak/*.m Newspeak/Models/*.m Newspeak/Controllers/*.m Newspeak/Views/*.m
