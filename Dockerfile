FROM nvidia/cudagl:10.1-devel-ubuntu16.04

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


# Install pytorch-retinanet dependencies:
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	tk-dev \
	python-tk

RUN pip --no-cache-dir install --upgrade \
	cffi \
	pycocotools \
	requests

RUN pip3 --no-cache-dir install --upgrade \
	cffi \
	pycocotools \
	requests

RUN pip --no-cache-dir install --upgrade ConfigArgParse
RUN pip3 --no-cache-dir install --upgrade ConfigArgParse

# install dlib
WORKDIR /
RUN git clone https://github.com/davisking/dlib.git
WORKDIR dlib
RUN python3 setup.py install
WORKDIR /
RUN rm -rf dlib
RUN pip3 --no-cache-dir install --upgrade face_recognition

# install caffe:
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	libprotobuf-dev \
	libleveldb-dev \
	libsnappy-dev \
	libopencv-dev \
	libhdf5-serial-dev \
	protobuf-compiler \
	libatlas-base-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	libgflags-dev \
	libgoogle-glog-dev \
	liblmdb-dev


WORKDIR /
RUN git clone https://github.com/BVLC/caffe.git
WORKDIR caffe
RUN cp Makefile.config.example Makefile.config
# change options in Makefile.config programmatically:
RUN sed -i -e 's/# USE_CUDNN := 1/USE_CUDNN := 1/g' Makefile.config
RUN sed -i -e 's/# WITH_PYTHON_LAYER := 1/WITH_PYTHON_LAYER := 1/g' Makefile.config
RUN sed -i -e 's#INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include#INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial /usr/local/lib/python2.7/dist-packages/numpy/core/include#g' Makefile.config
RUN sed -i -e 's#LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib#LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/hdf5 /usr/lib/x86_64-linux-gnu/hdf5/serial#g' Makefile.config
# remove unsupported compute_20 cuda arch.
RUN sed -i -e 's/-gencode arch=compute_20,code=sm_20//g' Makefile.config
RUN sed -i -e 's/-gencode arch=compute_20,code=sm_21//g' Makefile.config

RUN make all -j8
RUN make test -j8
#RUN make runtest -j8
RUN make pycaffe

ENV PYTHONPATH=${PYTHONPATH}:/caffe/python

RUN pip --no-cache-dir install --upgrade GPUtil
RUN pip3 --no-cache-dir install --upgrade GPUtil

RUN pip --no-cache-dir install --upgrade tqdm
RUN pip3 --no-cache-dir install --upgrade tqdm

# build regularized losses dependencies
WORKDIR /
RUN git clone https://github.com/meng-tang/rloss.git
WORKDIR rloss/pytorch/wrapper/bilateralfilter
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        swig
RUN swig -python -c++ bilateralfilter.i
RUN python3 setup.py build
WORKDIR /
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	python3-tk

# pyrender
RUN pip --no-cache-dir install --upgrade trimesh \
					pyrender
RUN pip3 --no-cache-dir install --upgrade trimesh \
					pyrender

