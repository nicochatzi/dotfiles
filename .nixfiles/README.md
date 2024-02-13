<h1 align="center">❄️</h1>

<h3 align="center">setup</h3>

```bash
$ git clone https://github.com/nicochatzi/nixfiles ~/.nixfiles
$ sudo nixos-rebuild switch \
    --experimental-features 'nix-command flakes' \
    --flake ~/.nixfiles#<HOST>
$ ~/.nixfiles/assets/install-dotfiles.sh
```

<h3 align="center">demo</h3>

![lati](./assets/lati.png)
