{
  pkgs,
  dotfilesRoot,
  dotfilesMutableRoot,
  ...
}: let
  tsSelected = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.nix
    p.lua
    p.vim
    p.vimdoc
    p.query
    p.regex
    p.markdown
    p.markdown_inline
    p.json
    p.yaml
    p.toml
    p.bash
    p.gitignore
    p.dockerfile
    p.html
    p.ruby
    p.latex
    p.go
    p.rust
    p.python
    p.cpp
  ]);
  tsBundle = pkgs.symlinkJoin {
    name = "nix-treesitter-bundle";
    paths = [tsSelected] ++ tsSelected.dependencies;
  };
  nvimPackages = with pkgs; [
    clang-tools
    lua-language-server
    prettier
    vscode-langservers-extracted
    prettierd
    pyright
    ruff
    stylua
    texlab
  ];
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    defaultEditor = true;
  };

  home.packages = nvimPackages;
  home.sessionVariables.NVIM_LAZY_LOCKFILE = "${dotfilesMutableRoot}/nvim/lazy-lock.json";
  xdg.configFile."nvim".source = dotfilesRoot + /nvim;
  home.file.".local/share/nvim/nix-treesitter".source = tsBundle;
}
