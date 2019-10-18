ARG BASE_IMAGE=centos:7
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-10-16

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

# ---- YUM testing ---------------------------------

# Package files as rpm

WORKDIR /output/rpm

# Make 2.0

RUN fpm \
  --input-type dir \
  --name xyzzy-2.0 \
  --output-type rpm \
  --version 0 \
  /artifacts/2.0.0/=/opt/xyzzy/xyzzy-2.0

RUN fpm \
  --input-type dir \
  --name xyzzy-2.0 \
  --output-type rpm \
  --version 1 \
  /artifacts/2.0.1/=/opt/xyzzy/xyzzy-2.0

RUN fpm \
  --input-type dir \
  --name xyzzy-2.0 \
  --output-type rpm \
  --version 2 \
  /artifacts/2.0.2/=/opt/xyzzy/xyzzy-2.0

# Make 2.1

RUN fpm \
  --input-type dir \
  --name xyzzy-2.1 \
  --output-type rpm \
  --version 0 \
  /artifacts/2.1.0/=/opt/xyzzy/xyzzy-2.1

RUN fpm \
  --input-type dir \
  --name xyzzy-2.1 \
  --output-type rpm \
  --version 1 \
  /artifacts/2.1.1/=/opt/xyzzy/xyzzy-2.1

RUN fpm \
  --input-type dir \
  --name xyzzy-2.1 \
  --output-type rpm \
  --version 2 \
  /artifacts/2.1.2/=/opt/xyzzy/xyzzy-2.1

# Make 2.2

RUN fpm \
  --input-type dir \
  --name xyzzy-2.2 \
  --output-type rpm \
  --version 0 \
  /artifacts/2.2.0/=/opt/xyzzy/xyzzy-2.2

RUN fpm \
  --input-type dir \
  --name xyzzy-2.2 \
  --output-type rpm \
  --version 1 \
  /artifacts/2.2.1/=/opt/xyzzy/xyzzy-2.2

RUN fpm \
  --input-type dir \
  --name xyzzy-2.2 \
  --output-type rpm \
  --version 2 \
  /artifacts/2.2.2/=/opt/xyzzy/xyzzy-2.2

# Make "uber" packages

RUN fpm \
  --input-type dir \
  --depends xyzzy-2.0-0 \
  --depends xyzzy-2.1-0 \
  --name xyzzy \
  --output-type rpm \
  --version 1

RUN fpm \
  --input-type dir \
  --depends xyzzy-2.0-2 \
  --depends xyzzy-2.2-2 \
  --name xyzzy \
  --output-type rpm \
  --version 2

# ---- APT testing ---------------------------------

# Package files as deb

WORKDIR /output/deb

# Make 2.0

RUN fpm \
  --input-type dir \
  --name xyzzy-2.0 \
  --output-type deb \
  --version 0 \
  /artifacts/2.0.0/=/opt/xyzzy/xyzzy-2.0

RUN fpm \
  --input-type dir \
  --name xyzzy-2.0 \
  --output-type deb \
  --version 1 \
  /artifacts/2.0.1/=/opt/xyzzy/xyzzy-2.0

RUN fpm \
  --input-type dir \
  --name xyzzy-2.0 \
  --output-type deb \
  --version 2 \
  /artifacts/2.0.2/=/opt/xyzzy/xyzzy-2.0

# Make 2.1

RUN fpm \
  --input-type dir \
  --name xyzzy-2.1 \
  --output-type deb \
  --version 0 \
  /artifacts/2.1.0/=/opt/xyzzy/xyzzy-2.1

RUN fpm \
  --input-type dir \
  --name xyzzy-2.1 \
  --output-type deb \
  --version 1 \
  /artifacts/2.1.1/=/opt/xyzzy/xyzzy-2.1

RUN fpm \
  --input-type dir \
  --output-type deb \
  --name xyzzy-2.1 \
  --version 2 \
  /artifacts/2.1.2/=/opt/xyzzy/xyzzy-2.1

# Make 2.2

RUN fpm \
  --input-type dir \
  --name xyzzy-2.2 \
  --output-type deb \
  --version 0 \
  /artifacts/2.2.0/=/opt/xyzzy/xyzzy-2.2

RUN fpm \
  --input-type dir \
  --name xyzzy-2.2 \
  --output-type deb \
  --version 1 \
  /artifacts/2.2.1/=/opt/xyzzy/xyzzy-2.2

RUN fpm \
  --input-type dir \
  --name xyzzy-2.2 \
  --output-type deb \
  --version 2 \
  /artifacts/2.2.2/=/opt/xyzzy/xyzzy-2.2

# Make "uber" packages

RUN fpm \
  --input-type dir \
  --depends xyzzy-2.0-0 \
  --depends xyzzy-2.1-0 \
  --name xyzzy \
  --output-type deb \
  --version 1

RUN fpm \
  --input-type dir \
  --depends xyzzy-2.0-2 \
  --depends xyzzy-2.2-2 \
  --name xyzzy \
  --output-type deb \
  --version 2

# In an active container, run a bash shell

CMD ["/bin/bash"]
