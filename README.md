# d8sychain/docker-elasticsearch
**This Elasticsearch docker version is built from the official Elasticsearch docker with minimal changes tailoring it for easier use on Unraid and for the purpose for use with Nextcloud.**

Elasticsearch version is 7.10.2
## Installation
**Directions below MUST be used in order to get Elasticsearch 5 and above working correctly.**

**Directions:**
1. Install **CA User Scripts**
2. Create a new script named **vm.max_map_count**
3. Contents of script as follows:
```
#!/bin/bash
sysctl -w vm.max_map_count=262144
```
4. Set script schedule to **At Startup of Array**.
5. Add the docker container.

**If you are using this for Nextcloud then continue...**

*The **ingest-attachment** plugin is added by default at the 1st start of the container*

6. Browse to the Admin UI in Nextcloud and config according https://github.com/nextcloud/fulltextsearch/wiki/Basic-Installation.
7. Browse to the Unraid docker tab, click the nextcloud docker icon then **Console** or Open a SSH Terminal (like PuTTY) and login in to your Unraid server and bash into the container `docker exec -it nextcloud /bin/bash`.

*If you are using linuxserver.io's Nextcloud docker  the user is **abc** otherwise the default is **www-data** and the path to **occ** is ```/config/www/nextcloud/```*

8. Enter: 

	* nextcloud default ```sudo -u www-data php <path/to/nextcloud install>/occ fulltextsearch:index```

	* linuxserver.io nextcloud docker ```sudo -u abc php /config/www/nextcloud/occ fulltextsearch:index```
9. And wait... This can take a while depending on the number of files in your nextcloud server.
<br>
<br>
<br>

**The following is an excerpt from** https://github.com/nextcloud/fulltextsearch/wiki/Commands

**fulltextsearch:index**

This is the main command of the app, which is used to index your content. You will need to use this command to index your files at least once.

To start your first index:

`./occ fulltextsearch:index`
Options can be pushed using JSON:

user/users: user/array of users that will be indexed.

provider/providers: provider/array of providers that will be used to retrieve content of the Nextcloud.

path: location, can be a file or a folder. Used by the Files content provider only. Limit the index to the files from this location. If the file or folder does not exist, the index will be over.

paused: true/false. If set to true, index will start paused.

errors: reset Reset the errors

`./occ fulltextsearch:index "{\"user\": \"cult\", \"providers\":[\"files\", \"test\"]}"`

## Adding and removing plugins
In the docker volume host path, the default is `/mnt/user/appdata/elasticsearch` contains file `my-plugins.txt`

Edit this file, adding and/or removing needed plugins, and then restart the container.

A built-in script will check this file at container start and compare it to the currently installed plugins and install and/or remove plugins accordingly.
