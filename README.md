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
- If reasonable would allow the user to rever the installation

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
First step is to clone the present repository 
