FROM alpine:3.19.0

LABEL org.opencontainers.image.vendor="indece UG (haftungsbeschränkt)"
LABEL org.opencontainers.image.url="https://github.com/indece-official/s3-cdn"
LABEL org.opencontainers.image.source="https://github.com/indece-official/s3-cdn"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="S3-CDN"
LABEL org.opencontainers.image.description="Lightweight CDN server (NGINX) for S3-Backend (e.g. minio)"

# Inspired by https://github.com/silinternational/docker-sync-with-s3
RUN adduser -S www-data -G www-data
RUN apk upgrade --no-cache && \
    apk add --no-cache python3 py3-pip ca-certificates openssl gettext nginx && \
    pip3 install awscli --break-system-packages && \
    pip3 cache purge && \
    apk del --purge py3-pip

WORKDIR /app
COPY ./docker/entrypoint.sh /app/
COPY ./docker/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /app/entrypoint.sh && \
    mkdir -p /data && \
    chown www-data:www-data /data

EXPOSE 8080

ENV ACCESS_KEY=""
ENV SECRET_KEY=""
ENV SOURCE_PATH=""
ENV INTERVAL="15m"
ENV S3SYNC_ARGS=""

USER www-data

CMD ["/app/entrypoint.sh"]
