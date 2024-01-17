set output=%~dp0output

docker run -d --name openssl31 --rm -e GOTIFY_SERVER='https://<Server>/message' -e GOTIFY_KEY='<Key>' -v %output%:/home/output openssl_win ./openssl3_1_win.sh