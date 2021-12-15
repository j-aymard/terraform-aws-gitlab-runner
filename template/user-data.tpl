#!/bin/bash -e
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

if [[ $(echo ${user_data_trace_log}) == false ]]; then
  set -x
fi

# Add current hostname to hosts file
tee /etc/hosts <<EOL
127.0.0.1   localhost localhost.localdomain $(hostname)
EOL

${eip}

for i in {1..7}; do
  echo "Attempt: ---- " $i
  yum -y update && break || sleep 60
done

echo "#!/bin/bash" >> /home/ec2-user/userdata.sh

echo "echo \"start userdata.sh\"" >> /home/ec2-user/userdata.sh
echo "mkdir /efs" >> /home/ec2-user/userdata.sh
#echo "apt-get update" >> /home/ec2-user/userdata.sh
#echo "apt-get -y install git binutils" >> /home/ec2-user/userdata.sh
#echo "git clone https://github.com/aws/efs-utils" >> /home/ec2-user/userdata.sh
#echo "cd efs-utils" >> /home/ec2-user/userdata.sh
#echo "./build-deb.sh" >> /home/ec2-user/userdata.sh
#echo "sudo apt-get -y install ./build/amazon-efs-utils*deb" >> /home/ec2-user/userdata.sh
echo "mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_ip}:/ /efs" >> /home/ec2-user/userdata.sh
echo "df -h" >> /home/ec2-user/userdata.sh
echo "echo \"stop userdata.sh\"" >> /home/ec2-user/userdata.sh

${logging}

${gitlab_runner}
