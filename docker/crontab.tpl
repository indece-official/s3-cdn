${CRON_SCHEDULE} aws --color=off --no-paginate s3 sync ${S3SYNC_ARGS} ${SOURCE_PATH} /data
