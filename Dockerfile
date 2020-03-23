FROM usgsastro/jenkins-worker:centos

SHELL ["/bin/bash", "-c"]
ENV CONDA_HOME /home/jenkins/.conda
ENV PATH $CONDA_HOME/bin:$PATH

USER root

RUN yum update -y &&                            \
    yum group install -y "Development Tools" && \
    yum install -y                              \
        bzip2                                   \
        ca-certificates                         \
        curl                                    \
	vim-common				\
	findutils				\
        mesa-libGL-devel &&                     \
    yum clean all
    
# Git v2
RUN yum remove -y git &&                                                \
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm &&	\
    yum install -y git2u-all

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

