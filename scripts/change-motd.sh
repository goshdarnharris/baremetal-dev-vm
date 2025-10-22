#Disable the updates avaiable portion of the default motd; we will update by changing
#the base box we're using rather than any ubuntu commands.
mv /etc/update-motd.d/90-updates-available /etc/update-motd.d/90-updates-available.bak

#Other configuration-related things we don't need
mv /etc/update-motd.d/10-help-text /etc/update-motd.d/10-help-text.bak
mv /etc/update-motd.d/91-contract-ua-esm-status /etc/update-motd.d/91-contract-ua-esm-status.bak
mv /etc/update-motd.d/91-release-upgrade /etc/update-motd.d/91-release-upgrade.bak