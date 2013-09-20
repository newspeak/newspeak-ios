newspeak for ios
================

unit tests are done with [kiwi](https://github.com/allending/Kiwi), integration tests are done with [kif](https://github.com/square/KIF).

for local testing, use the virtual machine from [newspeak server](https://github.com/newspeak/newspeak-server).

this app supports ios 6 and 7.


install instructions
--------------------

you need the osx package manager [homebrew](http://mxcl.github.io/homebrew) to install dependencies.

install homebrew first:

    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

then, proceed with the additional dependencies

    brew install mogenerator uncrustify appledoc
    gem install cocoapods


appledoc
--------

api documentation can be generated with [appledoc](http://gentlebytes.com/appledoc/).

generated documentation is at `doc/html/index.html`.

run appledoc with the command: `./appledoc.sh`


uncrustify
----------

[uncrustify](http://uncrustify.sourceforge.net) is used for consistent source code formatting.

you can edit the uncrustify config file with [uncrustify x](https://github.com/ryanmaxwell/UncrustifyX). the uncrustify config file is based on [this config file](https://gist.github.com/ryanmaxwell/4242629).

run uncrustify with the command: `./uncrustify.sh`


license
-------

    newspeak.io
    Copyright (C) 2013 Jahn Bertsch

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
