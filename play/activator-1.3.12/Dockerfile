FROM openjdk:8u111-jdk-alpine
MAINTAINER bwnyasse

RUN set -ex \
	&& apk add --no-cache --virtual=.build-dependencies wget ca-certificates \
	&& apk --update add bash curl \
	&& rm -rf /var/cache/apk/*

# Install activator and Scala dependencies
ENV ACTIVATOR_VERSION 1.3.12
ENV	SCALA_VERSION=2.12.0
ENV SCALA_HOME=/usr/share/scala

RUN curl -O http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VERSION}/typesafe-activator-${ACTIVATOR_VERSION}-minimal.zip  \
	  && unzip typesafe-activator-${ACTIVATOR_VERSION}-minimal.zip -d /  \
		&& rm typesafe-activator-${ACTIVATOR_VERSION}-minimal.zip  \
		&& chmod a+x /activator-${ACTIVATOR_VERSION}-minimal/bin/activator  \
		&& curl -O https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz  \
		&& tar xzf "scala-${SCALA_VERSION}.tgz"  \
		&& mkdir "${SCALA_HOME}"  \
		&& rm "scala-${SCALA_VERSION}/bin/"*.bat  \
		&& mv "scala-${SCALA_VERSION}/bin" "scala-${SCALA_VERSION}/lib" "${SCALA_HOME}"  \
		&& ln -s "${SCALA_HOME}/bin/"* "/usr/bin/"  \
		&& apk del .build-dependencies  \
		&& rm -rf "scala-${SCALA_VERSION}.tgz"


ENV PATH $PATH:/activator-${ACTIVATOR_VERSION}-minimal/bin

ADD scripts/.minimalbashrc /root/.bashrc
ADD jnotify-lib-0.94 /root/

RUN echo "export LD_LIBRARY_PATH=/root/jnotify-lib-0.94/64-bit_Linux/" >> /root/.bashrc
RUN echo "export _JAVA_OPTIONS='-Duser.home=/root/activator-cache'" >> /root/.bashrc

# Prebuild cache
# COPY cache/pre-build-cache-activator-${ACTIVATOR_VERSION}.zip /root
# RUN unzip /root/pre-build-cache-activator-${ACTIVATOR_VERSION}.zip -d /root

EXPOSE 9000
EXPOSE 9999
EXPOSE 8888

RUN mkdir /code
RUN mkdir /root/activator-cache
WORKDIR /code
VOLUME /code
VOLUME /root/activator-cache

#ENTRYPOINT ["entrypoint.sh"]
