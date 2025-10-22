
# Tasks

## Vagrant/VM
* Is a toplevel flake really necessary?
  * With the project setup maybe not
  * But, having some of the tools globally available could be nice
    * On the other hand it might introduce implicit dependencies from the project on the global configuration
  
### USB Devices
* How to capture USB devices with this setup?
  * There are some we can configure by default, like dongletron
  * But STLink and FTDI serial transcievers are more case-by-case; we don't necessarily want to capture them all the time

## Embedded Tooling
### OpenOCD
* Need to merge upstream openocd and ST's fork into ours
  * Should probably open a pull request for the atsam qspi stuff
* Need to turn this into a nix package so it can be controllably installed
  * https://nix.dev/tutorials/packaging-existing-software.html
* Need to add that package to the project template flake
* Probably some things to do around USB for this

### Roast
* Turn this into a nix package as well?
* Need to put together tooling to insert, extract project environment configuration into/from firmware elf
  * flake.nix, flake.lock, gitman.yml, gitman lock, pixi.toml, pixi.lock
  * "extract" command could create a new directory that:
    * checks out the commit the fw was built with
    * sets up the environment & dependencies according to all of those lock files
    * provides warnings/etc if the image wasn't fully reproducible
    * bing bong boom


### Luminaire Environment
* What else is missing in here?
  * roast support stuff (toolchain.py)
  * libobjc2
  * jsonsl
  * cinvoke
  * pic32mx compiler

## Source Libraries - Gitman
* Try it out, probably in nikira project
* Need to implement hooks
  * git checkout -> reproduce lock file
  * git commit -> attempt to lock
  * build -> attempt to lock

## Project Template
* python dependencies
  * pyserial
  * numpy
* 

## Testing
* Try transitioning the Nikira FPGA project to this setup

## Usability
* Might want to put all of this under a command e.g. lumi
  * Orchestrating gitman stuff
  * Project creation?
  * Adding all of this to an existing project?