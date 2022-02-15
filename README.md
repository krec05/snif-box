# SNIF-Box
Development Environment used in SNIF development context. How to create an own
vagrant base box from scratch read [here](docs/CreateVagrantBaseBox.md).

## Content
* [Requirements](#requirements)
  * [Software](#Software)
  * [SSH key to clone git project](#SSH key to clone git project)
* [Initial Steps](#Initial Steps)
  * [Clone the repository to host](#Clone the repository to host)
  * [Configuration of start script](#Configuration of start script)
* [Start SNIF Box](#Start SNIF Box) 
* [Development at the beating heart](#Development at the beating heart) 

## Requirements
### Software
You need the following software on your host system
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Git](https://github.com/git-guides/install-git)
###SSH key to clone git project
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





# Old Stuff need to integrate in README

#BI DevBox

##Inhaltsverzeichnis
- [Nutzung](#Nutzung)
    * [Erneutes Provisionieren](#Erneutes Provisionieren)
- [Nutzungsgedanke](#nutzungsgedanke)
- [Weiterentwicklung der DevBox](#weiterentwicklung)
- [Weiterführende Themen](#Weiterführende Themen)
    * [Troubleshooting](#Troubleshooting)

##Nutzung
Das Passwort für die DevBox lautet **vagrant**, wie es für die meisten Vagrant Boxen typisch ist.

Damit die Desktop Verknüpfungen in der DevBox vom DBVisualizer und der Jetbrain Toolbox funktionieren,
muss per rechten Mausklick in dem Menü das `Allow Launching` ausgewählt werden.

###Erneutes Provisionieren
Um Neuerungen und Bugfixes in der Konfiguration in die eigene DevBox zu übernehmen, sollte sie
regelmäßig (gerne bei jedem Start) neu provisioniert werden. Dies geschieht durch die Verwendung der 
Verknüpfung. Man kann die von Vagrant erstellte virtuelle Maschine wie üblich über
das Menü von VirtualBox starten, stoppen oder ihren Zustand speichern. Empfohlen ist es aber, dies
über die Verknüpfung zu tun.


##Nutzungsgedanke
Die DevBox ist als Wegwerf-Lösung konzipiert. Jeder Nutzer soll in die Lage versetzt werden jederzeit
einfach die virtuelle Maschine wegwerfen zu können und einen Ersatz zu erschaffen.
Die **dringende Empfehlung** ist daher folgende:

Wenn ihr händisch neue Programme in die DevBox installiert stellt euch zwei Fragen:
* Brauchen noch andere in meinem Team dieses Feature?
* Wie aufwendig ist die erneute Installation, wenn die DevBox weggeschmissen werden muss?

Oft wird die Antwort sein, dass es sich durchaus lohnt die Installation neuer Programme zu
automatisieren. (eigentlich immer :wink:). In dem Fall sei ermutigt neue Rollen im Ordner `ansible/roles`
zu erstellen. Diese Rollen können dann im Playbook eingebunden werden.

Eine Dokumentation zu Ansible befindet sich [hier](https://docs.ansible.com/ansible/latest/user_guide/index.html).


##Weiterentwicklung
Erweiterungen sind immer willkommen!

Schaut bitte, dass in Pull-Request ein paar der letzten Committer aufgenommen werden um das Wissen über
neue Dinge zu verteilen.

##Weiterführende Themen

###Troubleshooting
[Troubleshooting](docs/trouble_shooting.md)
