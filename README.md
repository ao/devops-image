# DevOps Image

A lightweight Docker container based on Alpine Linux that provides essential DevOps tools and Git configuration for development work.

## Overview

This container provides a consistent development environment with common DevOps tools pre-installed. It's designed to be lightweight while providing the essential utilities needed for development tasks.

## Features

- Based on Alpine Linux with multi-stage build for minimal footprint
- Pre-installed tools:
  - Git (with automatic configuration)
  - Vim and LazyNvim (preconfigured Neovim with clipboard support)
  - lazygit v0.40.2 (terminal UI for Git)
  - wget and curl for downloads
  - Python 3 with pip
  - Go (latest stable version)
  - Terraform (via tfenv with latest version)
  - Other essential utilities
- Terraform version management with tfenv:
  - Latest version installed by default
  - Easily switch between Terraform versions as needed
- Development environments:
  - Go development environment with GOPATH configured
  - Python 3 development environment
  - LazyVim configuration for enhanced editing

## Usage

Run the container with:

```bash
docker run --rm -it -v ~/src/:/src ataiva/devops-image
```

### Parameters explained:

- `--rm`: Automatically remove the container when it exits
- `-it`: Interactive mode with a terminal
- `-v ~/src/:/src`: Mounts your local source directory to /src in the container
- `ataiva/devops-image`: The image name

## First Run

When you first run the container, it will:

1. Prompt for your Git email if not configured
2. Prompt for your Git username if not configured
3. Prompt for your Git personal access token (for HTTPS authentication)

This configuration is stored for subsequent runs.

## Benefits

- Consistent development environment across different machines
- Access to Git and other DevOps tools from within the container
- Simplified setup with automatic Git configuration
- Flexible Terraform version management
- Optimized container size through multi-stage builds

## Using Terraform with tfenv

The container comes with tfenv pre-installed, allowing you to manage multiple Terraform versions:

```bash
# List installed Terraform versions
tfenv list

# Install a specific version
tfenv install 1.12.2

# Use a specific version
tfenv use 1.12.2

# Use the latest version
tfenv use latest
```

The latest Terraform version is installed and set as default when the container is built.

## Using Go

The container includes the latest stable version of Go with a properly configured environment:

```bash
# Check Go version
go version

# Run a Go program
go run main.go

# Build a Go program
go build -o myapp main.go
```

The GOPATH is set to `/go` and added to the PATH.

## Using LazyNvim and lazygit

The container comes with LazyVim (a preconfigured Neovim setup) and lazygit:

```bash
# Start LazyVim
nvim

# Start lazygit (terminal UI for Git)
lazygit
```

LazyVim includes many useful plugins and configurations for development. On first run, it will automatically install all plugins. The container includes clipboard support for Neovim through xclip and wl-clipboard.

Lazygit version 0.40.2 is installed in the container. This terminal UI provides an intuitive interface for Git operations directly from your terminal.
