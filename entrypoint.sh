#!/bin/sh

# Check if git is configured
if ! git config --global user.email >/dev/null; then
    echo "Enter your Git email:"
    read git_email
    git config --global user.email "$git_email"
fi

if ! git config --global user.name >/dev/null; then
    echo "Enter your Git username:"
    read git_username
    git config --global user.name "$git_username"
fi

# Prompt for Git token and store it in a secure way
if ! git config --global credential.helper >/dev/null; then
    echo "Enter your Git personal access token (for https authentication):"
    read -s git_token
    echo
    git config --global credential.helper store
    echo "https://$git_username:$git_token@github.com" > ~/.git-credentials
fi

# Start the shell
exec "$@"
