
# Java
#yum -y install java-1.8.0-openjdk-devel

# Build Esentials (minimal)
yum -y install gcc gcc-c++ kernel-devel make automake autoconf swig git unzip libtool binutils

# Extra Packages for Enterprise Linux (EPEL) (for pip, zeromq3)
yum -y install epel-release

# Python
yum -y install numpy python-devel python-pip
pip install --upgrade pip

# Other TF deps
yum -y install freetype-devel libpng12-devel zip zlib-devel giflib-devel zeromq3-devel
pip install grpcio_tools mock

# HTTP2 Curl
yum -y install libev libev-devel zlib zlib-devel openssl openssl-devel
pushd /var/tmp
#git clone https://github.com/tatsuhiro-t/nghttp2.git
cd nghttp2
autoreconf -i
automake
autoconf
./configure
make
sudo make install
echo '/usr/local/lib' > /etc/ld.so.conf.d/custom-libs.conf
ldconfig
popd

pushd /var/tmp
#wget http://curl.haxx.se/download/curl-7.46.0.tar.bz2
#tar -xvjf curl-7.46.0.tar.bz2
cd curl-7.46.0
./configure --with-nghttp2=/usr/local --with-ssl
make
make install
ldconfig
popd

# Bazel
pushd /var/tmp
#wget https://github.com/bazelbuild/bazel/releases/download/0.3.2/bazel-0.3.2-installer-linux-x86_64.sh
chmod +x bazel-*
./bazel-*
export PATH=/usr/local/bin:$PATH
popd

# TF Serving
#git clone --recurse-submodules https://github.com/tensorflow/serving
pushd serving
git checkout ec36a91d81e6cd844586eeffdfdc22f415f3b11e # commit used in build
pushd tensorflow
git checkout 4e8497dcdb7918082732c01cf777f3559fc8168b # commit used in build
#PYTHON_BIN_PATH=/usr/bin/python PYTHON_LIB_PATH=/usr/lib64/python2.7/site-packages TF_NEED_GCP=0 TF_NEED_HDFS=0 TF_NEED_CUDA=0 ./configure
PYTHON_BIN_PATH=/root/anaconda/bin/python PYTHON_LIB_PATH=/root/anaconda/lib/python2.7/site-packages TF_NEED_GCP=0 TF_NEED_HDFS=0 TF_NEED_CUDA=0 ./configure
popd
bazel build -c opt //tensorflow_serving/model_servers:tensorflow_model_server
popd
