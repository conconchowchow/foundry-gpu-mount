wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-latest-Linux-x86_64.sh

eval "$(/home/ubuntu/miniconda3/bin/conda shell.bash hook)"
conda --version
conda create -n gem python=3.10
conda activate gem