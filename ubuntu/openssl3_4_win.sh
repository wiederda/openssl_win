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
    latest_version=$(curl -s https://api.github.com/repos/openssl/openssl/releases | grep '"tag_name":' | grep "$major_version" | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -n "$latest_version" ]; then
        #echo "Downloading OpenSSL version $latest_version..."
        wget https://github.com/openssl/openssl/releases/download/$latest_version/$latest_version.tar.gz
   #else
    #    echo "No releases found for OpenSSL $major_version.x"
    fi
}

download_openssl_version "3.4"

Out=$latest_version
mkdir -p $temp/$Out/
chmod -R ugo+rwx $Home/$tmp
chmod -R ugo+rwx $temp

tar xzfv $Home/$latest_version.tar.gz

chmod -R ugo+rwx $Home/$latest_version

cd $Home/$latest_version

chmod +x $Home/$latest_version/Configure
$Home/$latest_version/Configure --cross-compile-prefix=x86_64-w64-mingw32- mingw64 --prefix=$Home/$tmp --openssldir=$Home/$tmp

make
make install

cd $temp

mkdir $Out
cp -R $Home/$tmp/bin/ $Out/
cp $Home/$latest_version/LICENSE.txt $Out/
cp $Home/$latest_version/NEWS.md $Out/
cp $Home/$latest_version/CHANGES.md $Out/

zip -r $latest_version.zip $Out
cp $latest_version.zip $Pfad
#cp -R $Out $Pfad

chmod -R ugo+rwx $Pfad

if [ -n "$GOTIFY_SERVER" ]; then
    curl -X POST $GOTIFY_SERVER \
     -H "Content-Type: application/json" \
     -H "X-Gotify-Key: $GOTIFY_KEY" \
     -d "{\"title\": \"Notification Title\", \"message\": \"$latest_version wurde erfolgreich erstellt\"}"
fi
