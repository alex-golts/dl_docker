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

# curl and sudo need update:
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl \
	sudo


# libraries:
#-------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libboost-all-dev \
	imagemagick


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

#RUN pip3 --no-cache-dir install --upgrade pip

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
	Pillow \
	scikit-image \
	https://github.com/Lasagne/Lasagne/archive/master.zip

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
	Pillow \
	opencv-python \
	scikit-image \
	https://github.com/Lasagne/Lasagne/archive/master.zip
	

# pytorch:
#-------------------
RUN pip --no-cache-dir install --upgrade \
	http://download.pytorch.org/whl/cu80/torch-0.4.1-cp27-cp27mu-linux_x86_64.whl \
	torchvision

RUN pip3 --no-cache-dir install --upgrade \
	http://download.pytorch.org/whl/cu80/torch-0.4.1-cp35-cp35m-linux_x86_64.whl \
	torchvision


# tensorflow:
#--------------------

RUN pip --no-cache-dir install tensorflow-gpu==1.4.1
RUN pip3 --no-cache-dir install tensorflow-gpu==1.4.1

# define sudo user:
#-------------------
#ARG HOME=$HOME
#ARG UID=$UID
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN useradd -m -s /bin/bash dluser && echo "dluser:dlpass" | chpasswd && adduser dluser sudo
#RUN useradd -u 1000 -g 0 -m dluser
#RUN usermod -aG sudo dluser
#RUN echo 'dluser:dlpass' | chpasswd
#COPY entrypoint.sh /entrypoint.sh
WORKDIR /home/dluser
ENV HOME /home/dluser
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

# theano:
#--------------------
#RUN pip --no-cache-dir install git+https://github.com/Theano/Theano.git#egg=Theano
#RUN pip3 --no-cache-dir install git+https://github.com/Theano/Theano.git#egg=Theano
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#	libblas-dev && \
#	wget -qO- https://github.com/Theano/Theano/archive/rel-0.8.2.tar.gz | tar xz -C ~ && \
#	cd ~/Theano* && \
#	pip --no-cache-dir install . && \
#        pip3 --no-cache-dir install . && \
#    	git clone https://github.com/Theano/libgpuarray ~/gpuarray && \
#	mkdir -p ~/gpuarray/build && cd ~/gpuarray/build && \
#	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
#	make -j"$(nproc)" install && \
#	cd ~/gpuarray && \
#	python setup.py build && \
#	python setup.py install && \
#	python3 setup.py build && \
#	python3 setup.py install && \ 
#	printf '[global]\nfloatX = float32\ndevice = gpu0\n\n[dnn]\ninclude_path = /cudnn_v5/cuda/include\nlibrary_path=/cudnn_v5/cuda/lib64' > ~/.theanorc
	#printf '[global]\nfloatX = float32\ndevice = gpu0\n\n[dnn]\ninclude_path = /cudnn_v4/cuda/include\nlibrary_path=/cudnn_v4/cuda/lib64' > ~/.theanorc 


# keras:
#--------------------
RUN pip --no-cache-dir install --upgrade \
	h5py \
	keras
RUN pip3 --no-cache-dir install --upgrade \
	h5py \
	keras


# Set environment variables:
#-----------------------------
ENV CPATH=$CPLUS_INCLUDE_PATH:/usr/local/cuda/targets/x86_64-linux/include/:/usr/include/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu
ENV LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/x86_64-linux-gnu
#ADD cudnn-8.0-linux-x64-v5.0-ga.tgz /cudnn_v5


# make byobu use /bin/bash as shell:
#-----------------------------------
RUN mkdir ~/.byobu && chmod 777 ~/.byobu
RUN printf 'set -g default-shell /bin/bash\nset -g default-command /bin/bash' > ~/.byobu/.tmux.conf 


# more stuff - later move them to appropriate places:
# ---------------------------------------------------
RUN pip --no-cache-dir install --upgrade tensorboardX
RUN pip3 --no-cache-dir install --upgrade tensorboardX

RUN pip --no-cache-dir install --upgrade jupyter
RUN pip3 --no-cache-dir install --upgrade jupyter

RUN pip --no-cache-dir install --upgrade configobj
RUN pip3 --no-cache-dir install --upgrade configobj

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends firefox


# caffe2 dependencies:
# --------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	libgoogle-glog-dev \
	libgtest-dev \
	libiomp-dev \
	libleveldb-dev \
	liblmdb-dev \
	libopencv-dev \
	libopenmpi-dev \
	libsnappy-dev \
	libprotobuf-dev \
	openmpi-bin \
	openmpi-doc \
	protobuf-compiler \
	libgflags-dev

RUN pip --no-cache-dir install --upgrade future \
	protobuf \
	pyyaml \
	typing
RUN pip3 --no-cache-dir install --upgrade future \
	protobuf \
	pyyaml \
	typing

# Clone Caffe2's source code from our Github repository
WORKDIR /
RUN git clone --recursive https://github.com/pytorch/pytorch.git
WORKDIR /pytorch
# temporary solution. installation worked here and then broke
RUN git submodule update --init 
RUN git checkout 238b4b9236c8f0b36667ff9a83ca9125e34e7713

#RUN FULL_CAFFE2=1 python setup.py install

# Create a directory to put Caffe2's build files in
RUN mkdir build 
WORKDIR build	

# Configure Caffe2's build
# This looks for packages on your machine and figures out which functionality
# to include in the Caffe2 installation. The output of this command is very
# useful in debugging.
RUN cmake ..

# Compile, link, and install Caffe2
RUN make install -j8

# Additional caffe2 dependencies:
RUN pip --no-cache-dir install --upgrade hypothesis==3.40.0 \
	pydot 

RUN pip3 --no-cache-dir install --upgrade hypothesis==3.40.0 \
	pydot 

# Install COCO API:
WORKDIR /
RUN git clone https://github.com/cocodataset/cocoapi.git
WORKDIR /cocoapi/PythonAPI
RUN make install -j8

# Install Detectron:
WORKDIR /
RUN git clone https://github.com/facebookresearch/detectron
RUN pip install -r /detectron/requirements.txt
WORKDIR /detectron
RUN make -j8


WORKDIR /

