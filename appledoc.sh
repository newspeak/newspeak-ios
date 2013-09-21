#!/bin/sh

# generate appledoc api documentation from source files

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
PWD=$(pwd)

/usr/local/bin/appledoc \
--project-name "Newspeak" \
--project-company "Jahn Bertsch" \
--company-id "io.newspeak" \
--docset-atom-filename "NPNewspeak.atom" \
--docset-feed-url "http://newspeak.github.com/newspeak-ios/%DOCSETATOMFILENAME" \
--docset-package-url "http://newspeak.github.com/newspeak-ios/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "http://newspeak.github.com/newspeak-ios/" \
--output "$PWD/doc" \
--publish-docset \
--logformat xcode \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--ignore "*.m" \
--ignore "_NPMessage.h" \
--ignore "_NPToken.h" \
--ignore "_NPToken.h" \
--ignore "_NPDevice.h" \
--index-desc "$PWD/README.md" \
"$PWD/Newspeak"

echo documentation is at doc/html/index.html
open doc/html/index.html
