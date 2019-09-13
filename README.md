# Simple Go App deployment on ECS cluster

## Overview

Launches an ECS cluster and simple Golang container app behind an ALB. Container image is pulled from ECR. Note that application takes several minutes to initialize after Terraform completes. See output for URL to ALB.

## Prereqs & Dependencies

Create SSH keys in the keys directory

```sh
ssh-keygen -t rsa -f ./keys/mykey -N ""
```

Container repo 'go-outyet' must exist in AWS ECR in the region you're deploying into.

Go-outyet source can be found here https://github.com/bkc1/go-outyet

