#!/bin/sh

# update mogenerator files
#
# for more information, see https://github.com/rentzsch/mogenerator

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
mogenerator --output-dir newspeak/Models/ --template-var arc=true -m newspeak/Models/newspeak.xcdatamodeld/newspeak.xcdatamodel

echo
echo "it is advised to run uncrustify now - mogenerator does not adhere to current coding style"
