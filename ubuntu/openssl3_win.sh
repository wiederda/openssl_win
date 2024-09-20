!/bin/sh

#html=$(wget -qO- https://github.com/openssl/openssl/releases/download/ | grep "openssl-3.0")
#file_name=$(echo "$html" | grep -oP 'href="\K[^"]+(?=")')
#file_version=$(echo "$file_name" | sed -n 1p) 
Version=openssl-3.0
Pfad=/home/output
Home=/home/Downloads
Out=openssl-3.0
tmp=tmp
temp=/home/temp

mkdir -p $Home/$tmp
mkdir -p $Home/$Version
rm -R $Pfad/*.zip
mkdir -p $temp/$Out/bin
chmod -R ugo+rwx $Home/$tmp
chmod -R ugo+rwx $temp

git clone -b openssl-3.0 --single-branch https://github.com/openssl/openssl.git $Home/$Version
#tar xzfv $Home/$file_version
chmod -R ugo+rwx $Home/$Version

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