#!/bin/bash

#### COLOR SETTINGS ####
black=$(tput setaf 0 && tput bold)
red=$(tput setaf 1 && tput bold)
green=$(tput setaf 2 && tput bold)
yellow=$(tput setaf 3 && tput bold)
blue=$(tput setaf 4 && tput bold)
magenta=$(tput setaf 5 && tput bold)
cyan=$(tput setaf 6 && tput bold)
white=$(tput setaf 7 && tput bold)
blackbg=$(tput setab 0 && tput bold)
redbg=$(tput setab 1 && tput bold)
greenbg=$(tput setab 2 && tput bold)
yellowbg=$(tput setab 3 && tput bold)
bluebg=$(tput setab 4 && tput dim)
magentabg=$(tput setab 5 && tput bold)
cyanbg=$(tput setab 6 && tput bold)
whitebg=$(tput setab 7 && tput bold)
stand=$(tput sgr0)

### System dialog VARS
showinfo="$green[info]$stand"
showerror="$red[error]$stand"
showexecute="$yellow[running]$stand"
showok="$magenta[OK]$stand"
showdone="$blue[DONE]$stand"
showinput="$cyan[input]$stand"
showwarning="$red[warning]$stand"
showremove="$green[removing]$stand"
shownone="$magenta[none]$stand"
redhashtag="$redbg$white#$stand"
abortte="$cyan[abort to Exit]$stand"
showport="$yellow[PORT]$stand"
##

### GENERAL VARS
getgit=$(if cat /etc/*release | grep -q -o -m 1 Ubuntu; then echo "$(apt-cache policy git | grep Installed | grep none | awk '{print$2}' | sed s'/[()]//g')"; elif cat /etc/*release | grep -q -o -m 1 Debian; then echo "$(apt-cache policy git | grep Installed | grep none | awk '{print$2} | sed s'/[()]//g'')"; elif cat /etc/*release | grep -q -o -m 1 centos; then echo "$(if yum list git | grep -q -o "Available Packages"; then echo "none"; else echo "Installed"; fi)"; fi)
###

#### Dependencies START
function deps(){
if [[ "$getgit" == "(none)" ]]; then
	echo "$showinfo We need to install Git"
	if [[ $(cat /etc/*release | grep -q -o -m 1 Ubuntu) ]]; then sudo apt install -y git; elif cat /etc/*release | grep -q -o -m 1 Debian; then sudo apt-get install -y git; elif cat /etc/*release | grep -q -o -m 1 centos; then yum install -y git; fi
else
	if [[ "$getgit" == Installed ]]; then
		echo "$showok Git is already installed!"
	else
		if [[ "$getgit" == * ]]; then
			echo "$showok Git is already installed!"
		fi
	fi
fi
}
#### Dependencies check END

deps # call deps function

if [[ $(cat package.json | grep "name" | sed s'/[",]//g' | awk '{print $2}') == node-webdollar ]]; then
	echo "$showinfo Current dir is $yellow$(pwd)$stand"

	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then sudo apt update -y; elif cat /etc/*release | grep -q -o -m 1 Debian; then sudo apt-get update -y; elif cat /etc/*release | grep -q -o -m 1 centos; then sudo yum update -y; fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then sudo apt upgrade -y; elif cat /etc/*release | grep -q -o -m 1 Debian; then sudo apt-get upgrade -y; elif cat /etc/*release | grep -q -o -m 1 centos; then sudo yum upgrade -y; fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then sudo apt install -y linuxbrew-wrapper; elif cat /etc/*release | grep -q -o -m 1 Debian; then sudo apt-get install -y linuxbrew-wrapper; fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then sudo apt install -y build-essential; elif cat /etc/*release | grep -q -o -m 1 Debian; then sudo apt-get install -y build-essential; elif cat /etc/*release | grep -q -o -m 1 centos; then sudo yum group install -y "Development Tools"; fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then sudo apt install -y clang; elif cat /etc/*release | grep -q -o -m 1 Debian; then sudo apt-get install -y clang; elif cat /etc/*release | grep -q -o -m 1 centos; then sudo yum install -y clang; fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then if [[ -d $HOME/.nvm ]]; then echo "$showok NVM is already installed!"; elif [[ ! -d $HOME/.nvm ]]; then curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && source ~/.profile && nvm install 8.2.1 && nvm use 8.2.1 && nvm alias default 8.2.1; fi \
	elif cat /etc/*release | grep -q -o -m 1 Debian; then if [[ -d $HOME/.nvm ]]; then echo "$showok NVM is already installed!"; elif [[ ! -d $HOME/.nvm ]]; then curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && source ~/.profile && nvm install 8.2.1 && nvm use 8.2.1 && nvm alias default 8.2.1; fi \
	elif cat /etc/*release | grep -q -o -m 1 centos; then if [[ -d $HOME/.nvm ]]; then echo "$showok NVM is already installed!"; elif [[ ! -d $HOME/.nvm ]]; then curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && source ~/.bash_profile && nvm install 8.2.1 && nvm use 8.2.1 && nvm alias default 8.2.1; fi fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then npm install -g node-gyp; elif cat /etc/*release | grep -q -o -m 1 Debian; then npm install -g node-gyp; elif cat /etc/*release | grep -q -o -m 1 centos; then npm install -g node-gyp; fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then npm install pm2 -g --unsafe-perm; elif cat /etc/*release | grep -q -o -m 1 Debian; then npm install pm2 -g --unsafe-perm; elif cat /etc/*release | grep -q -o -m 1 centos; then npm install pm2 -g --unsafe-perm ; fi
	echo "$showexecute Running npm install..." && npm install
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then if [[ $(node --version) ]]; then echo "$showok NVM sourced ok..."; else echo "$showinfo ${red}MANDATORY$stand: execute ${yellow}source ~/.profile$stand"; fi elif cat /etc/*release | grep -q -o -m 1 Debian; then if [[ $(node --version) ]]; then echo "$showok NVM sourced ok..."; else echo "$showinfo ${red}MANDATORY$stand: execute ${yellow}source ~/.profile$stand"; fi elif cat /etc/*release | grep -q -o -m 1 centos; then if [[ $(node --version) ]]; then echo "$showok NVM sourced ok..."; else echo "$showinfo ${red}MANDATORY$stand: execute ${yellow}source ~/.bash_profile$stand"; fi fi
	if cat /etc/*release | grep -q -o -m 1 Ubuntu; then echo "$showinfo Run ${red}source ~/.profile$stand before stating miner."; elif cat /etc/*release | grep -q -o -m 1 Debian; then echo "$showinfo Run ${red}source ~/.profile$stand before starting miner."; elif cat /etc/*release | grep -q -o -m 1 centos; then echo "$showinfo Run ${red}source ~/.bash_profile$stand before starting miner."; fi
	echo "$showinfo You can now start your miner using: ${yellow}npm run commands$stand or ${yellow}SERVER_PORT=your_port npm run commands$stand (using custom port)"
	echo "$showinfo You should copy and unzip the blockchainDB3 backup to start SOLO mining instantly!"
	echo "$showinfo You can also start mining instantly in a POOL by entering: 10 and the POOL link."
else
	echo "$showerror You are not inside the Node-WebDollar folder."
	echo "$showinfo To install your miner, use this script inside the Node-WebDollar folder."
fi
