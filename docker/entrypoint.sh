#!/bin/sh -e

test -n "$ACCESS_KEY" || (echo "ERROR: env 'ACCESS_KEY' not set" &> /dev/stderr && false)
test -n "$SECRET_KEY" || (echo "ERROR: env 'SECRET_KEY' not set" &> /dev/stderr && false)
test -n "$SOURCE_PATH" || (echo "ERROR: env 'SOURCE_PATH' not set" &> /dev/stderr && false)
test -n "$CRON_SCHEDULE" || (echo "ERROR: env 'CRON_SCHEDULE' not set" &> /dev/stderr && false)

cat /app/crontab.tpl | envsubst '$CRON_SCHEDULE $S3SYNC_ARGS $SOURCE_PATH' > /etc/crontabs/root

echo "###### /etc/crontabs/root"
cat /etc/crontabs/root
echo "#########################"

rm -rf /data
mkdir -p /data

# setup env
mkdir -p /root/.aws
echo "[default]"                              > /root/.aws/credentials
echo "aws_access_key_id = ${ACCESS_KEY}"     >> /root/.aws/credentials
echo "aws_secret_access_key = ${SECRET_KEY}" >> /root/.aws/credentials

# Run first sync
echo "Inital sync ..."
aws --color=off --no-paginate s3 sync ${S3SYNC_ARGS} ${SOURCE_PATH} /data

# Start nginx in foreground
echo "Starting nginx ..."
nginx -g 'daemon off;' &

# start cron in foreground
echo -n "Starting crond ..."
crond -f

