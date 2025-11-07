cd ~/
#Set up user directory envrc 
direnv allow

#Ideally we would run this to do the home environment setup
#as part of provisioning, rather than the first time the user
#logs in. But, doing it here doesn't use the SSH keys we've
#installed so provisioning throws an error for private repos.
#Functionally it's fine but a bit confusing see the errors.
#eval "$(direnv export bash)"

#Hook is already in .bashrc that gets copied to the guest.
# echo "eval \"\$(direnv hook bash)\"" >> .bashrc