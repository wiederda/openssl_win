#!/bin/bash

Pfad=/home/output
Home=/home/Downloads
Version=openssl
tmp=tmp
temp=/home/temp

mkdir -p $Home/$tmp
mkdir -p $Home/$Version
rm -R $Pfad/*.zip
chmod -R ugo+rwx $Home/$tmp

git clone -b openssl-3.3 --single-branch https://github.com/openssl/openssl.git $Home/$Version
chmod -R ugo+rwx $Home/$Version

DATEI=$Home/$Version/VERSION.dat
counter=0
werte=()
while IFS= read -r line
do
  
  ((counter++))

  if [ $counter -le 3 ]; then
    IFS='=' read -r key value <<< "$line"
    werte+=("$value")
   else
    break
  fi

done < "$DATEI"
Out=$(IFS=.; echo "${werte[*]}")

mkdir -p $temp/$Out/bin
chmod -R ugo+rwx $temp

chmod +x $Home/$Version/Configure
$Home/$Version/Configure --cross-compile-prefix=x86_64-w64-mingw32- mingw64 --prefix=$Home/$tmp --openssldir=$Home/$tmp

make
make install

cp -R $Home/$tmp/bin/ $temp/$Out/
cp $Home/$Version/LICENSE.txt $temp/$Out/
cp $Home/$Version/NEWS.md $temp/$Out/
cp $Home/$Version/CHANGES.md $temp/$Out/

cd $temp

zip -r $Out.zip $Out/
cp $Out.zip $Pfad

chmod -R ugo+rwx $Pfad/

if [ -n "$GOTIFY_SERVER" ]; then
    curl -X POST $GOTIFY_SERVER \
     -H "Content-Type: application/json" \
     -H "X-Gotify-Key: $GOTIFY_KEY" \
     -d "{\"title\": \"Notification Title\", \"message\": \"OpenSSL $Out wurde erfolgreich erstellt\"}"
fi