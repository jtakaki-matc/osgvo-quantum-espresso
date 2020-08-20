FROM opensciencegrid/osgvo-ubuntu-18.04

LABEL opensciencegrid.name="Quantum Espresso"
LABEL opensciencegrid.description="A suite for first-principles electronic-structure calculations and materials modeling"
LABEL opensciencegrid.url="https://www.quantum-espresso.org/"
LABEL opensciencegrid.category="Tools"
LABEL opensciencegrid.definition_url="https://github.com/opensciencegrid/osgvo-quantum-espresso"

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get update && apt-get install -y --no-install-recommends \
        fftw3-dev \
        liblapack-dev \
        libopenmpi-dev \
        openmpi-bin \
        openmpi-common \
        openssh-client \
        rsh-client \
        && \
    apt-get clean 

RUN cd /tmp && \
    rm -rf qe-* && \
    wget -nv https://github.com/QEF/q-e/archive/qe-6.6.tar.gz && \
    tar xzf qe-6.6.tar.gz && \
    cd q-e-qe-6.6 && \
    ./configure --prefix=/opt/qe --enable-openmp && \
    make all && \
    make install && \
    cd /tmp && \
    rm -rf q-e-qe-* qe-*

# some extra singularity stuff
COPY 95-osgvo-qe.sh /.singularity.d/env/
COPY labels.json /.singularity.d/

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

