FROM openjdk:8u111-jdk-alpine
MAINTAINER bwnyasse

RUN set -ex \
	&& apk --update add bash curl \
	&& rm -rf /var/cache/apk/*

# Install dependencies
ENV ACTIVATOR_VERSION 1.3.12
RUN curl -O http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VERSION}/typesafe-activator-${ACTIVATOR_VERSION}-minimal.zip
RUN unzip typesafe-activator-${ACTIVATOR_VERSION}-minimal.zip -d / && rm typesafe-activator-${ACTIVATOR_VERSION}-minimal.zip && chmod a+x /activator-${ACTIVATOR_VERSION}-minimal/bin/activator
ENV PATH $PATH:/activator-${ACTIVATOR_VERSION}-minimal/bin

ADD scripts/.minimalbashrc /root/.bashrc

# Prebuild cache
COPY cache/pre-build-cache.zip /root
RUN unzip /root/pre-build-cache.zip -d /root

EXPOSE 9000
EXPOSE 9999
EXPOSE 8888

RUN mkdir /code
WORKDIR /code
VOLUME /code

#ENTRYPOINT ["entrypoint.sh"]
