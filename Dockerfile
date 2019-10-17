ARG BASE_IMAGE=centos:7
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-10-17

LABEL Name="docktermj/rpm-versioning" \
      Version="1.0.0"

ARG PROGRAM_NAME="unknown"
ARG BUILD_VERSION=0.0.0
ARG BUILD_ITERATION=0

# Install packages via yum.

RUN yum -y install \
  gcc \
  make \
  rpm-build \
  ruby-devel \
  rubygems \
  which

# Install Effing Package Manager (FPM).

RUN gem install --no-ri --no-rdoc fpm

# Import files.

ADD ./artifacts/ /artifacts

# Package files as rpm

ENV REFRESHED_AT_2=2019-10-17-1

VOLUME /output
WORKDIR /output

RUN fpm \
  --input-type dir \
  --output-type rpm \
  --name senzingapi \
  --version 9.0.0 \
  /artifacts=/opt/mjd/g2-9.0.0

RUN fpm \
  --input-type dir \
  --output-type rpm \
  --name senzingapi \
  --version 9.1.0 \
  /artifacts=/opt/mjd/g2-9.1.0

# In an active container, run a bash shell

CMD ["/bin/bash"]
