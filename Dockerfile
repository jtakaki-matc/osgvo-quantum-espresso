FROM opensciencegrid/osgvo-ubuntu-18.04

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get update && apt-get install -y --no-install-recommends \
        liblapack-dev \
        fftw3-dev \
        && \
    apt-get clean 

RUN cd /tmp && \
    rm -rf qe-* && \
    wget -nv https://github.com/QEF/q-e/archive/qe-6.6.tar.gz && \
    tar xzf qe-6.6.tar.gz && \
    cd q-e-qe-6.6 && \
    ./configure --prefix=/opt/qe && \
    make all && \
    make install

# some extra singularity stuff
COPY 95-osgvo-qe.sh /.singularity.d/env/

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
