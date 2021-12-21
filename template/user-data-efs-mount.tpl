#!/bin/bash -e

echo "start userdata mount efs"
mkdir /efs

#yum install -y amazon-efs-utils
#apt-get -y install amazon-efs-utils
#yum install -y nfs-utils
#apt-get -y install nfs-common
#apt-get update
#apt-get -y install git binutils
#git clone https://github.com/aws/efs-utils
#cd efs-utils
#./build-deb.sh
#sudo apt-get -y install ./build/amazon-efs-utils*deb
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_ip}:/ /efs
df -h
echo "stop userdata mount efs"