docker run -d --name openssl34 --rm -e GOTIFY_SERVER='https://<Server>/message' -e GOTIFY_KEY='<Key>' -v <Output>:/home/output wiederda/openssl_win ./openssl3_4_win.sh