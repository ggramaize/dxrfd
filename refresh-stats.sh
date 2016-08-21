#!/bin/sh

CFG_PATH=/srv/dxrfd
XRF_HOME=/srv/dxrfd
# Fetch the admin user from the config file
XRF_ADMIN="$(grep ADMIN= $CFG_PATH/dxrfd.cfg | sed 's/ADMIN=//' | tr -dc 'A-Z0-9')"

# Fetch the name of the reflector
XRF_ID="$(grep OWNER= $CFG_PATH/dxrfd.cfg | sed 's/OWNER=//' | tr -dc 'A-Z0-9')"

# Grab the stats and push them in the web directory. We perform
# this operation in two steps because the page generation is quite slow.
/usr/bin/xrf_lh $XRF_ADMIN $XRF_ID "$XRF_ID" 127.0.0.1 > $XRF_HOME/www/status-tmp.html 2> /dev/null
rm -f $XRF_HOME/www/status.html
mv $XRF_HOME/www/status-tmp.html $XRF_HOME/www/status.html

# Display a failure page if the agent is not running
if [ -s $XRF_HOME/www/status.html ]; then 
	test -f $XRF_HOME/www/status.html && rm -f $XRF_HOME/www/status.html
	cat > $XRF_HOME/www/status.html <<EOF
<!DOCTYPE html>
<html>
 <head>
  <meta charset="UTF-8" />
  <title>dxrfd is not running</title>
 </head>
 <body>
  <h3>dxrfd is not running</h3>
  <p>The statistics module was unable to fetch valid data.</p>
  <p>If you're the reflector administrator, you should check your configuration.</p>
 </body>
</html>
EOF
fi

# Insert a refresh tag to update the page every 5 minutes
sed -i '/<\/head>/i<meta http-equiv="refresh" content="300">' $XRF_HOME/www/status.html
