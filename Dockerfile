

# Pull base image
FROM centos:6.7

# Maintener
MAINTAINER Rabindra Nath Gogoi <rngogoiofficial@gmail.com>

# Update CentOS 6.7
RUN yum update -y && yum upgrade -y

# Install packages
RUN yum install -y unzip wget curl git

# Install EPEL Repository
RUN yum install -y epel-release

# Clean CentOS 6.7
RUN yum clean all

# Set the environment variables
ENV HOME /root

# Working directory
WORKDIR /root

#installing Java

RUN yum install -y wget openssl ca-certificates \
	&& cd /tmp \
	&& wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-i586.tar.gz \
	&& mv jdk-8u151-linux-i586.tar.gz jdk8.tar.gz \
	&& /bin/tar xzf jdk8.tar.gz -C /opt \
    && mv /opt/jdk* /opt/java \
    && rm /tmp/jdk8.tar.gz \
    && update-alternatives --install /usr/bin/java java /opt/java/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac /opt/java/bin/javac 10

ENV JAVA_HOME /opt/java	



# Default command
CMD ["bash"]

