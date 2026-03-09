#!/bin/bash
set -e

# Generate rclone config from environment variables
cat > /root/.config/rclone/rclone.conf << EOF
[s3]
type = s3
provider = Other
access_key_id = ${S3_ACCESS_KEY}
secret_access_key = ${S3_SECRET_KEY}
endpoint = ${S3_ENDPOINT}
acl = ${S3_ACL:-private}
region = ${S3_REGION:-}
EOF

echo "rclone config generated for endpoint: ${S3_ENDPOINT}"

if [ "$1" = "--list" ] || [ "$1" = "ls" ]; then
    echo "Listing buckets..."
    exec rclone lsd s3:
elif [ "$1" = "--help" ] || [ -z "$1" ]; then
    echo ""
    echo "Usage examples:"
    echo "  List buckets:          docker compose run --rm s3 --list"
    echo "  List bucket content:   docker compose run --rm s3 ls s3:my-bucket"
    echo "  Upload file:           docker compose run --rm s3 copy /data/file.txt s3:my-bucket/"
    echo "  Download file:         docker compose run --rm s3 copy s3:my-bucket/file.txt /data/"
    echo "  Sync folder:           docker compose run --rm s3 sync /data/folder s3:my-bucket/folder"
    echo "  Mount bucket:          docker compose run --rm s3 mount s3:my-bucket /mnt/s3"
    echo ""
    echo "Or pass any rclone command directly:"
    echo "  docker compose run --rm s3 lsd s3:"
    echo ""
else
    exec rclone "$@"
fi
