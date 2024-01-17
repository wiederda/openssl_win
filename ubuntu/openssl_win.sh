#!/bin/sh

html=$(wget -qO- https://www.openssl.org/source/ | grep "openssl-1.1.1")
file_name=$(echo "$html" | grep -oP 'href="\K[^"]+(?=")')
file_version=$(echo "$file_name" | sed -n 1p) 
Version=$(echo "$file_version" | sed 's/.tar.gz//')
Pfad=/home/output
Home=/home/Downloads
Out=OpenSSL-Win64
temp=/home/temp

rm $Pfad/$Out.tar.gz
mkdir -p $temp/$Out/bin

cd $Home
wget https://www.openssl.org/source/$file_version
tar xzfv $Home/$file_version
chmod -R ugo+rwx $Home/$Version

cd $Home/$Version

chmod +x ./Configure
./Configure --cross-compile-prefix=x86_64-w64-mingw32- mingw64

make
make install

cp -R $Home/$Version/C:/"Program Files"/OpenSSL/bin/ $temp/$Out/
cp $Home/$Version/LICENSE $temp/$Out/ 
cp $Home/$Version/NEWS $temp/$Out/ 
cp $Home/$Version/CHANGES $temp/$Out/

cd $temp
tar -czf $Out.tar.gz $Out/
cp $Out.tar.gz $Pfad

chmod -R ugo+rwx $Pfad/

if [ -n "$GOTIFY_SERVER" ]; then
    curl -X POST $GOTIFY_SERVER \
     -H "Content-Type: application/json" \
     -H "X-Gotify-Key: $GOTIFY_KEY" \
     -d "{\"title\": \"Notification Title\", \"message\": \"OpenSSL $Out wurde erfolgreich erstellt\"}"
fi