#!/bin/bash
set -e  # Exit on any error

# echo "LOGGING: creating startup file"
# sudo tee -a /usr/local/sbin/dependency-creation.sh >/dev/null << 'EOF'

# -----------------------------
# System Update and Essentials
# -----------------------------
echo "LOGGING: updating the system"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y git wget unzip tmux curl

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
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
uv pip install transformers datasets accelerate evaluate
uv pip install jupyterlab ipywidgets jupyter_http_over_ws

# -----------------------------
# Enable Jupyter extension for Colab
# -----------------------------
jupyter serverextension enable --py jupyter_http_over_ws

# -----------------------------
# Optional: Set environment variable
# -----------------------------
export DEEPEVAL_RESULTS_FOLDER="./data"

# -----------------------------
# Start Jupyter Notebook for Colab Local Runtime
# -----------------------------
echo "----------------------------------------------"
echo "LOGGING: Copy this URL to connect Colab to local kernel:"
echo
jupyter notebook \
  --NotebookApp.allow_origin='https://colab.research.google.com' \
  --port=8888 \
  --NotebookApp.port_retries=0 \
  --no-browser