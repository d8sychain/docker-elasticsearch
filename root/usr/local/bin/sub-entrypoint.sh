# Add to /usr/local/bin/docker-entrypoint.sh line 7
## Run custom sub entrypoint script
# sub-entrypoint.sh
#

########################################################
## Start custom configuration setup for use on Unraid ##
########################################################
## Make folders
mkdir -p \
	/config/{data,logs,jvm.options.d}
chown -R elasticsearch:elasticsearch /config

## Copy config files
# elasticsearch config file elasticsearch.yml
[[ ! -f /config/elasticsearch.yml ]] && \
	cp /defaults/elasticsearch.yml /config/elasticsearch.yml && \
	chmod 666 /config/elasticsearch.yml && \
	echo 'default elasticsearch.yml copied'
# java config file jvm.options
[[ ! -f /config/jvm.options ]] && \
	cp /defaults/jvm.options /config/jvm.options && \
	chmod 666 /config/jvm.options && \
	echo 'default jvm.options copied'
# logging config file log4j2.properties
[[ ! -f /config/log4j2.properties ]] && \
	cp /defaults/log4j2.properties /config/log4j2.properties && \
	chmod 666 /config/log4j2.properties && \
	echo 'default log4j2.properties copied'

## Additional defaults
# cp -nR /defaults/ /config/
	
## Manage additional plugins
# Create my-plugins.txt if it doesn't exist
[[ ! -f /config/my-plugins.txt ]] && \
	cp /defaults/my-plugins.txt /config/my-plugins.txt && \
	chmod 666 /config/my-plugins.txt && \
	echo 'default my-plugins.txt copied'
cd /usr/share/elasticsearch/bin
# Remove plugins not in my-plugins.txt
installed_plugins=$(elasticsearch-plugin list)
remove_list=$(comm -13 --nocheck-order /config/my-plugins.txt <(echo $installed_plugins | tr -s [:space:] '\n'))
for plugin in $remove_list
	do
		elasticsearch-plugin remove $plugin
	done

# Add plugins not in $installed_plugins
installed_plugins=$(elasticsearch-plugin list)
add_list=$(comm -23 --nocheck-order /config/my-plugins.txt <(echo $installed_plugins | tr -s [:space:] '\n'))
# Enable batch mode explicitly, automatic confirmation of security permission
for plugin in $add_list
	do
		elasticsearch-plugin install --batch $plugin
	done
##############################
## End custom configuration ##
##############################