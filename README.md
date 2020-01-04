# Hadoop_Vagrant_Docker
This repo will contain a Vagrantfile + config files to run a hadoop cluster of one master and 2 slaves
Also, it will contain the docker-compose way to run the same cluster using docker-compose.

# How to Vagrant
- Install Vagrant and virtualbox,
In Ubuntu: `sudo apt-get install vagrant virtualbox`
- Clone this repo
`git clone https://github.com/SweeXordious/Hadoop_Vagrant_Docker`
- Download 'hadoop-3.2.1.tar.gz' and put it in provision folder
- Run Vagrant up
`vagrant up`

Wait for the machines to boot up and be provisioned, then:

`vagrant ssh master`

`scp /home/dba/.ssh/id_rsa.pub slave1:/home/dba/.ssh/authorized_keys`

`scp /home/dba/.ssh/id_rsa.pub slave2:/home/dba/.ssh/authorized_keys`

`hadoop namenode -format`

Open /etc/hosts and remove the first master entery in it, then

`/usr/local/hadoop/sbin/start-all.sh`

Open http://172.20.10.4:9870 , http://172.20.10.4:8088 from your host to check if its working. Or use the command `jps` in all nodes to see which services are running.

# How to Docker
- Install Docker and Docker-compose,
In Ubuntu: `sudo apt-get install docker.io && sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose ` 
- Clone this repo
`git clone https://github.com/SweeXordious/Hadoop_Vagrant_Docker`
- Download 'hadoop-3.2.1.tar.gz' and put it in provision folder for both Master and Slave
- Run Docker compose build
`sudo docker-compose build`
- Run Docker compose
`sudo docker-compose up`

Wait for the containers to boot up and be provisioned, then in a new terminal:

`sudo docker-compose exec master bash`

`scp /root/.ssh/id_rsa.pub slave1:/root/.ssh/authorized_keys`

`scp /root/.ssh/id_rsa.pub slave2:/root/.ssh/authorized_keys`

`hadoop namenode -format`

Open /etc/hosts and remove the first master entery in it, then

`/usr/local/hadoop/sbin/start-all.sh`

Open http://172.20.10.4:9870 , http://172.20.10.4:8088 from your host to check if its working. Or use the command `jps` in all nodes to see which services are running.


# The resulting architecture:

![architecture](https://i.ibb.co/7nPsLCy/cluster-picture.png)


### Have Fun :D
