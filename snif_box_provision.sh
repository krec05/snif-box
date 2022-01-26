#!/usr/bin/env bash
cd "<REPO_WHERE_THE_DEVBOX_LIVES>" # e.g. /home/krec/SNIF-Box/snif-box/ansible

git pull

echo "start vagrant up"
ROLES="setup-snif-box.yml" vagrant up --provision

read -p "Press enter to continue"
