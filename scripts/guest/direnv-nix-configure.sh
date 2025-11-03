cd ~/
#Set up user directory envrc 
direnv allow
eval "$(direnv export bash)"

#Set up hook
echo "eval \"\$(direnv hook bash)\"" >> .bashrc