FROM centos:centos7

RUN rpm -ivh http://software.ligo.org/lscsoft/scientific/7/x86_64/production/lscsoft-production-config-1.3-1.el7.noarch.rpm
RUN yum clean all
RUN yum makecache

RUN yum -y install python2-pip python-setuptools
RUN yum -y install git2u-all
RUN yum -y install zlib-devel libpng-devel libjpeg-devel libsqlite3-dev sqlite-devel db4-devel openssl-devel

RUN yum install -y fftw-libs-single fftw-devel fftw fftw-libs-long fftw-libs fftw-libs-double
RUN yum install -y gsl gsl-devel

RUN yum install -y libframe-utils libframe-devel libframe

ADD https://git.ligo.org/ligo-cbc/pycbc-software/raw/efd37637fbb568936dfb92bc7aa8a77359c9aa36/x86_64/composer_xe_2015.0.090/composer_xe_2015.0.090.tar.gz /tmp/composer_xe_2015.0.090.tar.gz
RUN mkdir -p /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64
RUN tar -C /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64 -zxvf /tmp/composer_xe_2015.0.090.tar.gz
ADD https://software.intel.com/en-us/license/intel-simplified-software-license /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64/intel-simplified-software-license.html
RUN chmod go+rx /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64/*.so
RUN chmod go+r /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64/intel-simplified-software-license.html
RUN rm -f /tmp/composer_xe_2015.0.090.tar.gz

RUN mkdir -p /etc/stashcache
RUN curl -L https://raw.githubusercontent.com/opensciencegrid/StashCache/master/bin/caches.json > /etc/stashcache/caches.json
RUN curl -L https://raw.githubusercontent.com/opensciencegrid/StashCache/master/bin/stashcp > /bin/stashcp
RUN chmod go+rx /etc/stashcache
RUN chmod go+r /etc/stashcache/caches.json
RUN chmod go+rx /bin/stashcp

RUN pip install --upgrade pip setuptools
RUN pip install lalsuite==6.48.1.dev20180717
RUN pip install -r https://raw.githubusercontent.com/gwastro/pycbc/master/requirements.txt
RUN pip install -r pycbc
