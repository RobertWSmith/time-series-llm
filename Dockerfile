FROM nvidia/cuda:13.1.1-base-ubuntu24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /notebooks
COPY requirements.txt .
COPY *.ipynb .
COPY m5-forecasting-accuracy/* m5-forecasting-accuracy/

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir torch==2.9.1 torchvision==0.24.1 torchaudio==2.9.1 --index-url https://download.pytorch.org/whl/cu130
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir jupyter notebook

# Expose Jupyter port
EXPOSE 8888

# Command to run Jupyter (must allow connections from any IP)
CMD ["jupyter", "notebook", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.disable_check_xsrf=True"]
