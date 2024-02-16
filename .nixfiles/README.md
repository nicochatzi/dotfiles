<h1 align="center">❄️</h1>

<h3 align="center">setup</h3>

```bash
# build nixos for current host, assuming it's setup in hosts/
$ sudo nixos-rebuild switch \
    --experimental-features 'nix-command flakes' \
    --flake ~/.nixfiles#$(hostname)
# dotfile installation and more
$ curl https://raw.githubusercontent.com/nicochatzi/dotfiles/main/.scripts/setup-nixos.sh \
    | bash
```

<h3 align="center">dark</h3>

![lati](./assets/lati-dark.png)

<h3 align="center">light</h3>

![lati](./assets/lati-light.png)
