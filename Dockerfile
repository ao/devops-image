# Use Alpine as the base image
FROM alpine:latest

# Set environment variables
# ENV TERRAFORM_VERSION=1.5.7
ENV AWS_CLI_VERSION=2.13.14

# Install basic tools, and packages from apk
RUN apk update && \
    apk add --no-cache \
        git \
        vim \
        neovim \
        wget \
        curl \
        bash \
        shadow \
        py3-pip && \
    # # Install Terraform
    # wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    # unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    # mv terraform /usr/local/bin/ && \
    # rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    # Install AWS CLI v2
    wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -O "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    # Install yum
    apk add --no-cache yum && \
    # Clean up package manager cache
    rm -rf /var/cache/apk/*

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

# Confirm installation of each component
RUN git --version && \
    vim --version && \
    nvim --version && \
    wget --version && \
    yum --version && \
    # terraform -version && \
    aws --version

# Set default command to start a shell
CMD ["/bin/bash"]
