set output=%~dp0output

docker run -d --name openssl --rm -e GOTIFY_SERVER='https://<Server>/message' -e GOTIFY_KEY='<Key>' -v %output%:/home/output openssl_win ./openssl_win.sh