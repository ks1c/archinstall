#!/bin/bash

rm -rf index.html
cp ./archinstall.sh ./index.html
git add .
git commit -m "mkrls"
git push -u origin master
