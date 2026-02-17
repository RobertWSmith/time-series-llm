FROM nvidia/cuda:12.9.1-base-ubuntu24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    git-lfs \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m venv $VIRTUAL_ENV
RUN pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu130
RUN pip install --no-cache-dir autogluon pandas numpy scikit-learn matplotlib seaborn
RUN pip install --no-cache-dir jupyter notebook

# Set up working directory
WORKDIR /notebooks

# Expose Jupyter port
EXPOSE 8888

# Command to run Jupyter (must allow connections from any IP)
CMD ["jupyter", "notebook", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.disable_check_xsrf=True"]
