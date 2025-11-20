#!/usr/bin/env bash
set -euo pipefail

IMAGE="ghcr.io/columbia-advprog-2025/ap-course-env:latest"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

is_wsl() {
  # WSL usually has "Microsoft" or "WSL" in /proc/version
  if [ -f /proc/version ]; then
    grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null
  else
    return 1
  fi
}

install_docker_macos() {
  echo "Docker CLI not found. Attempting to install Docker Desktop via Homebrew..."
  if ! command_exists brew; then
    echo "Homebrew is not installed."
    echo "Please install Homebrew from https://brew.sh and then re-run this script."
    exit 1
  fi

  brew install --cask docker

  echo
  echo "Docker Desktop has been installed."
  echo "IMPORTANT: You must now open the Docker app once (from Applications),"
  echo "wait until it says 'Docker is running', and then re-run this script."
  exit 0
}

install_docker_linux_or_wsl() {
  if is_wsl; then
    echo "Detected WSL (Windows Subsystem for Linux)."
    echo "We will install Docker Engine inside WSL."
  else
    echo "Docker CLI not found. Attempting to install Docker Engine (Linux)..."
  fi
  echo "This requires sudo and will run Docker's convenience script from get.docker.com."
  echo "Press Ctrl+C within 5 seconds to abort."
  sleep 5

  if ! command_exists curl; then
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
  fi

  curl -fsSL https://get.docker.com | sudo sh

  # Add current user to docker group (so they can run docker without sudo)
  sudo usermod -aG docker "$USER"

  echo
  if is_wsl; then
    echo "Docker installed inside WSL."
    echo "Now:"
    echo "  1. Close this terminal window."
    echo "  2. Re-open your Ubuntu (WSL) terminal."
    echo "  3. Re-run ./setup_and_run.sh."
  else
    echo "Docker installed."
    echo "You may need to log out and log back in so group changes take effect."
    echo "Then re-run this script."
  fi
  exit 0
}

OS="$(uname -s)"

# 1. Check for docker, install if missing
if ! command_exists docker; then
  case "$OS" in
    Darwin)
      install_docker_macos
      ;;
    Linux)
      install_docker_linux_or_wsl
      ;;
    *)
      echo "Unsupported OS: $OS"
      echo "Please install Docker manually from https://docs.docker.com/get-docker/"
      exit 1
      ;;
  esac
fi

echo "Docker is installed. Pulling course image: $IMAGE"
docker pull "$IMAGE"

echo "Starting course environment with fixed resources (4 CPUs, 4GB RAM, 16GB disk)..."
docker run --rm \
  --platform=linux/amd64 \
  --cpus="4" \
  --memory="4g" \
  --storage-opt size=8G \
  -v "$PWD":/work \
  -w /work \
  "$IMAGE" \
  /bin/bash
