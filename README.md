# SNIF-Box
Development Environment used in SNIF development context. How to create an own
vagrant base box from scratch read [here](docs/CreateVagrantBaseBox.md).

## Content
* [Requirements](#requirements)
  * [Software](#software)
  * [SSH key to clone git project](#ssh-key-to-clone-git-project)
* [Initial Steps](#initial-steps)
  * [Clone the repository to host](#clone-the-repository-to-host)
  * [Configuration of start script](#configuration-of-start-script)
* [Start SNIF Box](#start-snif-box) 
* [Development at the beating heart](#development-at-the-beating-heart) 
* [Usage of SNIF-Box](#usage-of-snif-box)
  * [Re-provisioning](#re-provisioning)
  * [Usage Thought](#usage-thought)
  * [Troubleshooting](docs/trouble_shooting.md)

## Requirements
### Software
You need the following software on your host system
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Git](https://github.com/git-guides/install-git)
### SSH key to clone git project
You need to create an SSH key on your host system to clone the repository with SNIFBOX files.
How to do this is described [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).

## Initial Steps
The following steps only need to be performed during the initial setup and after that this section can be
skipped.

### Clone the repository to host
In order to start the SNIF box, the code resources from the Git repository are required. How a repository 
can be cloned is described 
[here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository). 
The following values can be used for the placeholders
* YOUR-USERNAME: krec05
* YOUR-REPOSITORY: snif-box

### Configuration of start script
For the configuration there are two different possibilities, either with a PowerShell script or with a 
Bash script. For the use of the PowerShell script additional requirements are to be fulfilled, which are 
described [here](https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-PowerShell).
1. copy the script snif_box_provision.sh or snif_box_provision.ps1 into the parent directory.
2. replace the value for <REPO_WHERE_THE_DEVBOX_LIVES> in the script
3. create a new shortcut
4. specify the location of the shortcut
   1. power shell: `%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -noexit -File "[filepath]\snif_box_provision.ps1"`
   2. bash: `C:\WindowsSystem32\cmd.exe /c ""C:\Program Files\Git\bin\sh.exe" [filepath]\snif_box_provision.sh"`


## Start SNIF Box
A simple double-click on the shortcut (created in the Configuration of start script section) starts the 
provisioning process. After that, the box is set up by Vagrant and provisioning with Ansible takes place.

The progress of the provisioning can be tracked in the Command window on the host system and looks 
something like the following output.
```shell script
...
    devbox: TASK [apt-install-items : install packages with apt] ***************************
    devbox: ok: [localhost] => {"cache_update_time": 1631879899, "cache_updated": true, "changed": false}
    devbox:
    devbox: TASK [docker : Ensure old versions of Docker are not installed.] ***************
    devbox: ok: [localhost] => {"changed": false}
    devbox:
    devbox: TASK [docker : Ensure dependencies are installed.] *****************************
    devbox: ok: [localhost] => {"cache_update_time": 1631879899, "cache_updated": false, "changed": false}
    devbox:
    devbox: TASK [docker : Add Docker apt key.] ********************************************
    devbox: ok: [localhost] => {"changed": false}
    devbox:
    devbox: TASK [docker : Add Docker repository.] *****************************************
    devbox: ok: [localhost] => {"changed": false, "repo": "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable", "state": "present"}
    devbox:
    devbox: TASK [docker : Install Docker.] ************************************************
    devbox: ok: [localhost] => {"cache_update_time": 1631879899, "cache_updated": false, "changed": false}
...
    devbox:
    devbox: PLAY RECAP *********************************************************************
    devbox: localhost                  : ok=26   changed=0    unreachable=0    failed=0    skipped=19   rescued=0    ignored=0
``` 

## Development at the beating heart
Ansible roles can also be developed within the DevBox. To test single roles you
can temporarily create your own playbook or you can work with tags.

If you assign a tag to a role.

```yaml
- {role: rollen_name, tags: rollen_tag}
```

Then this role can also be executed separately.

```shell script
- ansible-playbook ansible/setup-playbook_name.yml --tags rollen_tag
```

## Usage of SNIF-Box
The password for the DevBox is **vagrant**, as is typical for most Vagrant boxes.

For the desktop shortcuts to work in the DevBox, you have to right-click once in the 
right mouse click in the menu to select `Allow Launching`.

### Re-provisioning
In order to apply new features and bug fixes in the configuration to your own SNIF box, 
it should be should be re-provisioned regularly (preferably at every startup). This is 
done by using the shortcut. One can start the virtual machine created by Vagrant as usual 
over VirtualBox menu to start, stop or save its state. However, it is recommended to do 
this to do this via the shortcut.

### Usage Thought
The SNIF box is designed as a disposable solution. Every user should be able to simply 
throw away the virtual machine at any time and create a replacement. The 
**urgent recommendation** is therefore the following:

When you manually install new programs into the SNIF box ask yourself two questions:
* Do others on my team need this feature?
* How much effort will it take to reinstall if the SNIF box has to be thrown away?

Often the answer will be that it is well worth automating the installation of new 
programs. (actually always :wink:). In that case, be encouraged to create new roles in 
the `ansible/roles` folder. These roles can then be included in the playbook.

Documentation on Ansible can be found [here](https://docs.ansible.com/ansible/latest/user_guide/index.html).

### Troubleshooting
[Troubleshooting](docs/trouble_shooting.md)
