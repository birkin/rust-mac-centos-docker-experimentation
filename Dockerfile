## syntax=docker/dockerfile:1
## build file for centOS supporting rust compilation

## default stuff --------------------------------
FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

## my directory setup ---------------------------
WORKDIR /stuff_on_container/code_on_container
RUN mkdir /stuff_on_container/logs_on_container

## install rust ---------------------------------
# the ` -s -- -y` forces 'yes' to the interactive prompts

RUN curl --proto '=https' --tlsv1.2 -sSf -t 0 https://sh.rustup.rs | sh -s -- -y

## install gcc (needed to compile) --------------
# the '-y' forces 'yes' to the interactive prompts
RUN yum -y install gcc

## EOF
