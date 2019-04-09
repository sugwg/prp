FROM centos:centos7

# Set up extra repositories
RUN rpm -ivh http://software.ligo.org/lscsoft/scientific/7/x86_64/production/lscsoft-production-config-1.3-1.el7.noarch.rpm
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum clean all
RUN yum makecache

# Install tool sets
RUN yum -y groupinstall "Compatibility Libraries" \
                        "Development Tools" \
                        "Scientific Support"

# Update pip and setuptools
RUN yum -y install python2-pip python-setuptools

# Add extra development libraries
RUN yum -y install zlib-devel libpng-devel libjpeg-devel libsqlite3-dev sqlite-devel db4-devel openssl-devel

# Install full git
RUN rpm -e --nodeps git perl-Git
RUN yum -y install git2u-all

# Add numerical libraries needed for lal
RUN yum install -y fftw-libs-single fftw-devel fftw fftw-libs-long fftw-libs fftw-libs-double
RUN yum install -y gsl gsl-devel

# Add LIGO libraries needed for lal
RUN yum install -y libframe-utils libframe-devel libframe
RUN yum install -y libmetaio libmetaio-devel libmetaio-utils

# Add HDF5 development tools for PyCBC
RUN yum install -y hdf5 hdf5-devel

# Install MKL
RUN mkdir -p /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64
RUN curl https://git.ligo.org/ligo-cbc/pycbc-software/raw/efd37637fbb568936dfb92bc7aa8a77359c9aa36/x86_64/composer_xe_2015.0.090/composer_xe_2015.0.090.tar.gz | tar -C /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64 -zxvf -
RUN curl https://software.intel.com/en-us/license/intel-simplified-software-license > /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64/intel-simplified-software-license.html
RUN chmod go+rx /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64/*.so
RUN chmod go+r /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64/intel-simplified-software-license.html

# Install Python development tools
RUN yum install -y python-devel which

# Upgrade to latest python installers
RUN pip install --upgrade pip setuptools

# Install PyCBC dependencies
RUN pip install jupyter
RUN pip install -r https://raw.githubusercontent.com/gwastro/pycbc/master/requirements.txt

# set up environment
ADD etc/profile.d/pycbc.sh /etc/profile.d/pycbc.sh
ADD etc/profile.d/pycbc.csh /etc/profile.d/pycbc.csh

# add singularity profiles
COPY .singularity.d /.singularity.d
RUN cd / && \
    ln -s .singularity.d/actions/exec .exec && \
    ln -s .singularity.d/actions/run .run && \
    ln -s .singularity.d/actions/test .shell && \
    ln -s .singularity.d/runscript singularity

# Install LALSuite
RUN pip install lalsuite==6.48.1.dev20180717

# Install software needed for pycbc_inference
RUN yum install -y openmpi-devel
RUN pip install schwimmbad
RUN MPICC=/usr/lib64/openmpi/bin CFLAGS='-I /usr/include/openmpi-x86_64 -L /usr/lib64/openmpi/lib -lmpi' pip install --no-cache-dir mpi4py

# Install a recent PyCBC
RUN pip install git+git@github.com:gwastro/pycbc.git@f9ba24edd11561e8e5c6ff5f8ed3831007ae2b1c
