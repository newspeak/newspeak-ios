#!/bin/sh

cd $(dirname $0)
mogenerator --output-dir newspeak/Models/ --template-var arc=true -m newspeak/Models/newspeak.xcdatamodeld/newspeak.xcdatamodel

echo
echo "it is advised to run uncrustify now - mogenerator does not adhere to current coding style"
