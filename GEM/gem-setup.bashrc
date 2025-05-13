wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-latest-Linux-x86_64.sh

eval "$(/home/ubuntu/miniconda3/bin/conda shell.bash hook)"
conda --version
conda create -n gem python=3.10

conda deactivate
conda activate gem

pip install --no-cache-dir \
  torch==2.4.0+cu121 torchvision torchaudio \
  --index-url https://download.pytorch.org/whl/cu121

pip install flash-attn==2.7.4.post1 --no-build-isolation

sudo apt install build-essential ninja-build git

pip install -r requirements.txt
