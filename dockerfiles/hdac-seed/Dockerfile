FROM buryeye7/centos7-hdac-base

USER root
ENV HOME=/root
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/usr/local/lib64:/usr/lib64
ENV GOPATH=$HOME/go
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$HOME/.cargo/bin:$GOPATH/bin:$GOROOT/bin
ENV PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip

WORKDIR $HOME
RUN yum -y upgrade
RUN yum -y update
RUN yum -y install expect 

WORKDIR $GOPATH/src
RUN git clone https://github.com/hdac-io/friday
WORKDIR $GOPATH/src/friday
RUN npm install -g assemblyscript@0.9.1
RUN git checkout v0.8.0
RUN make install

WORKDIR $GOPATH/src
RUN git clone https://github.com/buryeye7/friday-cluster-test
WORKDIR $GOPATH/src/friday-cluster-test

RUN rm -rf $HOME/.nodef
RUN rm -rf $HOME/.clif
RUN mkdir -p $HOME/.nodef
RUN mkdir -p $HOME/.clif
RUN cp -rf kubefiles/node-config/nodef-config/* $HOME/.nodef
RUN cp -rf kubefiles/node-config/clif-config/* $HOME/.clif

EXPOSE 26656/tcp
EXPOSE 26657/tcp
EXPOSE 26660/tcp
EXPOSE 27017/tcp
EXPOSE 1317/tcp
EXPOSE 9090/tcp
EXPOSE 3000/tcp

ENTRYPOINT ["./scripts/start-seed.sh"]
