FROM fedora:latest

WORKDIR /app

RUN dnf install -y \
  make \
  perl \
  pv \
  wget \
  zip \
  ;

ADD . /app

CMD make;
