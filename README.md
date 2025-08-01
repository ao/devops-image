# DevOps Image

A lightweight Docker container based on Alpine Linux that provides essential DevOps tools and Git configuration for development work.

## Overview

This container provides a consistent development environment with common DevOps tools pre-installed. It's designed to be lightweight while providing the essential utilities needed for development tasks.

## Features

- Based on Alpine Linux for minimal footprint
- Pre-installed tools:
  - Git (with automatic configuration)
  - Vim and Neovim editors
  - wget and curl for downloads
  - Python 3 with pip
  - Other essential utilities

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