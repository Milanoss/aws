#!/bin/bash

set -x

# update apt to install zip
apt-get update
apt-get install -y zip

# create directory next to cbm-aws-repo-lambdas-all
# zip files will be at this directory as result of for loop
mkdir -p zip

cd cbm-aws-repo-lambdas-all/lambdas

for D in */;
do

[ -d "${D}" ]
cd "$D"

DIR_NAME=`basename $PWD`

if [ -f package.json ]; then
npm install
fi

# reset timestamp of all files that will be included in zip, because of checksum calculation
touch -t 201901010101 . *

zip -rX ${DIR_NAME}.zip .

# create sum
openssl dgst -sha256 -binary ${DIR_NAME}.zip | openssl enc -base64 | cut -d " " -f 1 | tr -d '\n' > ${DIR_NAME}.zip.sha256sum

mv ${DIR_NAME}.zip* ../../../zip

ls -al

cd ..

done

# debug output of result
cd ../../zip
ls -al