<h1 align="center">❄️</h1>

<h3 align="center">install</h3>

```bash
# enter bootstrapping environment
$ NIX_CONFIG="experimental-features=flakes" \
    nix-env -iA nixos.git nixos.curl nixos.vim
# install dotfiles on new system
$ curl https://raw.githubusercontent.com/nicochatzi/dotfiles/main/.scripts/install-dotfiles.sh \
  | bash
# setup new host machine in .nixfiles/hosts/$(hostname)
$ ...
# build system for current host
$ sudo nixos-rebuild switch --flake ~/.nixfiles#$(hostname)
```

<h3 align="center">dark</h3>

![lati-dark](./assets/lati-dark.png)

<h3 align="center">light</h3>

![lati-light](./assets/lati-light.png)
