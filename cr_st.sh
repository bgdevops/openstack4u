#!/bin/bash -xe
           export DOMAIN=bhaskar.openstack4u.com
           export USERNAME=openshift
           export PASSWORD=openshift
           cd /root/openstack4u
           ./install-openshift.sh
           oc create -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus3-template.yaml
           oc create -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus3-persistent-template.yaml
           cd /root
           git clone https://github.com/OpenShiftDemos/sonarqube-openshift-docker.git
           cd sonarqube-openshift-docker
           oc create -f sonarqube-postgresql-template.yaml
           cd /root/openstack4u
           oc new-project cicd --display-name="CI/CD"
           oc new-project dev --display-name="Task - DEV"
           oc new-project stage --display-name="Task - STAGE"
           oc policy add-role-to-user edit system:serviceaccount:cicd:default -n cicd
           oc policy add-role-to-user edit system:serviceaccount:cicd:default -n dev
           oc policy add-role-to-user edit system:serviceaccount:cicd:default -n stage
           oc project cicd
           oc process -f https://raw.githubusercontent.com/siamaksade/openshift-cd-demo/ocp-3.11/cicd-template.yaml | oc create -f -
