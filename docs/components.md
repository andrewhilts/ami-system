![AMI Architecture][ami-architecture]

## AMI Server Components and File Structure
AMI is made up of three components. The AMI frontend javascript app ("AMI Frontend"), the Wordpress CMS powering the frontend's content ("AMI CMS"), and the node.js app that powers the email and stats tracking system ("AMI Community Tools").

You can see each component in the virtual machine's /var/www folder (or whatever you set `{{webRoot}}` to in your `host_vars`):

* `ami-frontend-source`    #AMI Frontend AngularJS app
* `api`          #AMICMS Wordpress
* `ami-community`   #AMI Community Tools NodeJS app

AMI System uses NGINX to serve its component systems. Two NGINX hosts are configured, each with their own configuration files in `/etc/nginx/sites-available`.

**`{{frontEndHostname}}.conf`**  
`location /` serves from `/var/www/ami-frontend-source/prod`

**`{{apiHostname}}.conf`**  
`location /` serves Wordpress from `/var/www/api/public`  
`location /enrollment` proxy_passes to a node js server running from `/var/www/ami-community/app.js` as the `amicommunity` daemon.

NOTE: `{{apiHostname}}` should be set as a subdomain of `{{frontendHostname}}` in your `host_vars` file. For example: 

	frontendHostname=accessmyinfo.org
	apiHostname=api.accessmyinfo.org 

###Transport Encryption
By default, each host is set up to serve via SSL. The frontend host is set up to redirect from HTTP to HTTPS. The api host does not listen on port 80, only port 443 (HTTPS).

You will have to generate SSL certificates for each host. It's easy to use Let's Encrypt / Certbot to do this. Each host configuration has a `.well_known` folder that's served over port 80 and points to a folder called `/var/www/letsencrypt`. Set `/var/www/letsencrypt` as the webroot for your host in the certbot-auto webroot only command and it should generate your cert without much trouble.

### amicommunity service
`/etc/init/amicommunity.conf` sets up a service called `amicommunity` that runs a bash script (~/amicommunity.sh) to launch the amicommunity node js app located at `/var/www/ami-community/app.js`

#### uptime monitoring
The amicommunity service may stop if the underlying nodejs app crashes. To recover from a crash, we have a monit service running at `/etc/monit/conf.d/amicommunity` that simply sends a GET request to the amicommunity service served at `https://{{apiHostname}}/enrollment/verify` to check if the request returns 200 OK. If it fails, monit will restart the amicommunity service.

### amifrontend service
For development use only: `/etc/init/amifrontend.conf` sets up a service called `amicommunity` that runs a bash script (~/amifrontend.sh) to run `grunt serve` in at `/var/www/ami-frontend-source/`.

This service only gets setup if you set `amiFrontEndGruntServe` to true. Production servers will not need this, as AMI Frontend will be compiled into static, minified HTML, JS, and CSS.


#AMI Frontend
To serve the frontend for development, run `grunt serve` from within the ami-frontend folder.

To compile for production or deployment, run the `ami-frontend-build.yml` ansible playbook, pointing at your server (this builds the app on your live server, but won't overwrite the served directory unless the build completes successfully).

Environment variables for the frontend are initially defined in `roles/ami-frontend-dependencies/templates/prodConfig.conf.j2`, which inherits some values defined in your `host_vars` files.

Variables that can be set:

*  `apiDomain`: 			The domain from where amicms is served (which acts as an API for the frontend content)
*  `apiRoot`: 			If amicms is served from a subpath on the domain, specify it here
*  `apiPath`: 			The path relative to the root for the API endpoints. The value shouldn't be altered in normal cases
*  `enrollmentDomain`: 	The domain from where amicommunity is served (which acts as an API for the email and stats features)
*  `enrollmentApiPath`: 	The path relative to the domain for the amicommunity API endpoints. The value shouldn't be altered in normal cases. By default this path is set in nginx within the amicms location block, with a proxy_pass directing requests to the amicommunity nodejs express app. Thus apiDomain and enrollmentDomain usually are set to the same domain.
*  `jurisdictionID`: 	This ID corresponds to the AMICMS wordpress post ID associated with the default jurisdiction for which AMI will be centered upon
*  `languageCode`: 		The default language for the frontend.
*  `supportedLanguages` An array of languagecodes to support. Must include the default language.
*  `paperSize` The paper size for the PDF that AMI creates. Must be either letter, legal, or A4.

**For details about how the Frontend works, please see https://github.com/andrewhilts/ami**

# AMI CMS
Not much configuration for the AMI CMS needs to be done in Ansible, as it is a WordPress website and most configuration can be done through the admin interface. See the [AMI CMS user guide](https://github.com/andrewhilts/ami-system/blob/master/docs/amicms.md) for details on setting up the CMS for your jurisdiction (adding companies, data types, etc).

The customization that can be done relates primarily to the primary WordPress administrator password as well as the site administrator email address. These values can be set in `host_vars`:

	amicms_admin_user_password: yourpasswordhere
	amicms_admin_email: name@host.domain

Since Wordpress is restored from a database for ease of configuration, by default Ansible overwrites the admin password and email address to your host's settings, to prevent credentials from being improperly reused across hosts.

# AMI COMMUNITY
AMI Community Tools provides notification and statistical functionality to the overall AMI System.

**Please see https://github.com/andrewhilts/ami-community for details on how to create email templates, and how to create events that trigger emails being sent.**

Email subject lines should be configured in your `host_vars` file as an array called `amiCommunityLanguages`. For each supported language, three different subject lines should be defined. Those subject lines are: a default, one for verification emails, and one to confirm that the email address has been verified. This array also lets you define a custom logo filename so that you can have different logos for different languages.

Example configuration:

	amiCommunityLanguages:
	  - {
	      lang: "en", 
	      logoFileName: "AMICAFullLogoWhiteBackground.png",
	      systemEmailAddress:  "info@accessmyinfo.org",
	      defaultSubjectLine:  "A message from Access My Info",
	      verifySubjectLine:  "Confirm your request: Access My Info",
	      confirmSubjectLine:  "Request confirmed: Access My Info"
	    }
	  - {
	      lang: "fr",
	      logoFileName: "/images/ami-logo/AMICAFullLogoWhiteBackground-fr.png",
	      systemEmailAddress:  "info@accessmyinfo.org",
	      defaultSubjectLine:  "Message : Obtenir mes infos",
	      verifySubjectLine:  "Confirmez votre demande : Obtenir mes infos",
	      confirmSubjectLine:  "Demande confirmée : Obtenir mes infos"
	    }

Once the `ami-community-install` playbook is run (as part of the setup playbook or on its own), the `amiCommunityLanguages` configuration is hardcoded into the AMI Community Tools app, with each language config being saved as a separate file in the `conf/lang` directory.

[ami-architecture]: https://raw.githubusercontent.com/andrewhilts/ami-system/master/docs/AMI-architecture.png