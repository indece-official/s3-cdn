# S3-CDN
Lightweight CDN server (NGINX) for S3-Backend

> Inspired by https://github.com/silinternational/docker-sync-with-s3

## Usage
```
docker run -p 8080:8080 -e ACCESS_KEY=my-accesskey -e SECRET_KEY=my-secretkey -e SOURCE_PATH='s3://my-s3-bucket/' indece-official/s3-cdn:latest
```

Opens a port on 8080 and serves the files from the bucket

*Important:* Clones all files from the `SOURCE_PATH` to `/data`, even if a file is not accessed via HTTP.

### Environment variables
| Variable | Required | Default | Description |
| --- | --- | --- | --- |
| ACCESS_KEY | yes | | S3-Access-Key |
| SECRET_KEY | yes | | S3-Secret-Key |
| SOURCE_PATH | yes | | Source-Path for s3 sync (e.g. 's3://my-bucket-name/') |
| CRON_SCHEDULE | | "*/15 * * * *" | Cron shedule for s3 sync |
| S3SYNC_ARGS | | "" | Extra options passed to aws-cli for s3 sync |
