#1 Install linux Server


echo "=> Starting configuration: $pwd"


# Add hosts to the hostname
echo 172.20.10.4 master >> /etc/hosts
echo 172.20.10.5 slave1 >> /etc/hosts
echo 172.20.10.6 slave2 >> /etc/hosts

#7 download hadoop 
cp /vagrant/Provision/hadoop-3.2.1.tar.gz .
tar -xzf hadoop-3.2.1.tar.gz
sudo mv -v hadoop-3.2.1 /usr/local/hadoop
mkdir -p /home/dba/hadoop_tmp/{data,name} 
rm hadoop-3.2.1.tar.gz


#7.2 Copy configuration files for master node.

cp -v /vagrant/Provision/master_Noeud/* /usr/local/hadoop/etc/hadoop/

if test "$HOSTNAME" = master ; then
	cat /vagrant/Provision/master_Noeud/netplan-server > /etc/netplan/50-cloud-init.yml
fi


if test "$HOSTNAME" = slave1 ; then
	cat /vagrant/Provision/master_Noeud/netplan-slave1 > /etc/netplan/50-cloud-init.yml
	echo localhost > /usr/local/hadoop/etc/hadoop/workers
fi

if test "$HOSTNAME" = slave2 ; then
	cat /vagrant/Provision/master_Noeud/netplan-slave2 > /etc/netplan/50-cloud-init.yml
	echo localhost > /usr/local/hadoop/etc/hadoop/workers
fi




#6 install java
apt install -y openjdk-8-jdk sshpass
update-java-alternatives -l


#3.1 attribuer le privl admin dba
useradd -m -p dba -s /bin/bash dba
echo 'dba:dba' | chpasswd
usermod -aG sudo dba
chown -R dba /home/dba



#4 Generate key and copied it 
runuser -l dba -c 'mkdir /home/dba/.ssh'

if test "$HOSTNAME" = master ; then
	runuser -l dba -c 'ssh-keygen -t rsa -P "" -f /home/dba/.ssh/id_rsa'
	runuser -l dba -c 'cat /home/dba/.ssh/id_rsa.pub >> /home/dba/.ssh/authorized_keys'
	runuser -l dba -c 'chmod go-w /home/dba /home/dba/.ssh'
	runuser -l dba -c 'chmod 0600 /home/dba/.ssh/authorized_keys -v'
	runuser -l dba -c 'chown dba /home/dba/.ssh/authorized_keys'
	
fi







#7.1 Set up hadoop environment variables.
echo "Running exports"
runuser -l dba -c 'echo export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 >> /home/dba/.bashrc'
runuser -l dba -c 'echo export PATH=\$JAVA_HOME/bin:\$PATH >> /home/dba/.bashrc'
runuser -l dba -c 'echo export HADOOP_HOME=/usr/local/hadoop >> /home/dba/.bashrc'
runuser -l dba -c 'echo export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH >> /home/dba/.bashrc'
runuser -l dba -c 'echo export HADOOP_CONF_DIR=\$HADOOP_HOME"/etc/hadoop"' >> ~/.bashrc
runuser -l dba -c 'echo export HDFS_NAMENODE_USER="dba" >> /home/dba/.bashrc'
runuser -l dba -c 'echo export HDFS_DATANODE_USER="dba" >> /home/dba/.bashrc'
runuser -l dba -c 'echo export HDFS_SECONDARYNAMENODE_USER="dba" >> /home/dba/.bashrc'
runuser -l dba -c 'echo export YARN_RESOURCEMANAGER_USER="dba" >> /home/dba/.bashrc'
runuser -l dba -c 'echo export YARN_NODEMANAGER_USER="dba" >> /home/dba/.bashrc'

# Activer les modifications 
runuser -l dba -c 'source /home/dba/.bashrc'

cat /home/dba/.bashrc

if test "$HOSTNAME" = master ; then
	runuser -l dba -c '/usr/local/hadoop/bin/hdfs namenode -format'
fi


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



