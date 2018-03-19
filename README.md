# phpVirtualbox

Install and configure VirtualBox + phpVirtualbox

### Requirements:  
1. [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

### Install vitualbox:
```bash 
sudo add-apt-repository \
   "http://download.virtualbox.org/virtualbox/debian \
   $(lsb_release -cs) \
   contrib"
wget https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
sudo apt update
sudo apt install virtualbox-5.2
```

### Create vbox user and configure vboxweb service:
```bash
sudo useradd -d /home/vbox -m -g vboxusers -s /bin/bash vbox
echo 'VBOXWEB_USER=vbox' | sudo tee -a /etc/default/virtualbox
echo 'VBOXWEB_HOST=127.0.0.1' | sudo tee -a /etc/default/virtualbox
sudo systemctl enable vboxweb-service
sudo systemctl start vboxweb-service
```

### Setup `vbox` user password:
```bash
passwd vbox
```

### Configure phpVitualbox:
```bash
sudo mkdir /opt/phpvirtualbox/
wget --no-check-certificate https://raw.githubusercontent.com/zensoftdevops/phpVirtualbox/master/config.php -o /opt/phpvirtualbox/config.php
```
Set `vbox` user password in `/opt/phpvirtualbox/config.php` file:
>..
>/* Username / Password for system user that runs VirtualBox */  
>var $username = 'vbox';  
>var $password = 'vbox_user_password';  
>..

### Start phpVirtualbox docker container:
```bash
/usr/bin/docker run \
    --rm \
    --name %n \
    --memory 64m \
    --net host \
    --publish 80:80 \
    --volume /opt/phpvirtualbox/config.php:/var/www/config.php \
    zensoftdevops/phpvirtualbox
```