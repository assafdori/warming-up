#!/bin/bash

eksctl create cluster \
  --name acme-staging-07770 \
  --region eu-central-1 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
