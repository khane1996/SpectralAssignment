# SpectralAssignment


**This is a short assignment that was given as part as an interview for a compagny.
It is probably perfectly useless to anyone except the assignee and the reviewer.**
--------------------

## Chosen constraints 
As the assignment was fairly simple I added a couple constraints to make it more interresting both for the reviewer and myself. 
The main goal was to create an install system that would
- Be as foolproof as reasonably possible given the time constraint (four hours)
- Only require the execution of one command
- would work on most modern debian (10 or 11) or debian based operating system
- If reasonable would allow the user to revert the installation

On top of these constraints three scenarios were created with further added constraints:
- Scenario 0: The target computer is a certified server and nothing can be installed on it. Furthermore there is no root access to the computer. Actually should the install system be launched with PID 0, it should refuse to continue. But it does have Python3 pre-installed
- Scenario 1: The deployed service should be as efficient as reasonably possible given the time constraint
- Scenario 2: All installs should be done with Minikube. The target computer has a proper working Minikube, but it may not be connected to Internet.

The first two scenarios were quite easy to setup, but I must admit that I did not know Minikube at all, and the specific of routing inside Minikube got me scratching my head for a while. I wanted to spend a maximum of three hours on the technical part and tests to give me some time to write the documentation. It took me way too long to learn about the ` minikube service <name of service> --url ` command. I got stuck for a while trying to figure out how to properly route the entire cluster IP range. I ended up spending 190 minutes on the technical part.

## Results
The install system is quite simple as it consists of a simple script to launch.
As expected, only scenario 1 makes sense from a performance standpoint.
All three scenarios can be deployed on the same computer simultaneously

Git is needed to clone the present repository and access to the different install systems. But once cloned, the repository can be put on a usb key and moved to another computer if it cannot access Internet.
Scenario 1 is the only one that requires Internet access as it will try to install ACL and NGINX from the Internet using apt. While compiling NGINX statically and making it available from Git is easy, it is also long as it would have required three compilations (for Ubuntu based, for Debian 10 based and for Debian 11 based distributions). This would definitely have made the time spent on the assignment and on testing the results go way over four hours.

I elected not to use chef/puppet or any other pilot system (my preference goes to salt-stack in case you are wondering) as it hardly make sense in a single computer/single deployment type of scenario. If I had to, I would probably elect to use chef-solo/knife-solo as the tool for the job. 

## Instructions
First step is to clone the present repository:
> ` git clone https://github.com/khane1996/SpectralAssignment.git `

This will create a directory called **SpectralAssignment** under your current pwd location.

- **Scenario 0:** 
*Requirements: Bash, Python 3, unzip, port 9080 not used*

To install scenario 0 (no root, no install, python 3 http server) use the following command:
> ` ./SpectralAssignment/0.sh install ` 

Usage: the script will point you to http://127.0.0.1:9080 - you can access this URL with a local web browser to check the webpage.
This webpage is only visible from the localhost.
If you want to make the webpage visible from other client you will need to edit line 59 in 0.sh script and remove `--bind localhost`

You can exit the server with ctrl+c


To uninstall scenario 0 use:
> ` ./SpectralAssignment/0.sh clean `

- **Scenario 1:**
*requirements: Bash, unzip, root rights, access to the Internet

To install scenario 1 ( Host NGINX ) use the following command as root: 
> ` ./SpectralAssignment/1.sh install `

Usage: The script will backup current default NGINX website if it exist and replace it with the Spectral assignment page.
This will only work on standard NGINX installation that uses /var/www/html as their root folder for default installation. 
(Tested with vanilla Debian 11, Debian 10 and Linuxt Mint 20.3) 

The back is done in /var/www/html.old/html.x 
If the script is called multiple time, the value of x will increase.

There is no uninstaller for this script as it may do more harm than good in a real environment, or would take more than four hours and a fairly good nginx parser to work properly.

I am not using virtual websites as they behave very differently depending on whether you are using the official NGINX package or the package from Debian with sites-available/sites-enabled.

- **Scenario 2:**
*requirements: Bash, Docker, Minikube, bzip2

To install scenario 2 (Minikuba with three pods and a front service) user the following command as a Minikube user 
(generally it means you must be a member of the docker group)
> ` ./SpectralAssignment/2.sh `

Usage: the script will import and deploy everything automatically. It will then give you the uRL of the place you can go to see the webpage
The service port will be 32080

To uninstall scenario 2 use:
> ` ./SpectralAssignment/2.sh clean `

