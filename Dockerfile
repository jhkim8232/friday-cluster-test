FROM docker.io/centos:7.4.1708

USER root
WORKDIR /root/usr

RUN mkdir -p /root/usr
RUN yum -y update
RUN yum -y install git

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
RUN sha256sum go1.13.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
RUN PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/$PROTOC_ZIP
RUN unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
RUN unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
RUN rm -f $PROTOC_ZIP
RUN curl -sL https://rpm.nodesource.com/setup_10.x |  bash -
RUN yum -y install nodejs
RUN yum -y install git
RUN yum -y install centos-release-scl
RUN yum -y install devtoolset-7

RUN mkdir -p /root/usr/go/src
RUN mkdir -p /root/usr/go/pkg
RUN mkdir -p /root/usr/go/bin

RUN echo 'export GOROOT=/usr/local/go' >> .bash_profile
RUN echo 'export GOPATH=/root/usr/go' >> .bash_profile
RUN echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' >> .bash_profile
RUN echo '. /opt/rh/devtoolset-7/enable' >> .bash_profile
RUN source .bash_profile

RUN go get github.com/hdac-io/friday
RUN cd go/src/github.com/hdac-io/friday
RUN npm install -g assemblyscript@0.9.1
RUN make install

RUN systemctl stop firewall
RUN systemctl disable firewalld

RUN cd /root/usr
RUN git clone https://github.com/buryeye7/friday-cluster-test
RUN cd friday-test
ENTRYPOINT ["./tmp-daemon.sh"]

