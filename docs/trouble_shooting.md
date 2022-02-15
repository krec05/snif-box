# Troubleshooting
When provisioning a SNIF box, things can sometimes go wrong. The following sections will 
hopefully allow you to quickly sort out most of the errors. If the problem is not yet 
listed here, it should be included here for the benefit of knowledge distribution.

## Content
* [Failed Provisioning](#failed-provisioning)
* [The network adapter fails under Windows](#the-network-adapter-fails-under-windows)

## Failed Provisioning
If the provisioning by Ansible was not successful, the last lines will look something like this:
```shell script
<pre>
    devbox: PLAY RECAP *********************************************************************
    devbox: localhost                  : ok=347  changed=74   unreachable=0    <b>failed=1</b>    skipped=38   rescued=0    ignored=3
</pre>
```

If a role fails, all subsequent roles will not be executed. This means that the provisioning was 
not successful. The challenge now is of course to find out why this happened!

Example:
```shell script
<pre>
    devbox: TASK [ConfPRD : download hive config] ******************************************    devboxlunchtest20200227112402f-ocp: fatal: [localhost]: FAILED! => 
    {"changed": false, "dest": "/tmp/hive-clientconfig.zip", "elapsed": 0, "msg": "Request failed", "response": "HTTP Error 404: No service found with ID 8.", "status_code": 404, "url": "http://brhdprdma01.ov.otto.de:7180/cmf/services/8/client-config"}
    devbox:
    devbox: PLAY RECAP *********************************************************************    devboxlunchtest20200227112402f-ocp: localhost                  : ok=167  changed=118  unreachable=0    failed=1    skipped=8    rescued=0    ignored=5
</pre>
```
Here the end of the playbook tells you that it has failed and that the last roll has failed. Here 
the consequence is quite simple ... 404 probably means the resource is not there. In this way you 
have to work your way to the bugs.

## The network adapter fails under Windows
If in provisioning something similar appears to:
```shell script
<pre>
    Stderr: VBoxManage.exe: error: Failed to open/create the internal network 'HostInterfaceNetworking-VirtualBox Host-Only Ethernet Adapter' (VERR_INTNET_FLT_IF_NOT_FOUND).
    VBoxManage.exe: error: Failed to attach the network LUN (VERR_INTNET_FLT_IF_NOT_FOUND)
    VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component ConsoleWrap, interface IConsole
</pre> 
```
your windows has updated itself and you have a pretty solid problem :dizzy_face:.

The following helped last time:
* Uninstall VirtualBox
* Restart computer
* Reinstall VirtualBox
* Restart computer
* ... try again
* ***don't blame me, blame Windows***

