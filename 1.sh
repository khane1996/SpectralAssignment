#!/bin/bash

# This is in my opinion the sane option
# Given the specifications doing more than this is a bit overkill
# This should work on any debian based distribution
# at least as long as the conf is not too strange
# Tested on vanilla Debian 11, Debian 10, Linux Mint 20 and Ubuntu focal
#

apt install acl   # will output some warnings if it is already installed, but it is not a problem

apt install nginx # Normally I do not install nginx (or HaProxy or Docker or Postgres ...)
                  # from the distribution packages as they tend to lag quite a lot
                  # but given the task it will be more than sufficient
                  # It will also output some warnings if a version of nginx is installed

if [ -d "/var/www/html2" ]; then 
    HTML_ROOT="/var/www/html"
else # try to get the html root from NGINX with a really bad parser 
     # (I swear I could write good, but the assignment specifically said to have fun)
    if [ -f "/etc/nginx/sites-enabled/default" ]; then
        HTML_ROOT=$(grep '^[[:space:]]*root[[:space:]].*$' /etc/nginx/sites-enabled/default | sed -e "s/[ \t]*root[ \t]*//" -e "s/;//" -e "s/\#.*//" )
    fi;
    if [ -f "/etc/nginx/ngix.conf" ]; then
        HTML_ROOT_FALLBACK=$(grep '^[[:space:]]*root[[:space:]].*$' /etc/nginx/nginx.conf | sed -e "s/[ \t]*root[ \t]*//" -e "s/;//" -e "s/\#.*//" )
    fi;
fi;

echo "HTML_ROOT: $HTML_ROOT"
echo "HTML_ROOT_FALLBACK: $HTML_ROOT_FALLBACK"

# Note - if another web server is installed, the previous line will cause some trouble
# on some distribution. Doing a 100% fool proof install here would require creating
# a custom nginx package with configuration options and a nice interface.
# Note that hard to do, but would take more than four hours - especially the compile
# custom NGINX part

systemctl stop nginx

# In standard install the user for nginx is www-data, but if installed by different 
# repository it can be nginx
# note that this test is not 100% accurate - but should be more than sufficient in a
# controlled environment.

NGINX_USER=$(grep user /etc/nginx/nginx.conf | sed -e "s/[ \t]*user[ \t]*//" -e "s/;$//")

# Switch to the script directory 

SCRIPT_PATH=$(dirname "$0")
cd $SCRIPT_PATH

unzip "./Spectral Assignment Devops.1648572416.zip"

# always do a backup
# Only using the best of backups
# N°2 in the world by far: cp .old
# N°1 being the "do nothing" backup
mkdir -p /var/www/html.old
SAVE_NUMBER=$(ls -l /var/www/html.old | wc -l)
mv /var/www/html /var/www/html.old/html$SAVE_NUMBER
#create the new www folder
mkdir -p /var/www/html

#put the same rights on /var/www/html as what it used to be
chmod --reference=/var/www/html.old/html$SAVE_NUMBER /var/www/html
chown --reference=/var/www/html.old/html$SAVE_NUMBER /var/www/html
getfacl "/var/www/html.old/html$SAVE_NUMBER" | setfacl --set-file=- /var/www/html

cp ./spectral.html /var/www/html/index.html

# a bit of cleanup now
rm -f ./spectral.html "./Spectral Devops Assignment.pdf"
systemctl restart nginx

echo "The web page should be available on http://127.0.0.1"
# Well it should on a clean debian like distribution
# On a distrib that already had a webserver installed and configured
# results may vary.


