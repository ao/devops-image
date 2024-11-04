# Use Alpine as the base image
FROM alpine:latest

# Install basic tools and packages from apk
RUN apk update && \
    apk add --no-cache \
        git \
        vim \
        neovim \
        wget \
        curl \
        shadow \
        py3-pip

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]

# Set default command to start a shell
CMD ["/bin/sh"]
