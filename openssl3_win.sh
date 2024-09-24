docker run -d --name openssl3 --rm -e GOTIFY_SERVER='https://<Server>/message' -e GOTIFY_KEY='<Key>' -v <Output>:/home/output wiederda/openssl_win ./openssl3_win.sh
