# # -----------------------------
# # Start Jupyter Notebook for Colab Local Runtime
# # -----------------------------
if [[ $- == *i* ]]; then
  if jupyter notebook list 2>&1 | grep -q 'http'; then
    echo "Jupyter server already up:"
    jupyter notebook list
  else
    echo "Starting Jupyter Notebook..."
    echo "--------------------------"
    echo
    jupyter notebook \
      --NotebookApp.allow_origin='https://colab.research.google.com' \
      --port=8888 \
      --NotebookApp.port_retries=0 \
      --no-browser &>/dev/null &
    jupyter notebook list
  fi
fi

# jupyter notebook list