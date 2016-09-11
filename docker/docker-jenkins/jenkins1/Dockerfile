FROM jenkins:1.651.3

# Becoming ROOT for packages installation
USER root

# GPG key and Entry for Docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
    --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb http://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list

# Install extra packages
### == JDK7
### == BZIP
### == DOCKER
RUN apt-get update && apt-get install -y \
    openjdk-7-jdk \
    bzip2 \
    docker-engine

# Install Maven
WORKDIR /opt
RUN for MVN_VERSION in "3.3.9" ; do \
        MVN_TGZ=apache-maven-${MVN_VERSION}.tar.gz ; \
        MVN_TGZ_URL=http://www.apache.org/dist/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz ; \
        set -x \
            && curl -fSL "$MVN_TGZ_URL" -o "$MVN_TGZ" \
            # && curl -fSL "$MVN_TGZ_URL.asc" -o "$MVN_TGZ.asc" \
            # && gpg --verify "$MVN_TGZ.asc" \
            && tar -xzf ${MVN_TGZ} \
            && export M2_HOME=/opt/apache-maven-${MVN_VERSION} \
            && rm ${MVN_TGZ}* ; \
    done
WORKDIR /

# Plugins Installation
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Add Groovy Init Script
COPY init-scripts/* /usr/share/jenkins/ref/init.groovy.d/
