FROM nvidia/cuda:8.0-cudnn7-devel

# tools:
# -----------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	build-essential \
	ca-certificates \
	cmake \
	wget \
	git \
	nano

# boost:
#-------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libboost-all-dev

# python:
# -----------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	python-pip \
	python-dev \
	python-opencv

RUN pip --no-cache-dir install --upgrade pip
RUN pip --no-cache-dir install --upgrade \
	setuptools \
	numpy \
	scipy \
	pandas \
	scikit-learn \
	matplotlib \
	Cython \
	xmltodict \
	easydict \
	tensorboardX 
	
# pytorch:
#-------------------
RUN pip --no-cache-dir install --upgrade \
	http://download.pytorch.org/whl/cu80/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl \
	torchvision

# tensorflow:
#--------------------
RUN pip --no-cache-dir install --upgrade tensorflow-gpu


# theano:
#--------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	libblas-dev \
	&& \
	wget -qO- https://github.com/Theano/Theano/archive/rel-1.0.1.tar.gz | tar xz -C ~ && \
    	cd ~/Theano* && \
    	RUN pip --no-cache-dir install --upgrade . && \
	git clone --depth 10 https://github.com/Theano/libgpuarray ~/gpuarray && \
    	mkdir -p ~/gpuarray/build && cd ~/gpuarray/build && \
    	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    	make -j"$(nproc)" install && \
    	cd ~/gpuarray && \
    	python setup.py build && \
    	python setup.py install && \
    	printf '[global]\nfloatX = float32\ndevice = cuda0\n\n[dnn]\ninclude_path = /usr/local/cuda/targets/x86_64-linux/include\n' > ~/.theanorc 


# keras:
#--------------------
RUN pip --no-cache-dir install --upgrade \
	h5py \
	keras


# config & cleanup:
#--------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*
