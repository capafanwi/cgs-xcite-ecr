# When running from linux,git bash or equivelent nix command line
# Set up an ssh config that has this included (~/.ssh/config, use your own username):
#
# Host github.com-det
#     Hostname github.com
#     IdentityFile=/home/username/.ssh/id_deploy_det
# Host github.com-bpu
#     Hostname github.com
#     IdentityFile=/home/username/.ssh/id_deploy_bpu
#
# Make sure you have all the above id_deploy* private keys also in ~/.ssh
# Run the build like this (note the change in context):
# docker build -f Dockerfile -t gpu_tasks ~/.ssh
#
#Run the docker image and mount like a folder like this:
# docker run --gpus all --mount type=bind,source="/data/folder/Waxhaw_testing",target=/Waxhaw_testing -it gpu_tasks /bin/bash
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04 as intermediate

#ARG OPENCV_VERSION=4.8.1
ARG BDA_PIPELINE_UTILIES_TAG=2.23.0-snapshot
ARG BDA_DETECTRON_TAG=2.5.0-snapshot
ARG OPENMVS_TAG=v2.2.0
ARG DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV NVIDIA_VISIBLE_DEVICES=all
ENV FORCE_CUDA="1"

RUN apt-get update && apt-get -y install \
    git \
    build-essential \
    wget \
    cmake \
    pkg-config \
    unzip \
    ninja-build \
    python3-dev \
    python3-pip \
    #Skymask
    #libboost-program-options-dev \
    #Opencv
    #yasm \
    #checkinstall \
    #libjpeg-dev \
    #libpng-dev \
    #libtiff-dev \
    #libavcodec-dev \
    #libavformat-dev \
    #libswscale-dev \
    #libtbb-dev \
    #libatlas-base-dev \
    #gfortran \
    #libgflags-dev \
    #libprotobuf-dev \
    #protobuf-compiler \
    # Detectron
    ca-certificates \
    python3-opencv \
    # openMVS
    libboost-iostreams-dev \
    libboost-system-dev \
    libboost-serialization-dev \
    libcgal-dev \
    libeigen3-dev \
    libopencv-dev \
    libceres-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Detectron dependencies
RUN pip install --user tensorboard==2.15.0 torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0

# add credentials on build
RUN mkdir /root/.ssh
COPY /id_deploy* /root/.ssh
COPY /config /root/.ssh
RUN sed -i 's^/home/[a-z]*/^/root/^g' /root/.ssh/config
RUN chmod 600 /root/.ssh/*

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

#Echo is here to update if you need to force the layer to reload instead of use cache
RUN git clone https://github.com/facebookresearch/detectron2 detectron2 && \
    cd detectron2 && git checkout 8985070
RUN echo '1' >/dev/null && git clone --branch ${BDA_DETECTRON_TAG} git@github.com-det:Unity-Technologies/bda-detectron.git
RUN echo '4' >/dev/null && git clone --branch ${BDA_PIPELINE_UTILIES_TAG} git@github.com-bpu:Unity-Technologies/bda-pipeline-utilities.git
RUN echo '1' >/dev/null && git clone --branch ${OPENMVS_TAG} --recurse-submodules https://github.com/cdcseacave/openMVS.git

#RUN  echo '2' >/dev/null && git clone --branch develop git@github.com:Unity-Technologies/bda-skymask.git
#TODO Need to update the skymask repo since this seems to be required now.
#RUN sed -i.bak '/#find_package(Vulkan REQUIRED)/c find_package(Iconv REQUIRED)' /opt/bda-skymask/CMakeLists.txt


#########################
#  OpenCV Build
#########################
# RUN cd /opt/ && \
#     # Download and unzip OpenCV and opencv_contrib and delete zip files
#     wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip && \
#     unzip $OPENCV_VERSION.zip && \
#     rm $OPENCV_VERSION.zip && \
#     wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip && \
#     unzip ${OPENCV_VERSION}.zip && \
#     rm ${OPENCV_VERSION}.zip

    # Create build folder and switch to it
# RUN mkdir /opt/opencv-${OPENCV_VERSION}/build && cd /opt/opencv-${OPENCV_VERSION}/build && \
#     # Cmake configure
#     cmake \
#         -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
#         -DWITH_TBB=1 \
#         -DENABLE_FAST_MATH=1 \
#         -DCUDA_FAST_MATH=1 \
#         -DWITH_CUBLAS=1 \
#         -DWITH_CUDA=1 \
#         -DBUILD_opencv_cudacodec=0 \
#         -DWITH_CUDNN=1 \
#         -DOPENCV_DNN_CUDA=1 \
#         -DWITH_V4L=1 \
#         -DWITH_QT=0 \
#         -DWITH_OPENGL=1 \
#         -DWITH_GSTREAMER=0 \
#         -DBUILD_SHARED_LIBS=0 \
#         -DBUILD_TESTS=0 \
#         -DBUILD_PERF_TESTS=0 \
#         -DBUILD_EXAMPLES=0 \
#         -DWITH_OPENEXR=0 \
#         -DINSTALL_PYTHON_EXAMPLES=OFF \
#         -DINSTALL_C_EXAMPLES=OFF \
#         -DBUILD_EXAMPLES=OFF \
#         -DCMAKE_BUILD_TYPE=RELEASE \
#         -DCMAKE_INSTALL_PREFIX=/opt/opencv-${OPENCV_VERSION}/build/install \
#         ..
#     #cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=./installFiles -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_CUDA=ON -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -D BUILD_opencv_cudacodec=OFF -D WITH_CUDNN=ON -D OPENCV_DNN_CUDA=ON -D CUDA_ARCH_BIN=8.7 -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D WITH_GSTREAMER=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_PC_FILE_NAME=opencv.pc -D OPENCV_ENABLE_NONFREE=ON -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules -D INSTALL_PYTHON_EXAMPLES=OFF -D INSTALL_C_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF .. &&\
# # Make
# WORKDIR /opt/opencv-${OPENCV_VERSION}/build
# RUN make -j"$(nproc)"
# # Install to /usr/local/lib
# RUN make install
# RUN cp -r /opt/opencv-${OPENCV_VERSION}/build/install /usr/local && \
#     ldconfig && \
#     # Remove OpenCV sources and build folder
#     rm -rf /opt/opencv-${OPENCV_VERSION} && rm -rf /opt/opencv_contrib-${OPENCV_VERSION}

# COPY opencv/build/install /opt/opencv/build/install
# RUN cp -r /opt/opencv/build/install/* /usr/local
# RUN ldconfig -n -v /usr/local/lib

#########################
#  SkyMask Build
#########################
# RUN cd /opt/bda-skymask &&\
#     mkdir -p build && cd build &&\
#     cmake .. &&\
#     cmake --build . --config Release -j

#########################
#  sfm-utils Build
#########################
#install golang 1.21.4
RUN wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz &&\
    tar -xzf go1.21.4.linux-amd64.tar.gz -C /usr/local
ENV PATH="${PATH}:/usr/local/go/bin"

WORKDIR /bda-pipeline-utilities

RUN go mod download && \
    go build ./cmd/sfm-utils

#########################
#  Detectron Build
#########################
# This will by default build detectron2 for all common cuda architectures and take a lot more time,
# because inside `docker build`, there is no way to tell which architecture will be used.
WORKDIR /
#ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
ARG TORCH_CUDA_ARCH_LIST="Maxwell;Maxwell+Tegra;Pascal;Volta;Turing" # Kepler support has been dropped in compute 3.x
ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"

RUN pip install --user -e detectron2
ENV FVCORE_CACHE="/tmp"

#########################
#  OpenMVS Build
#########################
RUN wget https://github.com/cnr-isti-vclab/vcglib/archive/refs/tags/2022.02.tar.gz &&\
    tar -xvf 2022.02.tar.gz -C /usr/local/include/ && rm 2022.02.tar.gz
ENV VCG_ROOT=/usr/local/include/vcglib-2022.02/
# COPY eigen /eigen
# COPY openMVS /openMVS
# RUN apt-get update && apt-get -y install \
#     curl zip unzip tar autoconf
# RUN git clone https://github.com/Microsoft/vcpkg.git
# RUN ./vcpkg/bootstrap-vcpkg.sh
WORKDIR /openMVS
# RUN rm -rf /openMVS/make/*
RUN cmake -B make -S . -DCMAKE_BUILD_TYPE=Release -DCUDA_CUDA_LIBRARY=/usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so -DCMAKE_INSTALL_PREFIX=/openMVS/make/install &&\
    cmake --build make -j &&\
    cmake --install make


FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04 AS gpu_tasks

ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV NVIDIA_VISIBLE_DEVICES=all

RUN apt-get update \
    && apt-get install -y \
        wget \
        # SkyMask
        #libgomp1 \
        #libtbb12 \
        #libboost-program-options1.74.0 \
        # Detectron
        python3 \
        python3-dev \
        python3-numpy \
        python3-pip \
        python-is-python3 \
        # bda-detectron
        libavcodec58 \
        libavformat58 \
        libswscale5 \
        # openMVS
        libboost-iostreams1.74.0 \
        libboost-system1.74.0 \
        libboost-serialization1.74.0 \
        libboost-program-options1.74.0 \
        libopencv-imgcodecs4.5d \
        libopencv-calib3d4.5d \
        #utility for argo
        tree \
        curl \
        mosquitto-clients \
        jq \
#         libjpeg-dev \
#         libpng-dev \
#         libtiff-dev \
#         libavcodec-dev \
#         libavformat-dev \
#         libswscale-dev \
#         libavresample-dev \
#         libgstreamer1.0-dev \
#         libgstreamer-plugins-base1.0-dev \
#         libxvidcore-dev \
#         x264 \
#         libx264-dev \
#         libfaac-dev \
#         libmp3lame-dev \
#         libtheora-dev \
#         libfaac-dev \
#         libmp3lame-dev \
#         libvorbis-dev \
#         libopencore-amrnb-dev \
#         libopencore-amrwb-dev \
#         libdc1394-22 \
#         libdc1394-22-dev \
#         libxine2-dev \
#         libv4l-dev \
#         v4l-utils \
#         libgtk-3-dev \
#         python3-testresources \
#         libatlas-base-dev \
#         gfortran \
#         unzip \
#         python3-opencv \
#         ca-certificates \
#         git \
#         sudo \
#         ninja-build \
#         libboost-iostreams-dev \
#         libboost-system-dev \
#         libcgal-dev \
#         libprotobuf-dev \
#         protobuf-compiler \
#         libgflags-dev \
#         libgphoto2-dev \
#         libhdf5-dev \
         imagemagick \
#         tightvncserver \
#         libqt5svg5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Detectron dependencies and pymeshlab for sfm-utils merge verts
RUN pip install --user tensorboard==2.15.0 torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 pymeshlab

# WORKDIR /usr/include/linux
# RUN ln -s -f ../libv4l1-videodev.h videodev.h

# WORKDIR /

# RUN wget https://bootstrap.pypa.io/get-pip.py && \
# 	python3 get-pip.py && \
# 	rm get-pip.py

# RUN pip install pymeshlab xml2dict pygltflib

# # install dependencies
# # See https://pytorch.org/ for other options if you use a different version of CUDA
# RUN pip install tensorboard cmake onnx   # cmake from apt-get is too old THIS IS 7GB
# RUN pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 -f https://download.pytorch.org/whl/torch_stable.html
# RUN pip install --user 'git+https://github.com/facebookresearch/fvcore'

# # install detectron2
# RUN git clone https://github.com/facebookresearch/detectron2 detectron2

# # set FORCE_CUDA because during `docker build` cuda is not accessible
# ENV FORCE_CUDA="1"

# # This will by default build detectron2 for all common cuda architectures and take a lot more time,
# # because inside `docker build`, there is no way to tell which architecture will be used.
# ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
# ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"

# RUN pip install --user -e detectron2

# # Set a fixed model cache directory.
# ENV FVCORE_CACHE="/tmp"

# WORKDIR /detectron2

# ##############################
# #Sky segmentation setup
# ##############################

# #RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/4.7.0.zip
# #RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/refs/tags/4.7.0.zip
# #RUN unzip opencv.zip -d /
# #RUN unzip opencv_contrib.zip -d /
# #WORKDIR /opencv-4.7.0
# #RUN mkdir build
# #WORKDIR /opencv-4.7.0/build
# #RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=./installFiles -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_CUDA=ON -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -D BUILD_opencv_cudacodec=OFF -D WITH_CUDNN=ON -D OPENCV_DNN_CUDA=ON -D CUDA_ARCH_BIN=8.7 -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D WITH_GSTREAMER=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_PC_FILE_NAME=opencv.pc -D OPENCV_ENABLE_NONFREE=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.7.0/modules -D INSTALL_PYTHON_EXAMPLES=OFF -D INSTALL_C_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF ..
# #RUN make -j install
# #copy opencv install folder into user local 

# COPY opencv-4.7.0/build/installFiles /usr/local
# RUN ldconfig -n -v /usr/local/lib

# WORKDIR /
# RUN git clone https://github.com/Tencent/ncnn.git
# WORKDIR /ncnn
# RUN git submodule update --init

#########################
#  Vulkan Install
#########################
# RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | tee /etc/apt/trusted.gpg.d/lunarg.asc && \
#     wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list http://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list
# RUN apt update
# RUN apt install -y vulkan-sdk

# RUN mkdir build
# WORKDIR /ncnn/build
# RUN cmake -DCMAKE_BUILD_TYPE=Release -DNCNN_VULKAN=ON -DNCNN_BUILD_EXAMPLES=OFF ..
# RUN make -j2 install

# WORKDIR /

# #Poisson setup
# COPY PoissonRecon /PoissonRecon

# #OpenMVs setup
# #wget https://github.com/cnr-isti-vclab/vcglib/archive/refs/tags/2022.02.tar.gz
# COPY 2022.02.tar.gz /tmp/2022.02.tar.gz
# RUN tar -xvf /tmp/2022.02.tar.gz -C /usr/local/include/
# ENV VCG_ROOT=/usr/local/include/vcglib-2022.02/
# COPY eigen /eigen
# COPY openMVS /openMVS
# WORKDIR /openMVS/make
# RUN rm -rf /openMVS/make/*
# RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCUDA_CUDA_LIBRARY=/usr/local/cuda-11.7/compat/libcuda.so -DEIGEN3_INCLUDE_DIR=/eigen
# RUN cmake --build . -j
# RUN cmake --install .

#Ktx textures
WORKDIR /
RUN wget https://github.com/KhronosGroup/KTX-Software/releases/download/v4.0.0/KTX-Software-4.0.0-Linux.deb
RUN apt install ./KTX-Software-4.0.0-Linux.deb

# #texture defrag
# COPY texture-defrag /texture-defrag
# RUN mkdir -p /texture-defrag/build
# WORKDIR /texture-defrag/build
# RUN rm -rf *
# RUN qmake ../texture-defrag/texture-defrag.pro -spec linux-g++
# RUN make -j

# #Setup repos
# COPY masking-and-segmentation /masking-and-segmentation
# RUN mkdir -p /masking-and-segmentation/build
# WORKDIR /masking-and-segmentation/build
# RUN rm -rf *
# RUN cmake .. -Dncnn_DIR=../../ncnn/build/install/lib/cmake/ncnn/ -DOpenCV_DIR=../../opencv-4.7.0/build/installFiles/lib/cmake/opencv4/
# RUN cmake --build . --config Release -j

# COPY urbaneng/tools /urbaneng
# COPY detectron2-scripts /detectron2-scripts
# COPY s3-python-utils /s3-python-utils
# COPY --from=build /sfm-utils /sfm-utils
# COPY some-sfm-utils /some-sfm-utils

# #setup vnc
# #RUN apt-get install -y tightvncserver
# COPY urbaneng/docker/gpu_tasks/xstartup /root/.vnc/xstartup
# RUN \
#     /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd"; echo; \
#     touch ~/.Xauthority ;

#########################
#  Skymask Install
#########################
# COPY --from=intermediate /opt/opencv/build/install /usr/local
# COPY --from=intermediate /opt/ncnn/build/install /usr/local
# RUN ldconfig -n -v /usr/local/lib
# COPY --from=intermediate /opt/bda-skymask/build/SkyMask /src/bda-skymask/SkyMask
# COPY --from=intermediate /opt/bda-skymask/skysegsmall_sim-opt-fp16.bin /src/bda-skymask/skysegsmall_sim-opt-fp16.bin
# COPY --from=intermediate /opt/bda-skymask/skysegsmall_sim-opt-fp16.param /src/bda-skymask/skysegsmall_sim-opt-fp16.param

#########################
#  sfm-utils Install
#########################
COPY --from=intermediate /bda-pipeline-utilities/scripts /src/bda-pipeline-utilities/scripts
COPY --from=intermediate /bda-pipeline-utilities/sfm-utils /src/bda-pipeline-utilities/sfm-utils

#########################
#  Detectron Install
#########################
COPY --from=intermediate /detectron2 /src/detectron2
WORKDIR /src
RUN pip install --user -e detectron2
ENV FVCORE_CACHE="/tmp"
COPY --from=intermediate /bda-detectron/*.py /src/bda-detectron/
COPY --from=intermediate /bda-detectron/VERSION /src/bda-detectron/VERSION

#########################
#  openMVS Install
#########################
COPY --from=intermediate /openMVS/make/install /usr/local
RUN pip install numpy==1.26.4

#ENV PATH="${PATH}:/:/urbaneng/:/masking-and-segmentation/build:/detectron2-scripts/:/PoissonRecon/Bin/Linux:/urbaneng/:/usr/local/bin/OpenMVS/:/texture-defrag/build/"
ENV PATH="${PATH}:/src/bda-pipeline-utilities/:/usr/local/bin/OpenMVS/"

WORKDIR /
#ENTRYPOINT export USER=root; export DISPLAY=:1; vncserver :1 && /bin/bash
