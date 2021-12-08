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

echo "#!/bin/bash \
mkdir /efs  \
apt-get update  \
apt-get -y install git binutils  \
git clone https://github.com/aws/efs-utils \
cd efs-utils \
./build-deb.sh \
sudo apt-get -y install ./build/amazon-efs-utils*deb \
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_id}.efs.${aws_region}.amazonaws.com:/ /efs
" > /home/ec2-user/userdata.sh

${logging}

${gitlab_runner}
