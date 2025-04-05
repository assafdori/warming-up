#!/bin/bash

eksctl delete cluster \
  --name acme-staging \
  --region eu-central-1
