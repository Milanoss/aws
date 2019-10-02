#!/bin/bash

set -x

# update apt to install zip
apt-get update
apt-get install -y zip

cd repo-channel-api
npm install
lerna run --parallel build
cd ..

# create directory next to cbm-aws-repo-lambdas-all
# zip files will be at this directory as result of for loop
mkdir -p zip

cd repo-channel-api/functions

#for D in */;
for D in account-data account-update
do

[ -d "${D}" ]
cd "$D"

DIR_NAME=`basename $PWD`

# reset timestamp of all files that will be included in zip, because of checksum calculation
touch -t 201901010101 . handler.js

zip -rX ${DIR_NAME}.zip handler.js

# create sum
openssl dgst -sha256 -binary ${DIR_NAME}.zip | openssl enc -base64 | cut -d " " -f 1 | tr -d '\n' > ${DIR_NAME}.zip.sha256sum

mv ${DIR_NAME}.zip* ../../../zip

ls -al

cd ..

done

# debug output of result
cd ../../zip
ls -al