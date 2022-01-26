#Troubleshooting
Bei der Provisionierung einer DevBox kann manchmal auch etwas schief gehen.
Die folgenden Abschnitte ermöglichen hoffentlich den ein oder anderen Fehler schnell aus der Welt zu 
schaffen. Wenn das Problem hier noch nicht aufgeführt ist, sollte es im Sinne der Wissensverteilung hier 
mit aufgenommen werden.

##Table Of Contents
- [Die Provisionierung war nicht erfolgreich](#Die Provisionierung war nicht erfolgreich)
- [Der Netzwerkadapter spinnt unter Windows](#Der Netzwerkadapter spinnt unter Windows)

##Die Provisionierung war nicht erfolgreich

Wenn die Provisionierung durch Ansible nicht erfolgreich war werden die letzten Zeile ungefähr so 
aussehen:
```shell script
<pre>
    devbox: PLAY RECAP *********************************************************************
    devbox: localhost                  : ok=347  changed=74   unreachable=0    <b>failed=1</b>    skipped=38   rescued=0    ignored=3
</pre>
```

Sofern eine Rolle gescheitert ist werden alle folgenden Rollen nicht weiter ausgeführt. Das heißt die 
Provisionierung war nicht erfolgreich. Die Aufgabe ist jetzt natürlich herauszufinden woran das liegt!

Beispiel:
```shell script
<pre>
    devbox: TASK [ConfPRD : download hive config] ******************************************    devboxlunchtest20200227112402f-ocp: fatal: [localhost]: FAILED! => 
    {"changed": false, "dest": "/tmp/hive-clientconfig.zip", "elapsed": 0, "msg": "Request failed", "response": "HTTP Error 404: No service found with ID 8.", "status_code": 404, "url": "http://brhdprdma01.ov.otto.de:7180/cmf/services/8/client-config"}
    devbox:
    devbox: PLAY RECAP *********************************************************************    devboxlunchtest20200227112402f-ocp: localhost                  : ok=167  changed=118  unreachable=0    failed=1    skipped=8    rescued=0    ignored=5
</pre>
```

Hier sagt dir das Ende vom Playbook das es gescheitert ist und dir wird auch gleich mitgeteilt, dass die 
letzte Rolle gescheitert ist. Hier ist die Folge recht einfach ... 404 heißt wohl die Ressource ist 
nicht da. Auf diese Art und Weise muss man sich dann an die Fehler ranarbeiten.

##Der Netzwerkadapter spinnt unter Windows
Wenn bei der Provisionierung etwas Ähnliches wie:
```shell script
<pre>
    Stderr: VBoxManage.exe: error: Failed to open/create the internal network 'HostInterfaceNetworking-VirtualBox Host-Only Ethernet Adapter' (VERR_INTNET_FLT_IF_NOT_FOUND).
    VBoxManage.exe: error: Failed to attach the network LUN (VERR_INTNET_FLT_IF_NOT_FOUND)
    VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component ConsoleWrap, interface IConsole
</pre> 
```

erscheint hat eurer Windows sich geupdatet und ihr habt ein recht solides Problem :dizzy_face:.

Folgendes hat beim letzten mal geholfen:

* VirtualBox deinstallieren
* Rechner neu starten
* VirtualBox neu installieren
* Rechner neu starten
* ... neu versuchen
* ***don't blame me, blame Windows***
