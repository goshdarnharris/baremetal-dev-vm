# Goals
* fully reproducible builds
  * nix + pixi both produce reproducible environments
  * nix has an enormous package repository and has been around for a long time, so it's our primary source of packages
    * we can use this to ensure the toolchain is fully reproducible
  * pixi uses the conda-forge repository. it serves two purposes:
    * fallback if nix doesn't have a package
    * managing python packages (including pypi package)
  * gitman manages and pins source code dependencies (e.g. stm32-libs)
    * neither nix nor pixi are appropriate for this kind of dependency
  * so each project has 3 config files:
    * flake.nix - specifies build tools, other command line tools
    * pixi.toml - specifies python & python libraries; tools that aren't available in nixpkgs
    * [TODO] gitman


# Setup

## Adding to an existing project
Just copy all the files to your project and run `direnv allow .`. It'll install a bunch of default packages.

# Project Usage
* direnv will automatically load/unload the environment when you cd into or out of the project directory.

## Adding Packages
* First, see if the package is available for nix: https://search.nixos.org/packages
  * If it is, add it to flake.nix
* Then, try pixi search
  * And add with pixi add

## Managing code dependencies (e.g. our library repos)
* The default pixi.toml installs gitman https://gitman.readthedocs.io/en/latest/
* Gitman can be used to specify repositories as dependencies, pin their versions (commit hash), and restore pinned versions
* [TODO] the template includes git hooks that will lock dependency versions before commit
  * gitman will not lock versions if any of the dependencies are dirty
  * this ensures every commit is reproducible
  * this is overridable
  * it will add a note to the end of the commit message specifying whether the commit is reproducible
    * or a git note? not sure which is better
* [TODO] if needed, also includes checkout hooks that will update the environment to match the checked out configuration
  * argument to suppress this behaviour
* [TODO] the template includes build hooks that will attempt to lock dependency versions before commit
  * if dependencies can be lock, it will do so
  * if not, it will provide a warning that this build is not reproducible

## Firmware image build reproduction
* [TODO] template includes a tool that can be used to inject the project's full environment configuration into a special ELF section, and a tool to extract it
  * maybe instead of extracting, it gives a way to create a shell that matches the image's build environment?
  * injects flake.nix, pixi.toml, pixi.lock, [gitman]
  * marks whether the image's build is reproducible