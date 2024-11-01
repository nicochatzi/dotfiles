<h1 align="center">❄️</h1>

<h3 align="center">pre install</h3>

If not enabled (legacy)

```bash
$ mkdir -p ~/.config/nix
$ echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

<h3 align="center">install</h3>

```bash
# enter bootstrapping shell
$ nix shell nixpkgs#git nixpkgs#curl
# install dotfiles on new system
$ curl https://raw.githubusercontent.com/nicochatzi/dotfiles/main/.scripts/install-dotfiles.sh \
  | bash
# setup new host machine in .nixfiles/hosts/$(hostname)
# generate the hardware config
$ nixos-genertae-config --root .
# OR get from system
$ cp /etc/nixos/hardware-configuration.nix ~/.nixfiles/hosts/$(hostname)/
# build system for current host
$ sudo nixos-rebuild switch --flake ~/.nixfiles#$(hostname)
```

<h3 align="center">post install</h3>

- lightdm greeter might need to be disabled on first boot.
- rusutp is not fully setup, run:

```bash
rustup default stable
rustup components add rust-analyzer
```

- tmux/tpm setup

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

<h3 align="center">dark</h3>

![lati-dark](./assets/lati-dark.png)

<h3 align="center">light</h3>

![lati-light](./assets/lati-light.png)
