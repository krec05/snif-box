# Building a vagrant box from start to finish with VirtualBox
The goal of Vagrant is to make it so simple to create a local development environment, you’d never 
want to do it another way again. With two simple commands you can quickly setup your first vagrant 
environment and with a third command, be connected into your first vagrant box in under a few 
minutes.

If you’re already a fan of Vagrant, I’m probably preaching to the choir. For more about what Vagrant 
can do check out the amazing [documentation](https://www.vagrantup.com/docs). Or pick up the 
O’Reilly book by Vagrant’s author, Mitchell Hashimoto, 
[Vagrant: Up and Running](https://www.oreilly.com/library/view/vagrant-up-and/9781449336103/) and 
read it. It’s a short but jam packed review of the details you need to get to know Vagrant, inside 
and out.

## Why Build A Box?
There are a bunch of amazing boxes out there available on sites like 
[vagrantcloud.com](https://app.vagrantup.com/boxes/search) so why would you want to build your own 
box?

Maybe you want to add a few extra things to your base (a runtime or two like Julia, Erlang, JVM or 
Python, etc.) then start this as your new “base”.

Maybe you want your box to have more ram or you need your boxes to more closely mirror production 
and you are building a ram enriched, multiple server cluster with multiple provisioners, we get it… 
you’ve got a mountain to climb, you just need your gear.

## Definitions
What is a package.box file? When using the VirtualBox provider? It’s a tarred, gzip file containing 
the following:
* ```Vagrantfile```
* ```box-disk.vmdk```
* ```box.ovf```
* ```metadata.json```

The ```Vagrantfile``` has some information that will be merged into your ```Vagrantfile``` that is 
created when you run ```vagrant init <boxname>``` in a folder.

The ```box-disk.vmdk``` is the virtual hard disk drive.

The ```box.ovf``` defines the virtual hardware for the box.

The ```metadata.json``` tells vagrant what provider the box works with.

_**NOTE: These contents would be different for the VMWare provider, etc. For more about that please 
refer to the vagrant [docs on boxes](https://www.vagrantup.com/docs/providers/vmware/boxes.html).**_

## Getting Prepared
If you don’t already have Vagrant and VirtualBox, grab those.
* [Download Vagrant](https://www.vagrantup.com/downloads.html) installer for your operating system.
* [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) installer for your operating system.

_**NOTE: Grab the VirtualBox Extension Pack as well.**_

## Build a Box
We’re going to use VirtualBox to build an ubuntu server from scratch. The reason for this is because 
Vagrant has native support for VirtualBox. There are more plugins out there for other providers like 
VMWare, Parallels or Vagrant-LXC, etc. We’ll stick to VirtualBox for this guide.

When we setup our ubuntu server, it prompts us to setup a default user. We’re going to name that user 
vagrant so it’s the default user as well. This will make it the default SSH user and streamline the 
process.

#### Configure the Virtual Hardware
Create a new Virtual Machine with the following settings:
* Name: vagrant-ubuntu64
* Type: Linux
* Version: Ubuntu64
* Memory Size: >4096MB
* New Virtual Disk: [Type: VMDK, Size: 40 GB]

Modify the hardware settings of the virtual machine for performance and because SSH needs 
port-forwarding enabled for the vagrant user:
* Disable audio
* Disable USB
* Ensure Network Adapter 1 is set to NAT
* Add this port-forwarding rule: [Name: SSH, Protocol: TCP, Host IP: blank, Host Port: 2222, Guest IP: blank, Guest Port: 22]
    * You found this in Network Adapter > Expand > Port Forwarding 

Mount the Linux Distro ISO and boot up the server.

#### Install The Operating System
Setting up ubuntu is very simple. Follow the on-screen prompts. And when prompted to setup a user, 
set the __**user to vagrant**__ and the __**password to vagrant**__. It will give you a passive-aggressive guilt 
trip about it being a weak sauce password. Don’t let that shake you, be strong and soldier through.

#### Set Root Password
In order to setup the Super User, aka root user, you’ll need to be able to sign in as that user. Since I asked you to make vagrant the default user while installing the Operating System in the last step, these commands should help you set the root password and then sign in as root in order to make the next configuration changes below.

sudo passwd root

This will prompt you to type the password twice, where I’d suggest the password “vagrant”. Now sign in as the root user in order to Setup the Super User next.

su -

#### Setup the Super User

Vagrant must be able run ```sudo``` commands without a password prompt and if you’re not configuring 
ubuntu at this point, just make sure that requiretty is disabled for the vagrant user.

The most efficient way I’ve found to setup the vagrant user so it’s able to use sudo without being 
prompted for a password is to add it to the sudoers list like this:
```
sudo visudo -f /etc/sudoers.d/vagrant
```
Anything in the ```/etc/sudoers.d/*``` folder is included in the “sudoers” privileges when created 
by the root user. So that’s why we created this as the root user and in that folder.

With that file open add this to the file then save it and exit.
```
# add vagrant user
vagrant ALL=(ALL) NOPASSWD:ALL
```
Now you can test that it works by running a simple command:
```
sudo pwd
```
It will return the home folder without prompting you for a password if everything is setup 
correctly. If you are prompted for a password, something’s out of wack and things won’t work right. 

#### Updating The Operating System
One of the reasons we are building this box is so we can save time by already being as up to date 
as the box was built. So let’s get up-to-date first.
```
sudo apt-get update -y
sudo apt-get upgrade -y
```
Usually if there are kernel updates you’ll want to reboot the server. So do that.
```
sudo shutdown -r now
```

#### Install the Vagrant Key
The only way that all the vagrant commands will be able to communicate over ssh from the host 
machine to the guest server is if the guest server has this “insecure vagrant key” installed. It’s 
called “insecure” because essentially everyone has this same key and anyone can hack into everyone’s 
vagrant box if you use it.

But at the same time, we’re hoping you’re not running around with all your most valuable company 
data on your vagrant boxes, right? RIGHT? OK. Good.
```
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
wget --no-check-certificate \
    https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
```

#### Install and Configure OpenSSH Server
If you didn’t install SSH while installing the operating system you can do it now: 
```
sudo apt-get install -y openssh-server
```
We need to edit the ```/etc/ssh/sshd_config``` file:
```
sudo nano /etc/ssh/sshd_config
```
Find and uncomment the following line because we added the Vagrant key above to the 
```authorized_keys``` file:
```
AuthorizedKeysFile %h/.ssh/authorized_keys
```
Then restart ssh:
```
sudo service ssh restart
```

#### Installing Guest Tools
Guest Tools help the operating system handle shared folders and “optimize the guest operating 
system for better performance and usability.”

A compiler is required to install the Guest Tools, use this command:
```
sudo apt-get install -y gcc build-essential linux-headers-server
```
In VirtualBox browse to the Devices menu at the top, then in the drop-down list at the bottom, 
click on Insert Guest Additions CD Image.

This will add an ISO image to the virtual CDROM running in your server. Run these commands to mount 
your cdrom and then run the script.
```
sudo mount /dev/cdrom /mnt 
cd /mnt
sudo ./VBoxLinuxAdditions.run
```
_*NOTE: The message about the cdrom being read-only is fine.*_

To finish the installation of guest tools you need to reboot.
```
sudo reboot
```

#### Package the Box
Before you package the box you’ll want to “zero out” the drive. This fixes fragmentation issues with 
the underlying disk, which allows it to compress much more efficiently later.
```
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
```
Now we’re ready to package the box. I usually make a folder to hold my boxes in host like so:
```
mkdir ~/code/personal/vagrant_boxes
cd ~/code/personal/vagrant_boxes
```
This is the command that finally packages up the box for you as we defined above into the 
compressed gzip tarball file, it also generates and includes the Vagrantfile and the metadata.json 
file.
```
vagrant package --base vagrant-ubuntu64
```
Vagrant will then check VirtualBox for any instances of the name vagrant-ubuntu64 and attempt to 
ssh into them and control them.
```
→ vagrant package --base vagrant-ubuntu64
[vagrant-ubuntu64] Attempting graceful shutdown of VM...
[vagrant-ubuntu64] Forcing shutdown of VM...
[vagrant-ubuntu64] Clearing any previously set forwarded ports...
[vagrant-ubuntu64] Exporting VM...
[vagrant-ubuntu64] Compressing package to: /Users/tbird/code/personal/virtual_boxes/package.box
```
You are left with the package.box file in your ```~/code/personal/vagrant_boxes``` folder.

#### Test Your Box
From your same ```vagrant_boxes``` folder you can run these final test commands. All the heavy 
lifting is really done at this point. If you’ve screwed up something it’s probably in a step up above.

You should be in ```~/code/personal/vagrant_boxes/``` and type:
```
vagrant box add ubuntu64 package.box
vagrant init ubuntu64
vagrant up
```
The box should start and you’ve won, you deserve to get your high five on.