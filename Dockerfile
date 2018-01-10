

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

ENV JAVA_HOME /usr/java/latest
ENV JRE_HOME /usr/java/latest/jre
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin

#RUN rm /root/.bash_profile
#COPY .bash_profile /root/
#RUN source /root/.bash_profile

##### Install basic linux tools #####
RUN yum install -y wget unzip dialog curl sudo lsof vim axel telnet

##### Add Cloudera CDH 5 repository #####
RUN wget http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo -O /etc/yum.repos.d/cloudera-cdh5.repo
RUN rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
#####

##### Install HDFS services #####
RUN yum install -y hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-hdfs-datanode

##### Install YARN services #####
RUN yum install -y hadoop-yarn-resourcemanager hadoop-yarn-nodemanager hadoop-yarn-proxyserver

##### Install MapReduce services #####
RUN yum install -y hadoop-mapreduce hadoop-mapreduce-historyserver

##### Install Hadoop client & Hadoop conf-pseudo #####
RUN yum install -y  hadoop-client hadoop-conf-pseudo

##### Install Zookeeper #####
#RUN yum install -y zookeeper zookeeper-server

##### Install HBase #####
#RUN yum install -y hbase-master hbase hbase-thrift

##### Install HBase Region Server #####
#RUN yum install -y hbase-regionserver

##### Install Oozie #####
#RUN yum install -y oozie oozie-client

##### Install Spark #####
RUN yum install -y spark-core spark-master spark-worker spark-history-server spark-python

##### Install Hive #####
#RUN yum install -y hive hive-metastore hive-hbase

##### Install Hue #####
#RUN yum install -y hue hue-server

##### Install SolR #####
#RUN yum -y install solr-server hue-search


##### Install MySQL and connector #####
#RUN yum -y install mysql mysql-server mysql-connector-java
#RUN ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar
##### Note: Will use mysql for Hive metastore


##### Format HDFS #####
USER hdfs
RUN hdfs namenode -format
USER root
#####


##### Initialize HDFS Directories #####
RUN bash -c 'for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do service $x start ; done' ; \
    bash /usr/lib/hadoop/libexec/init-hdfs.sh \
	#oozie-setup sharelib create -fs hdfs://localhost -locallib /usr/lib/oozie/oozie-sharelib-yarn.tar.gz ; \
    bash -c 'for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do service $x stop ; done' ;
##### Note: Keep commands on a single line, as we need to init HDFS while services are running


##### Set up Oozie / HUE / Hive ??? #####
#RUN oozie-setup db create -run
#RUN sed -i 's/secret_key=/secret_key=_S@s+D=h;B,s$C%k#H!dMjPmEsSaJR/g' /etc/hue/conf/hue.ini

##### Make this container SSH friendly #####
RUN yum -y install openssh-server openssh-clients
#Start `sshd` to generate host DSA & RSA keys
RUN service sshd start


#ADD files/hive-site.xml /usr/lib/hive/conf/

# Add the Hadoop start-up scripts
ADD scripts/* /opt/

ENV LANG en_US.UTF-8

ADD run.sh /usr/bin/

ADD ojdbc6.jar /opt/

RUN echo "spark.executor.extraClassPath=/opt/ojdbc6.jar | tee -a /etc/spark/conf/spark-defaults.conf"
RUN echo "spark.driver.extraClassPath=/opt/ojdbc6.jar | tee -a /etc/spark/conf/spark-defaults.conf"


CMD ["bash"]



