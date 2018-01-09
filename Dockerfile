

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

# Set the environment variables1
ENV HOME /root

# Working directory
WORKDIR /root

#installing Java

RUN yum -y install wget \
	&& yum install -y wget openssl ca-certificates \
	&& wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm" -O /tmp/jdk-8u151-linux-x64.rpm \
	&& rpm -ivh /tmp/jdk-8u151-linux-x64.rpm
	
	
RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

#ENV JAVA_HOME /usr/java/latest
COPY .bash_profile /




# Default command
CMD ["bash"]

