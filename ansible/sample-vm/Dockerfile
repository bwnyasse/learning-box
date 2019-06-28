## @description : Setup ubuntu and extra additional packages

FROM ubuntu:xenial

LABEL maintainer="@TEAM STACK-LABS"

## -----
## Requirement to run ansible on a remote host:
## Python must be available
## -----
RUN apt-get update \
    && apt-get install -y python keychain sudo openssh-server \
    && mkdir /var/run/sshd \
	&& mkdir -p /root/.ssh \
	&& chmod -R 700 /root/.ssh \
    && sed -i '/UseDNS/c\UseDNS no' /etc/ssh/sshd_config \
	&& /usr/bin/ssh-keygen -A

EXPOSE 22
