#! /bin/bash

set -ex

sleep 5

#Join the default ECS cluster
echo ECS_CLUSTER=myapp >> /etc/ecs/ecs.config
PATH=$PATH:/usr/local/bin
#Instance should be added to an security group that allows HTTP outbound
yum -y update
yum -y install jq bind-utils amazon-efs-utils
#Install NFS client
if ! rpm -qa | grep -qw nfs-utils; then
    yum -y install nfs-utils
fi
if ! rpm -qa | grep -qw python27; then
	yum -y install python27
fi
#Install pip
yum -y install python27-pip
#Install awscli
pip install awscli
