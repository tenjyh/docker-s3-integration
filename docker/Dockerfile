FROM rclone/rclone:latest

# Install bash and useful tools
RUN apk add --no-cache bash curl jq

# Create rclone config directory
RUN mkdir -p /root/.config/rclone

# Copy entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
