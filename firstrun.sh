#!/bin/bash
echo "Installing vagrant plugins"
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-vbguest
echo "Creating shared folder `ami-code` for development"
mkdir ami-code
cd roles/wordpress-host/files/cert
echo "Creating SSL parameters and certificates"
bash generate_self_signed_cert.sh
bash generate_dh_param.sh
cp dhparam.pem ../../../ami-frontend/files/cert/
cp site* ../../../ami-frontend/files/cert/
cd ../../../../
echo "Creating vagrant machine"
vagrant up
