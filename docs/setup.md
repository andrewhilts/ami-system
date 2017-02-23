#AMI Setup details

It will take some time to set up the machine completely, as running `firstrun.sh` will execute `vagrant up`, which set up a new Vagrant VM and using Ansible, install all the applications required to serve AMI as well as AMI's source code through a process called [provisioning](https://www.vagrantup.com/docs/provisioning/). Both your local vagrant machine and a remote server that you deploy AMI to will both be provisioned using the same Ansible playbooks. See more on that in the provisioning section.

Once your virtual machine is set up, you should be able to SSH into it just like any server by running `vagrant ssh` from within the project directory.

For ease of development, `firstrun.sh` creates a folder called `ami-code` in the project directory. This folder is synced with the virtual machine's `/var/www` folder so that you can easily edit AMI code files in whatever editor you wish.

Next, back on your computer, visit `https://api.ami.local`. You will see a HTTPS error because it's using a self-signed certificate. You'll have to tell your browser to ignore this error. Do the same for `https://ami.local`. You now should be able to start using your development version of AMI!

> If you get a 502 Gateway Error visiting https://ami.local, wait a minute to make sure the server has started (the dev server is slow to start). If there's stil an error that means that the amifrontend service is not working. You'll have to run `vagrant ssh`, then run: `sudo service amifrontend start`, or failing that, manually run the server: `cd /var/www/ami-frontend-source; grunt serve` to start the server.