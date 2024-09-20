FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata curl \
&& apt-get install apt-transport-https -y \
&& apt-get install software-properties-common -y \
&& apt-get -y install build-essential checkinstall zlib1g-dev \
&& apt-get -y install mingw-w64 \
&& apt-get -y install git \
&& apt-get -y install zip
RUN mkdir -p /home/scripts
RUN mkdir -p /home/Downloads
COPY . /home/scripts/
RUN rm /home/scripts/Dockerfile
RUN chmod -R a+x /home/scripts
WORKDIR /home/scripts/
