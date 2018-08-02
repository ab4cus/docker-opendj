# e4Cash DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Forgerock OpendDJ (LDAP)
# 
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ docker build -t e4cash/ldap:3.0.0.Final . 
#
# Pull base image
# ---------------
FROM ubuntu:16.04

# Maintainer
# ----------
LABEL maintainer="jose.schmucke@ab4cus.com"
MAINTAINER Jose A. Schmucke <jose.schmucke@ab4cus.com>

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 131
ENV JAVA_VERSION_BUILD 11
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin

ENV DIR_MANAGER_PW_FILE /var/secrets/opendj/dirmanager.pw

ENV MVN_REPO=https://github.com/OpenRock/OpenDJ/releases/download
ENV OPENDJ_VERSION=3.0.0

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get -qq -y install curl ca-certificates tar wget unzip

RUN mkdir -p /opt/opendj
RUN groupadd -r opendj
RUN useradd -r -g opendj -d /opt/opendj -s /sbin/nologin opendj
RUN chown -R opendj:opendj /opt/opendj

# Install Java8 from repository webupd8team/java.
#RUN  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
#  add-apt-repository -y ppa:webupd8team/java && \
#  apt-get update && \
#  apt-get install -y oracle-java8-installer && \
#  rm -rf /var/lib/apt/lists/* && \
#  rm -rf /var/cache/oracle-jdk8-installer

# Install Java8 from oracle (from https://developer.atlassian.com/blog/2015/08/minimal-java-docker-containers/)
RUN  curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/d54c1d3a095b4ff2b6607d096fa80163/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar -xzf - -C /opt && \
  ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
  rm -rf /opt/jdk/*src.zip \
       /opt/jdk/lib/missioncontrol \
       /opt/jdk/lib/visualvm \
       /opt/jdk/lib/*javafx* \
       /opt/jdk/jre/lib/plugin.jar \
       /opt/jdk/jre/lib/ext/jfxrt.jar \
       /opt/jdk/jre/bin/javaws \
       /opt/jdk/jre/lib/javaws.jar \
       /opt/jdk/jre/lib/desktop \
       /opt/jdk/jre/plugin \
       /opt/jdk/jre/lib/deploy* \
       /opt/jdk/jre/lib/*javafx* \
       /opt/jdk/jre/lib/*jfx* \
       /opt/jdk/jre/lib/amd64/libdecora_sse.so \
       /opt/jdk/jre/lib/amd64/libprism_*.so \
       /opt/jdk/jre/lib/amd64/libfxplugins.so \
       /opt/jdk/jre/lib/amd64/libglass.so \
       /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
       /opt/jdk/jre/lib/amd64/libjavafx*.so \
       /opt/jdk/jre/lib/amd64/libjfx*.so && \
 echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

RUN java -version
RUN which java

# Install openDJ
RUN curl -L $MVN_REPO/$OPENDJ_VERSION/OpenDJ-$OPENDJ_VERSION.zip \
       -o /tmp/opendj.zip \
   && unzip /tmp/opendj.zip -d /opt \
   && rm /tmp/*zip

# When testing the build it is faster to use local files
#ADD opendj.zip /tmp/
#RUN unzip /tmp/opendj.zip -d /opt

WORKDIR /opt/opendj

# Creating instance.loc consolidates the writable directories under one root
# We also create the extensions directory
# We set a dir manager default password value here, but this is almost
# certainly not what you want. You should mount a secret volume  - see the README
RUN echo "/opt/opendj/data" > /opt/opendj/instance.loc  && \
    mkdir -p /opt/opendj/data/lib/extensions && \
    mkdir -p /var/secrets/opendj && \
    echo "password"  > ${DIR_MANAGER_PW_FILE}

#ADD Dockerfile /

ADD bootstrap/ /opt/opendj/bootstrap/

ADD start.sh /opt/opendj/start.sh

# Expose ports
EXPOSE 389 636 4444 8989

# Set the default command to run on boot
CMD ["/opt/opendj/start.sh"]

ENTRYPOINT ["/opt/opendj/start.sh"]
