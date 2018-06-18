FROM fedora:latest

WORKDIR /app

RUN dnf install -y \
  make \
  pv \
  zip \
  ;

ADD . /app

CMD make;
