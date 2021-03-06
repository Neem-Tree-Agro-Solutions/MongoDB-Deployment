#!/bin/sh
##
# Script to remove/undepoy all project resources from GKE & GCE.
##

# Delete mongod stateful set + mongodb service + secrets + host vm configuer daemonset
kubectl delete statefulsets mongo
kubectl delete services mongodb-service
kubectl delete secret shared-bootstrap-data
#kubectl delete daemonset hostvm-configurer
sleep 3

# Delete persistent volume claims
kubectl delete persistentvolumeclaims -l role=mongo
sleep 3

# Delete persistent volumes
for i in 1 2
do
    kubectl delete persistentvolumes data-volume-$i
done
sleep 20

# Delete GCE disks
for i in 1 2
do
    gcloud -q compute disks delete pd-ssd-disk-$i
done

#Delete whole Kubernetes cluster
gcloud -q container clusters delete "mongodb-cluster"

