#!/bin/sh -e

test -n "$ACCESS_KEY" || (echo "ERROR: env 'ACCESS_KEY' not set" &> /dev/stderr && false)
test -n "$SECRET_KEY" || (echo "ERROR: env 'SECRET_KEY' not set" &> /dev/stderr && false)
test -n "$SOURCE_PATH" || (echo "ERROR: env 'SOURCE_PATH' not set" &> /dev/stderr && false)
test -n "$INTERVAL" || (echo "ERROR: env 'INTERVAL' not set" &> /dev/stderr && false)

mkdir -p /data
rm -rf /data/*

# setup env
mkdir -p $HOME/.aws
echo "[default]"                              > $HOME/.aws/credentials
echo "aws_access_key_id = ${ACCESS_KEY}"     >> $HOME/.aws/credentials
echo "aws_secret_access_key = ${SECRET_KEY}" >> $HOME/.aws/credentials

# Run first sync
echo "Inital sync ..."
aws --color=off --no-paginate s3 sync ${S3SYNC_ARGS} ${SOURCE_PATH} /data

# Start nginx in foreground
echo "Starting nginx ..."
nginx -g 'daemon off;' &

# start sync loop in foreground
while true
do
    sleep $INTERVAL
    aws --color=off --no-paginate s3 sync ${S3SYNC_ARGS} ${SOURCE_PATH} /data
done


