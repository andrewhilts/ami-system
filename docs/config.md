
## Provisioning an AMI Server
AMI servers, whether locally-running Vagrant VMs or production virtual private servers, can be easily configured using the Ansible playbooks included in this project. [Ansible](https://www.ansible.com/) is a server automation tool that makes it really simple to perform standardized configuration across different environments. The Ansible settings and playbooks for the AMI project are as follows:

###group_vars
The `all` file in `group_vars` contains the same variables as `host_vars` (see below), but will be used if pointing ansible to a host without a `host_vars` file, or the variable will be used if a specific variable is missing from a `host_vars` file.

**USE `group_vars/all` FOR YOUR LOCAL VAGRANT VM**

Once you set up your group_vars, re-run `vagrant provision` to get the changes reflected in your AMI VM.

###Host-specific variables: 
Each host on which you wish to deploy AMI can have a separate file that defines variables specific to that host (eg hostname). The host file name should be named identically as a host that is defined in your /etc/ansible/hosts file. So, if you have a host `ami_test` defined in /etc/ansible/hosts, then you'd create file called `ami_test` in your host_vars folder. More info: http://docs.ansible.com/ansible/intro_inventory.html#

I recommend creating your host files using ansible-vault. That way you can store each environment's sudo password and other database passwords in an encrypted environment. More info: http://docs.ansible.com/ansible/playbooks_vault.html

The host variables are as follows (See [`group_vars/all`](https://github.com/andrewhilts/ami-system/blob/master/group_vars/all) for defaults):

####General
* `ansible_sudo_pass`: The sudo password for your host machine
* `unix_user`: The user name for your host machine

####Hostnames and server details
* `frontEndHostname`: The hostname from where the AMI Frontend is served
* `apiHostname`: The hostname from where the AMI API is served
* `enrollmentHostname`:  The hostname from where the AMI API is served (should be same as apiHostname)
* `default_protocol`: Should be set to https
* `webRoot`: The system path in which all AMI components will be installed (set to `/var/www` to avoid bugs)
* `amiFrontEndGruntServe`: Whether or not to set up nginx to serve a compiled frontend (false), or to proxy_pass to a grunt server running on localhost:9000 (true)

####Database (AMICMS MySQL)
* `mysql_root_pass`: Root password for the AMI API mysql database
* `wpdb_user`: username for the ami api's database authorized user
* `wpdb_name`: database name for the AMI API mysql db
* `wpdb_host`: host serving the wpdb (probably localhost)
* `wpdb_pass`: password for the wpdb_user

####Database (AMICommunity PostGres)
* `ami_community_dbname`: name of database for the amicommunity postgres db
* `ami_community_dbuser`: authorized user for the amicommunity postgres db
* `ami_community_dbpassword`: password for the amicommunity db authorized user.

####Install paths relative to webRoot
* `amiLocalPath`: the folder in which the AMI Frontend is installed
* `apiLocalPath`: the folder in which the AMI CMS is instaled
* `amiCommunityLocalPath`: the folder in which AMI Community Tools is installed

####Git Repos
The repos used for each AMI server component. You should fork these repos (at least AMI Community Tools and AMI Frontend) and change the variable values accordingly.

#####AMI Community Tools
* `amiCommunityRepo`: https://github.com/andrewhilts/ami-community.git
* `amiCommunityBranch`: master

#####AMI CMS API
* `amiAPIPluginRepo`: https://github.com/andrewhilts/ami-api
* `amiAPIPluginBranch`: master

#####AMI Frontend
* `amiFrontEndRepo`: https://github.com/andrewhilts/ami.git
* `amiFrontEndBranch`: canada

####AMI Frontend Settings
* `amiFrontEndJurisdiction`: The ID for the Wordpress post that corresponds to the jurisdiction you'll use for your deployment. Set to 18 for Canada to start with.
* `amiFrontEndLang`: the 2-letter ISO code for the language you want the UI to default to.
* `amiFrontEndSupportedLangs`: a YAML list of the 2-letter ISO code for the language you want the UI to support
* `amiFrontEndPaperSize`: the paper size that of the PDF that the AMI Frontend generates. Can be letter, legal, or A4.

####AMI CMS Settings
* `amicms_admin_user_password`: By default, the AMI CMS has one user called accessmyadmin. Set its password here.
* `amicms_admin_email`: The email of the wordpress site admin (Probably you)

####AMI Community Settings
* `node_version`: The version of node.js to use in the project (default 5.10.1)
* `sendgridAPIKey`: API key for sendgrid to send out automated emails
* `amiLogoFileName`: The filename for the default AMI logo to use in emails. The file will be located in your AMI Frontend project, in the `/images/ami-logo` folder.
* `amiCommunityLanguages`: A YAML list of objects to denote language-specific settings for sent emails. Each language object includes:
  * `lang`: The 2-letter ISO code for the language
  * `systemEmailAddress`: The email address that emails will be "from"
  * `defaultSubjectLine`: The subject line for emails unless overriden
  * `verifySubjectLine`: The subject line for email verification emails
  * `confirmSubjectLine`: The subject line for emails letting user know they're verified

### Playbooks
Playbooks are the primary method of controlling AMI servers. This project includes playbooks for the most common tasks that one encounters when developing and maintaining an AMI server.

* `ami-community-install.yml`  Checks out the ami-community code from github, sets up a NVM, copies over configuration files, installs node.js plugins, initiates the amicommunity service.
* `ami-community.yml` installs, backs up, and restores the Postgres database used by the ami-community node.js application.
* `ami-frontend-update.yml` Checks out a new copy of AMI Frontend set to the branch defined in `host_vars` and compiles the ami-frontend to compressed HTML and JS ready to serve as a static frontend.
* `ami-frontend.yml` Installs and compiles the AMI Frontend for the first time
* `amicms.yml`  Installs and compiles the AMI CMS for the first time (sets up wordpress with custom plugins)
* `backup.yml` Backs up the AMI CMS and AMI Community databases, and backs up the AMI CMS wordpress file uploads.
* `common.yml` Installs basic server applications
* `restore.yml` Restores the AMI CMS and AMI Community databases, and restores the AMI CMS wordpress file uploads. Restore files are hardcoded and meant to be run after running the `backup` playbook.
* `setup.yml` Runs all the install playbooks needed to get an AMI server up and running for the first time.

### Roles
Roles outline specific series of tasks that can be incorporates into the playbooks.

* `ami-community-db` installs, backs up, and restores the Postgres database used by the ami-community node.js application.
* `ami-community-install` Checks out the ami-community code from github, sets up a NVM, copies over configuration files, installs node.js plugins, initiates the amicommunity service.
* `ami-frontend` Copies over dev SSL services, clone the AMI source set to the branch listed in your `host_vars` sets up NGINX site profile for ami-frontend
* `ami-frontend-build` Compile the ami-frontend to compressed HTML and JS ready to serve as a static frontend.
* `ami-frontend-dependencies` Install the dependencies like NVM, grunt and the node plugins required to compile the frontend.
* `amicms` Install custom plugins for the AMICMS wordpress website
* `amicms-db` installs, backs up, and restores the MySQL database used by the AMICMS Wordpress application.
* `amicms-files` backs up and restores the wordpress uploads folder for the AMICMS Wordpress application.
* `ansible-nvm` installs nvm
* `common` installs some basic apps for a server: screen, lynx, fail2ban, tree, ack-grep, monit 
* `mysql` installs mysql
* `php5-fpm` installs php5-fpm for use with NGINX
* `postgres` installs postgres
* `varnish` installs varnish
* `wordpress-host` installs nginx and wp-cli, sets up an nginx host and creates a webroot folder for that host, then installs wordpress in that directory. Used by AMICMS.

## Deploying AMI on a server
This section will walk you through how to use Ansible to configure and maintain an AMI server.

### Initial setup
Spin up a new VPS running Ubuntu 14.04.

On your local machine, make sure you have Ansible installed. Edit your `/etc/ansible/hosts` file to set up a record for your VPS. For more information: http://docs.ansible.com/ansible/intro_inventory.html#hosts-and-groups

Next, inside `host_vars`, create a file (using Ansible Vault) with the name you gave your host in `/etc/ansible/hosts`. Specify all the variables that you wish to overwrite from the `groups_vars/all` file. Certainly, you'll want to set up your passwords and hostnames.

For example, let's say your VPS has IP address `6.6.6.6`, with the hostname `accessmyinfo.ninja` and with username `server`:

**`nano /etc/ansible/hosts`**

	[production]
	ami_test ansible_host=6.6.6.6 ansible_user=server ansible_connection=ssh

**`ansible-vault create host_vars/ami_test`**

	---
	ansible_sudo_pass: 2bqFpoNNygLvwrEg8ndMUy6DpeiLNZh3QpvKZLH7nmFa
	unix_user: server
	frontEndHostname: accessmyinfo.ninja
	apiHostname: api.accessmyinfo.ninja
	enrollmentHostname: api.accessmyinfo.ninja
	[...]

> You can also create an entry in your `/etc/ansible/hosts` file for your vagrant development machine. This will enable you to easily run specific playbooks against the vagrant box. eg:

>	`amivagrant ansible_host=10.11.12.15 ansible_ssh_user='vagrant' ansible_ssh_private_key_file='~/..../ami-system/.vagrant/machines/default/virtualbox/private_key'`

With these parameters specified, you can move on to your first deployment of the AMI system.

### First deployment
**Note: This section continues with the example from the previous section**

To set up your server for the first time, make sure you have it specificed in `/etc/ansible/hosts` and have your `host_vars` set up (see previous section).

Next, in the AMI System project root, we will run one command to spin up AMI on the `ami_test` remote host.

	ansible-playbook -i "ami_test," setup.yml --ask-vault-pass

Your terminal should start hammering through all the roles that were described above, installing software, setting up databases, copying over environment-specific settings, setting up NGINX, etc.

> **Note:** A common issue is for the setup to fail on `install node plugins` stage. This is because Node.js is greedy and uses up all available memory, and will often cause VPS with small amounts of RAM to choke. To remedy this, the `common` playbook installs 4G of swap space, but if setup fails, add more swap space to the server, and try running the setup playbook again.

Once the playbook runs through completely, you should have a functioning AMI System! The only thing to fix should be to configure SSL appropriately.

### Updates
If you make updates to source code in `ami-code/ami-community` or `ami-code/ami-frontend-source`, you can commit and push your changes to the respective repositories' origin (You'll probably want to fork the code to your own remote repo), and then run the AMI update playbooks to get remote servers running the latest code. These playbooks take into account compiling, service restarts and other issues that would otherwise have to be done manually get a live system running up-to-date code.

To update a remote server's AMI System, run one or both of the folowing commands from the project root (where `ami_test` is the name of your remote host defined in `/etc/ansible/hosts` and has host-specific variables in `host_vars/`):

**To update the frontend**

	ansible-playbook -i "ami_test," ami-frontened-update.yml --ask-vault-pass

**To update the amicommunity nodejs service**

	ansible-playbook -i "ami_test," ami-community-update.yml --ask-vault-pass

### Backup / Restore
The backup playbook does the following things:

*  Does a mysqldump of the AMI CMS database on the host, saving the dump into `roles/amicms-db/files`
*  Creates an archive of the AMI CMS Wordpress uploads folder on the host and saves the archive into `roles/amicms-files/files/`
*  Dumps the AMI Community Postgres database, saving the dump into `roles/ami-community-db/files`

The restore playbook does the opposite things:

*  Copies the backup mysqldump from `roles/amicms-db/files` and restores it to the host machine's AMI CMS database.
*  Overwrites the admin user (ID 6) password and email address with the values you provided in `amicms_admin_user_password` and `amicms_admin_email`
*  Copies the archive of the AMI CMS Wordpress uploads folder from `roles/amicms-files/files/` and replaces the uploads folder on the host machine with it.
*  Copies the backup postgres dump of the AMI Community database from `roles/ami-community-db/files` and restores it to the host machine.

So, let's say you wanted to back up your production server `ami_prod`, and restore it to your dev server `ami_dev`. In the project root, run:

	ansible-playbook -i "ami_prod," backup.yml --ask-vault-pass
	ansible-playbook -i "ami_dev," restore.yml --ask-vault-pass