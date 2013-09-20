#!/bin/sh

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
