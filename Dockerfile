# Use Alpine as the base image
FROM alpine:latest AS builder

# Install build dependencies
RUN apk update && \
    apk add --no-cache \
        git \
        wget \
        curl \
        build-base \
        unzip \
        tar \
        xz \
        musl-dev

# Install Go in the builder stage
ENV GOLANG_VERSION=1.24.5
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

RUN wget https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    rm go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    mkdir -p "$GOPATH/src" "$GOPATH/bin"

# Download lazygit
RUN LAZYGIT_VERSION="0.40.2" && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz && \
    rm lazygit.tar.gz

# Clone LazyVim starter
RUN mkdir -p /root/.config/nvim && \
    git clone --depth=1 https://github.com/LazyVim/starter /root/.config/nvim && \
    rm -rf /root/.config/nvim/.git

# Clone tfenv
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git /usr/local/tfenv

# Install Zig
ENV ZIG_VERSION=0.14.1
ENV ARCH=zig-x86_64-linux-${ZIG_VERSION}
ENV ZIG_URL=https://ziglang.org/download/${ZIG_VERSION}/${ARCH}.tar.xz

RUN curl -L ${ZIG_URL} -o ${ARCH}.tar.xz && \
    tar -xf ${ARCH}.tar.xz && \
    mv ${ARCH} /opt/zig && \
    rm ${ARCH}.tar.xz && \
    /opt/zig/zig version

# Final stage
FROM alpine:latest

# Copy artifacts from builder stage
COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /go /go
COPY --from=builder /lazygit /usr/local/bin/lazygit
COPY --from=builder /root/.config/nvim /root/.config/nvim
COPY --from=builder /usr/local/tfenv /usr/local/tfenv
COPY --from=builder /opt/zig /opt/zig

# Set environment variables
ENV PATH=$PATH:/usr/local/go/bin:/go/bin:/usr/local/tfenv/bin:/opt/zig
ENV GOPATH=/go

# Install runtime dependencies in a single layer
RUN apk update && \
    apk add --no-cache \
        git \
        vim \
        neovim \
        wget \
        curl \
        shadow \
        py3-pip \
        python3 \
        bash \
        nodejs \
        npm \
        ripgrep \
        fd \
        xclip \
        wl-clipboard && \
    # Set up tfenv
    ln -s /usr/local/tfenv/bin/* /usr/local/bin && \
    mkdir -p /root/.tfenv/versions && \
    # Install latest Terraform version
    tfenv install latest && \
    tfenv use latest && \
    # Clean up
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]

# Set default command to start a shell
CMD ["/bin/sh"]
