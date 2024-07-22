{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # language servers / tools
    asm-lsp
    cmake-language-server
    dockerfile-language-server-nodejs
    gopls
    ltex-ls
    lua-language-server
    nil
    nixfmt
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    marksman
    pyright
    python311Packages.black
    python311Packages.pylint
    python311Packages.pynvim
    python311Packages.python-lsp-server
    ruff
    rust-analyzer
    sqls
    taplo
    tflint
    vscode-extensions.vadimcn.vscode-lldb # provides code-lldb for DAP support
    vscode-langservers-extracted # provides html, css, json, eslint
    yaml-language-server
    zls
  ];

}
