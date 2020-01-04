#1 Install linux Server


echo "=> Starting configuration: $pwd"

hostname

echo deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted  > /etc/apt/sources.list
apt-get update && apt --fix-broken install -y
apt-get install -y openssh-server


# Add hosts to the hostname
echo 172.20.10.4 master >> /etc/hosts
echo 172.20.10.5 slave1 >> /etc/hosts
echo 172.20.10.6 slave2 >> /etc/hosts

#7 download hadoop 
cp /Provision/hadoop-3.2.1.tar.gz .
tar -xzf hadoop-3.2.1.tar.gz
mv -v hadoop-3.2.1 /usr/local/hadoop
mkdir -p /home/dba/hadoop_tmp/{data,name} 
rm hadoop-3.2.1.tar.gz


#7.2 Copy configuration files for master node.

cp -v /Provision/master_Noeud/* /usr/local/hadoop/etc/hadoop/

if test "$HOSTNAME" = master ; then
	cat /Provision/master_Noeud/netplan-server > /etc/netplan/50-cloud-init.yml
	echo "=====>>>>> IN MASTER"
fi


if test "$HOSTNAME" = slave1 ; then
	cat /Provision/master_Noeud/netplan-slave1 > /etc/netplan/50-cloud-init.yml
	echo localhost > /usr/local/hadoop/etc/hadoop/workers
fi

if test "$HOSTNAME" = slave2 ; then
	cat /Provision/master_Noeud/netplan-slave2 > /etc/netplan/50-cloud-init.yml
	echo localhost > /usr/local/hadoop/etc/hadoop/workers
fi




#6 install java
#apt install -y openjdk-8-jdk sshpass
#update-java-alternatives -l




#4 Generate key and copied it 
mkdir /root/.ssh

if test "$HOSTNAME" = master ; then
	ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa
	cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
	chmod go-w /root /root/.ssh
	chmod 0600 /root/.ssh/authorized_keys -v
fi







#7.1 Set up hadoop environment variables.
echo "Running exports"
echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /root/.bashrc
echo export PATH=\$JAVA_HOME/bin:\$PATH >> /root/.bashrc
echo export HADOOP_HOME=/usr/local/hadoop >> /root/.bashrc
echo export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH >> /root/.bashrc
echo export HADOOP_CONF_DIR=\$HADOOP_HOME"/etc/hadoop" >> ~/.bashrc
echo export HDFS_NAMENODE_USER="root" >> /root/.bashrc
echo export HDFS_DATANODE_USER="root" >> /root/.bashrc
echo export HDFS_SECONDARYNAMENODE_USER="root" >> /root/.bashrc
echo export YARN_RESOURCEMANAGER_USER="root" >> /root/.bashrc
echo export YARN_NODEMANAGER_USER="root" >> /root/.bashrc

# Activer les modifications 
source /root/.bashrc

cat /root/.bashrc

tail -f /dev/null
#if test "$HOSTNAME" = master ; then
#	runuser -l dba -c '/usr/local/hadoop/bin/hdfs namenode -format'
#fi


# Format HDFS
#/usr/local/hadoop/bin/hdfs namenode -format


#10 Start hadoop services
#/usr/local/hadoop/sbin/start-dfs.sh &
#if test "$HOSTNAME" = master ; then
# 	/usr/local/hadoop/sbin/start-all.sh &
#fi

#11 Connect to master to verify 
# get ip adress
# ifconfig 
# then type 
#http://ipAdress:9870
#http://ipAdress:8088



