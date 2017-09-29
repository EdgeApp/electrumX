FROM ubuntu:16.04

USER root

RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*

# Install system dependencies
RUN sudo apt-get -y update
RUN sudo apt-get -y upgrade
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:jonathonf/python-3.6
RUN sudo apt-add-repository ppa:bitcoin/bitcoin
RUN sudo apt-get -y update
RUN sudo apt-get -y upgrade
RUN sudo apt-get install -y git bitcoind python3.6 python3.6-dev python3-setuptools python3-pip libleveldb-dev

# Create Main Volume
RUN sudo mkdir datadrive

# ---- ElectrumX ----
RUN git clone https://github.com/kyuupichan/electrumx.git
WORKDIR /electrumx
RUN pip3 install aiohttp pylru plyvel
RUN sudo python3.6 setup.py install
RUN mkdir /datadrive/electrumx
VOLUME /datadrive/electrumx
RUN echo "ElectrumX server courtesy of Airbitz Inc. https://airbitz.co" > /datadrive/banner

# ---- Bitcoin Core ----
RUN sudo mkdir /datadrive/bitcoind
VOLUME /datadrive/bitcoind

EXPOSE 50001

WORKDIR /
COPY ./electrumx.sh /electrumx.sh
COPY ./bitcoin.conf /bitcoin.conf
COPY ./run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh