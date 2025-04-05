#!/bin/bash

eksctl delete cluster \
  --name acme-staging-07770 \
  --region eu-central-1
