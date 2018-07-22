FROM centos:7

RUN yum -y install gcc gcc-c++ gcc-gfortran git vim-enhanced which ruby make bzip2 m4

ADD entrypoint.sh /

ENTRYPOINT /entrypoint.sh

LABEL description "Test environment for STARMAN"
LABEL maintainer "Li Dong <dongli@lasg.iap.ac.cn>"
LABEL version "0.0.1"
