#!/bin/bash

#
# This is an absurdely clean yet very dirty solution
# The advantage is that it installs nothing
# I could not let myself show you an answer with just
# unzip and python3 -m http.server
# Also the background start and sleep infinity with trap INT 
# "may" not be necessary in a single process script.
#
# That said I had to do this kind of installs on server where
# installing new packages or seting up new services was strictly
# forbiden. So it is not as absurd as it looks.

stty -echoctl

MESSAGE="Stopping the server"

ctrl_c() {
        echo $MESSAGE
        MESSAGE=""
        kill $SERVER_PID       
}

# trap '' INT

if ! [ -z "$1" ]; then
if [ $1 == "clean" ]; then 
    SCRIPT_PATH=$(dirname "$0")
    cd $SCRIPT_PATH
    rm -rf "./v0"
    rm "spectral.html"
    rm "Spectral Devops Assignment.pdf"
    echo "\"Installation\" cleaned"
    exit 0
fi;fi;

if [ $1 == "install" ]; then
    SCRIPT_PATH=$(dirname "$0")
    cd $SCRIPT_PATH
fi;

USER_ID=$(id -u)
if (( $USER_ID == 0 )); then
    echo "please do not run as root"
    exit 1
fi;
if [ -f "./Spectral Assignment Devops.1648572416.zip" ]; then
	unzip "./Spectral Assignment Devops.1648572416.zip"
else
	echo "please run from the installation folder"
	exit 2
fi;
mkdir "./v0"
cp spectral.html ./v0/index.html
cd ./v0
# I do not test whether the port is available
# This is after all the quick and (not so) dirty solution
python3 -m http.server --bind localhost 9080 &
SERVER_PID="$!"
trap ctrl_c INT EXIT
echo "the file can be accessed from http://localhost:9080"
echo "use CTRL+C to stop the server"
sleep infinity
