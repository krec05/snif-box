cd "<REPO_WHERE_THE_DEVBOX_LIVES>" # e.g. C:\git_workspace\snif-box\ansible
# test if you are local on the main branch
$main = git branch | findstr -i main
git fetch
# checking out the main when you are on another branch
if($main -ne "* main"){
	echo "switch to branch main"
    git checkout -f main
}
else{
    echo "already on branch main"
}
# reset the local branch and update it to the latest state
git reset --hard HEAD
git pull
# startup and re-provisioning of the SNIF-Box
$env:ROLES="setup-snif-box.yml"
vagrant up snifbox --provision
# terminal remains open so that error messages do not disappear if necessary
Read-Host -Prompt "Press Enter to exit"