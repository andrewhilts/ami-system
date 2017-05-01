# Access My Info System Environment

This project includes everything you need to start developing Access My Info (AMI) on your local computer and to deploy Access My Info onto servers.

AMI is a web application that helps people to create legal requests for copies of their personal information from data operators. AMI is a step-by-step wizard that results in the generation of a personalized formal letter requesting access to the information that an operator stores and utilizes about a person.

AMI is made up of three components. The AMI frontend javascript app ("AMI Frontend"), the Wordpress CMS powering the frontend's content ("AMI CMS"), and the node.js app that powers the email and stats tracking system ("AMI Community Tools").

## Developing on your local machine
This project is set up to use [Vagrant](https://www.vagrantup.com/) (a lightweight virtual machine environment manager) to control a virtual development environment ("Vagrant VM").

The Vagrant VM is configured using [Ansible](https://www.ansible.com/) (A configuration management system) playbooks.

This project includes a Vagrant file and Ansible playbooks to get a development environment for AMI up and runnin on your local computer. The development environment is a virtual machine that is set up identically to a virtual private server that you will eventually deploy AMI onto.

### Setting up an AMI virtual machine for development

Make sure you have the following prerequisites installed on your computer:

* [Vagrant](https://www.vagrantup.com/). Once installed, run these commands to install required plugins:
  * `vagrant plugin install vagrant-hostsupdater`
  * `vagrant plugin install vagrant-vbguest`
* [Ansible](https://www.ansible.com/)
* [Virtual Box](https://www.virtualbox.org/) (make sure it’s up-to-date)

**To get AMI running for the first time, run `firstrun.sh` then `vagrant up` in the project directory**

`firstrun.sh` creates security certificates used by your VM. You will have to provide some input to create the certificates.

`vagrant up` creates your VM. You  will be to provide your administrator password so that vagrant can edit your hosts file to set up the ami.local domain for your development version of AMI.

If `vagrant up` fails, run `vagrant provision` and try again. **This is alpha software: some debugging may be required.**

## Uninstall
If you wish to remove your AMI VM, run `vagrant destroy` in the project directory. Do not delete the VM in Virtualbox, as the changes to your hosts file will not be removed.

## More information
*  [Setup Details](https://github.com/andrewhilts/ami-system/blob/master/docs/setup.md) about what `firstrun.sh` creates and how to use the AMI VM
*  [Configuration details](https://github.com/andrewhilts/ami-system/blob/master/docs/config.md)
*  [The different AMI system components](https://github.com/andrewhilts/ami-system/blob/master/docs/components.md)
*  [Security](https://github.com/andrewhilts/ami-system/blob/master/docs/security.md)