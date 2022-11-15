FROM alpine:3.16.2

LABEL org.opencontainers.image.vendor="indece UG (haftungsbeschränkt)"
LABEL org.opencontainers.image.url="https://github.com/indece-official/s3-cdn"
LABEL org.opencontainers.image.source="https://github.com/indece-official/s3-cdn"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="S3-CDN"
LABEL org.opencontainers.image.description="Lightweight CDN server (NGINX) for S3-Backend (e.g. minio)"

# Inspired by https://github.com/silinternational/docker-sync-with-s3
RUN adduser -S www-data -G www-data
RUN apk upgrade --no-cache \
    && apk add --no-cache python3 py3-pip ca-certificates openssl gettext nginx \
    && pip install awscli

WORKDIR /app
COPY ./docker/entrypoint.sh /app/
COPY ./docker/crontab.tpl /app/
COPY ./docker/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /app/entrypoint.sh

EXPOSE 8080

ENV ACCESS_KEY=""
ENV SECRET_KEY=""
ENV SOURCE_PATH=""
ENV CRON_SCHEDULE="*/15 * * * *"
ENV S3SYNC_ARGS=""

CMD ["/app/entrypoint.sh"]
