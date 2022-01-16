FROM nginx:latest

# public/OneSignalSDKWorker.jsがuploadされないためnginxコンテナUcmsApp/publicに
# 後で加えるために必要となる
RUN set -x && apt-get update -qq && \
apt-get install -yq  vim

ENV TZ Asia/Tokyo

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
COPY /docker/nginx/nginx.conf /etc/nginx/conf.d/UcmsApp.conf

# ビルド完了後にNginxを起動
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
