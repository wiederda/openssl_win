set output=%~dp0output

docker run -d --name openssl33 --rm -e GOTIFY_SERVER='https://<Server>/message' -e GOTIFY_KEY='<Key>' -v %output%:/home/output wiederda/openssl_win ./openssl3_3_win.sh