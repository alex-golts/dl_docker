FROM nvidia/cuda:8.0-cudnn6-devel

RUN rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
	apt-get update 
# tools:
# -----------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	build-essential \
	ca-certificates \
	cmake \
	wget \
	git \
	nano \
	byobu

# boost:
#-------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libboost-all-dev

# python:
# -----------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	python-pip \
	python3-pip \
	python-dev \
	python3-dev \
	python-opencv \
	spyder \
	spyder3

RUN pip --no-cache-dir install --upgrade pip \
	setuptools

RUN pip3 --no-cache-dir install --upgrade setuptools

RUN pip --no-cache-dir install --upgrade \
	numpy \
	scipy \
	pandas \
	scikit-learn \
	matplotlib \
	Cython \
	xmltodict \
	easydict \
	tensorboardX \
	Pillow

RUN pip3 --no-cache-dir install --upgrade \
	numpy \
	scipy \
	pandas \
	scikit-learn \
	matplotlib \
	Cython \
	xmltodict \
	easydict \
	tensorboardX \
	Pillow
	
# pytorch:
#-------------------
RUN pip --no-cache-dir install --upgrade \
	http://download.pytorch.org/whl/cu80/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl \
	torchvision

RUN pip3 --no-cache-dir install --upgrade \
	http://download.pytorch.org/whl/cu80/torch-0.3.1-cp35-cp35m-linux_x86_64.whl \
	torchvision

# tensorflow:
#--------------------
RUN pip --no-cache-dir install tensorflow-gpu==1.4.1
RUN pip3 --no-cache-dir install tensorflow-gpu==1.4.1

ARG HOME=$HOME
ARG UID=$UID
RUN useradd -u $UID -g 0 -m dluser
RUN usermod -aG sudo dluser
RUN echo 'dluser:dlpass' | chpasswd
#RUN useradd dluser -m -G sudo
#USER dluser

# theano:
#--------------------
#RUN pip --no-cache-dir install git+https://github.com/Theano/Theano.git#egg=Theano
#RUN pip3 --no-cache-dir install git+https://github.com/Theano/Theano.git#egg=Theano
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	libblas-dev && \
	wget -qO- https://github.com/Theano/Theano/archive/rel-0.8.2.tar.gz | tar xz -C ~ && \
	cd ~/Theano* && \
	pip --no-cache-dir install . && \
        pip3 --no-cache-dir install . && \
    	git clone https://github.com/Theano/libgpuarray ~/gpuarray && \
	mkdir -p ~/gpuarray/build && cd ~/gpuarray/build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
	make -j"$(nproc)" install && \
	cd ~/gpuarray && \
	python setup.py build && \
	python setup.py install && \
	python3 setup.py build && \
	python3 setup.py install && \ 
	printf '[global]\nfloatX = float32\ndevice = gpu0\n\n[dnn]\ninclude_path = /cudnn_v5/cuda/include\nlibrary_path=/cudnn_v5/cuda/lib64' > ~/.theanorc
	#printf '[global]\nfloatX = float32\ndevice = gpu0\n\n[dnn]\ninclude_path = /cudnn_v4/cuda/include\nlibrary_path=/cudnn_v4/cuda/lib64' > ~/.theanorc 


# keras:
#--------------------
RUN pip --no-cache-dir install --upgrade \
	h5py \
	keras
RUN pip3 --no-cache-dir install --upgrade \
	h5py \
	keras


# Other stuff - move to appropriate locations sometime, I put them here just to save time during build:
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl 
ENV CPATH=$CPLUS_INCLUDE_PATH:/usr/local/cuda/targets/x86_64-linux/include/:/usr/include/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu
ENV LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/x86_64-linux-gnu
ADD cudnn-8.0-linux-x64-v5.0-ga.tgz /cudnn_v5
RUN apt-get install sudo

# make byobu use /bin/bash as shell:
RUN mkdir ~/.byobu && chmod 777 ~/.byobu
RUN printf 'set -g default-shell /bin/bash\nset -g default-command /bin/bash' > ~/.byobu/.tmux.conf 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends imagemagick
