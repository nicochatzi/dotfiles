<h1 align="center">❄️</h1>

<h3 align="center">install</h3>

```bash
$ mkdir -p ~/.config/nix
$ echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
# enter bootstrapping shell
$ nix shell nixpkgs#git nixpkgs#curl nixpkgs#vim
# install dotfiles on new system
$ curl https://raw.githubusercontent.com/nicochatzi/dotfiles/main/.scripts/install-dotfiles.sh \
  | bash
# setup new host machine in .nixfiles/hosts/$(hostname)
# generate the hardware config
# nixos-genertae-config --root .
$ ...
# build system for current host
$ sudo nixos-rebuild switch --flake ~/.nixfiles#$(hostname)
```

<h3 align="center">dark</h3>

![lati-dark](./assets/lati-dark.png)

<h3 align="center">light</h3>

![lati-light](./assets/lati-light.png)
