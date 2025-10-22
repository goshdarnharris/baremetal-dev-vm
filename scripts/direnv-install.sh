#Install direnv, nix-direnv globally
nix profile add nixpkgs#direnv nixpkgs#nix-direnv

#Add nix-direnv hooks
mkdir -p $HOME/.config/direnv
echo "source $HOME/.nix-profile/share/nix-direnv/direnvrc" >> $HOME/.config/direnv/direnvrc

#Reduce verbosity of direnv logging
echo "[global]" > $HOME/.config/direnv/direnv.toml
echo "log_format = \"-\"" >> $HOME/.config/direnv/direnv.toml
#This doesn't seem to work; it silences everything. Not sure why.
echo "log_filter = \"^direnv: (loading|unloading).*$\"" >> $HOME/.config/direnv/direnv.toml

