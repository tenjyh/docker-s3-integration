#!/bin/bash
# Example: Upload a local file to an S3 bucket
# Usage: ./examples/upload-file.sh <local-file> <bucket-name> [destination-path]
#
# Example:
#   ./examples/upload-file.sh ./data/report.pdf my-bucket backups/

set -e

LOCAL_FILE="${1:?Please provide a local file path}"
BUCKET="${2:?Please provide a bucket name}"
DEST_PATH="${3:-}"

if [ ! -f "$LOCAL_FILE" ]; then
    echo "Error: file '$LOCAL_FILE' not found."
    exit 1
fi

FILENAME=$(basename "$LOCAL_FILE")

echo "Uploading '$FILENAME' to s3:${BUCKET}/${DEST_PATH}..."

docker compose run --rm s3 copy "/data/${FILENAME}" "s3:${BUCKET}/${DEST_PATH}"

echo "Done! File uploaded to s3:${BUCKET}/${DEST_PATH}${FILENAME}"
