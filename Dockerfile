FROM alpine:3.15.4

# Inspired by https://github.com/silinternational/docker-sync-with-s3
RUN adduser -S www-data -G www-data
RUN apk --no-cache update \
    && apk add --no-cache python3 py-pip ca-certificates openssl gettext nginx \
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