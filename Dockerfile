# Use Alpine as the base image
FROM alpine:latest

# Install basic tools and packages from apk
RUN apk update && \
    apk add --no-cache \
        git \
        vim \
        wget \
        curl \
        shadow \
        py3-pip \
        python3 \
        bash \
        build-base \
        nodejs \
        npm \
        ripgrep \
        fd \
        alpine-sdk \
        unzip

# Install Go
ENV GOLANG_VERSION=1.24.5
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

RUN wget https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    rm go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    mkdir -p "$GOPATH/src" "$GOPATH/bin" && \
    chmod -R 777 "$GOPATH"

# Install lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin && \
    rm lazygit lazygit.tar.gz

# Install Neovim
RUN apk add --no-cache neovim

# Install LazyNvim
RUN mkdir -p /root/.config/nvim
RUN git clone https://github.com/LazyVim/starter /root/.config/nvim
RUN rm -rf /root/.config/nvim/.git

# Install tfenv for Terraform version management
RUN git clone https://github.com/tfutils/tfenv.git /usr/local/tfenv && \
    ln -s /usr/local/tfenv/bin/* /usr/local/bin && \
    mkdir -p /root/.tfenv/versions

# Install latest Terraform version
RUN tfenv install latest && \
    tfenv use latest

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]

# Set default command to start a shell
CMD ["/bin/sh"]
