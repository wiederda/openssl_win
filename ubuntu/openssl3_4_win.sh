#!/bin/bash

Pfad=/home/output
Home=/home/Downloads
tmp=tmp
temp=/home/temp

mkdir -p $Home/$tmp
rm -R $Pfad/*.zip
cd $Home

download_openssl_version() {
    major_version=$1
    latest_version=$(curl -s https://api.github.com/repos/openssl/openssl/releases | grep '"tag_name":' | grep "$major_version" | grep -Eo "$major_version\.[0-9]+" | head -n 1)
    
    if [ -n "$latest_version" ]; then
        
        wget https://github.com/openssl/openssl/releases/download/openssl-$latest_version/openssl-$latest_version.tar.gz
    
    fi

download_openssl_version "3.4"

Out=$latest_version
mkdir -p $temp/$Out/
chmod -R ugo+rwx $Home/$tmp
chmod -R ugo+rwx $temp

tar xzfv $Home/openssl-$latest_version.tar.gz

chmod -R ugo+rwx $Home/openssl-$latest_version

cd $Home/openssl-$latest_version

chmod +x $Home/openssl-$latest_version/Configure
$Home/openssl-$latest_version/Configure --cross-compile-prefix=x86_64-w64-mingw32- mingw64 --prefix=$Home/$tmp --openssldir=$Home/$tmp

make
make install

cd $temp

mkdir $Out
cp -R $Home/$tmp/bin/ $Out/
cp $Home/openssl-$latest_version/LICENSE.txt $Out/
cp $Home/openssl-$latest_version/NEWS.md $Out/
cp $Home/openssl-$latest_version/CHANGES.md $Out/

zip -r $latest_version.zip $Out
cp $latest_version.zip $Pfad
#cp -R $Out $Pfad

chmod -R ugo+rwx $Pfad

if [ -n "$GOTIFY_SERVER" ]; then
    curl -X POST $GOTIFY_SERVER \
     -H "Content-Type: application/json" \
     -H "X-Gotify-Key: $GOTIFY_KEY" \
     -d "{\"title\": \"Notification Title\", \"message\": \"OpenSSL $latest_version wurde erfolgreich erstellt\"}"
fi
