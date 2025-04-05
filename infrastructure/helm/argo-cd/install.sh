#! /bin/bash

kubectl create namespace argocd

helm install argocd --namespace argocd .
