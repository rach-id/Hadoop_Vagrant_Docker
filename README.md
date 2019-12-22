# Hadoop_Vagrant
This repo will contain a Vagrantfile + config files to run a hadoop cluster of one master and 2 slaves

# How to
- Install Vagrant and virtualbox,
In Ubuntu: `sudo apt-get install vagrant virtualbox`
- Clone this repo
`git clone https://github.com/SweeXordious/Hadoop_Vagrant`
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


# The resulting architecture:

![architecture](https://i.ibb.co/7nPsLCy/cluster-picture.png)

### Have Fun :D
