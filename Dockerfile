FROM usgsastro/jenkins-worker:fedora

SHELL ["/bin/bash", "-c"]
ENV CONDA_HOME /home/jenkins/.conda
ENV PATH $CONDA_HOME/bin:$PATH

USER root

RUN dnf update -y &&                            \
    dnf groupinstall -y "Development Tools" &&  \
    dnf install -y                              \
        bzip2                                   \
        ca-certificates                         \
        curl                                    \
        gcc-c++                                 \
        libnsl                                  \
        mesa-libGL-devel                        \
        ninja-build                             \
        vim-common                              \
        findutils                               \
        git &&                                  \
    dnf clean all

# Install conda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh   \
    /home/jenkins/miniconda.sh
RUN chown jenkins:jenkins /home/jenkins/miniconda.sh && \
    chmod +x /home/jenkins/miniconda.sh

USER jenkins
WORKDIR /home/jenkins

RUN ./miniconda.sh -b -p $CONDA_HOME &&                             \
    $CONDA_HOME/bin/conda clean -tipsy &&                           \
    echo ". \$CONDA_HOME/etc/profile.d/conda.sh" >> ~/.bashrc &&    \
    echo "conda activate base" >> ~/.bashrc &&                      \
    rm miniconda.sh
