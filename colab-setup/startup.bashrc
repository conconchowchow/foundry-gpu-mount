#!/bin/bash
# set -e  # Exit on any error

# echo "LOGGING: creating startup file"
# sudo tee -a /usr/local/sbin/dependency-creation.sh >/dev/null << 'EOF'

# -----------------------------
# System Update and Essentials
# -----------------------------
echo "LOGGING: updating the system"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y git wget unzip tmux curl
sudo apt install python3-pip

# -----------------------------
# Install uv if not already installed
# -----------------------------
if ! command -v uv &> /dev/null; then
    echo "LOGGING: uv not found, installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "LOGGING: Finished downloading uv"
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "LOGGING: uv already installed."
fi

# -----------------------------
# Setting up github
# -----------------------------
git config --global user.email "connorchow2@gmail.com"
git config --global user.name "connorchow"

# -----------------------------
# Create and Activate uv Environment
# -----------------------------
echo "LOGGING: Creating uv environment 'random_env'..."
uv venv random_env
echo "LOGGING: Activating 'random_env'..."
source ./random_env/bin/activate

# -----------------------------
# Install from requirements.txt (if exists)
# -----------------------------
if [ -f requirements.txt ]; then
    echo "LOGGING: Installing packages from requirements.txt..."
    uv pip install -r requirements.txt
else
    echo "LOGGING: No requirements.txt found in the current directory."
    exit 1
fi

# -----------------------------
# Additional Python Packages for HF + Colab Local Runtime
# -----------------------------
# uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
uv pip install jupyter_http_over_ws


/home/ubuntu/foundry-gpu-mount/random_env/bin/python3 -m ensurepip --upgrade
/home/ubuntu/foundry-gpu-mount/random_env/bin/python3 -m pip install --upgrade pip

# # -----------------------------
# # Enable Jupyter extension for Colab
# # -----------------------------
jupyter server extension enable --py jupyter_http_over_ws

# # -----------------------------
# # Optional: Set environment variable
# # -----------------------------
export DEEPEVAL_RESULTS_FOLDER="./data"