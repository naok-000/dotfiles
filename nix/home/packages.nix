{
  pkgs,
  lib,
  ...
}: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]
  );

  nixPackages = with pkgs; [
    alejandra
  ];

  shellPackages = with pkgs; [
    bottom
    coreutils
    emacs
    eza
    fastfetch
    fd
    fzf
    htop
    mtr
    ripgrep
    tldr
    trash-cli
    tree
    wget
  ];

  gitPackages = with pkgs; [
    czg
    gh
    ghq
    git
    pre-commit
  ];

  buildPackages = with pkgs; [
    buf
    ccache
    cmake
    gperf
    ninja
    tree-sitter
  ];

  languagePackages = with pkgs; [
    cargo
    deno
    golangci-lint
    lua
    luarocks
    markdownlint-cli2
    nodejs
    textlint
    pipx
    python3
    python314Packages.pylatexenc
    rustc
    taplo
    uv
  ];

  latexPackages = with pkgs; [
    inkscape
    texliveFull
  ];

  cloudPackages = with pkgs; [
    docker
    docker-compose
    gdk
    qemu
  ];

  embeddedPackages = with pkgs; [
    minicom
    openocd
  ];

  appPackages = with pkgs; [
    bibtex-tidy
    hugo
    imagemagick
    llm-agents.codex
    mo
    poppler-utils
    wezterm
  ];

  packages = lib.concatLists [
    nixPackages
    shellPackages
    gitPackages
    buildPackages
    languagePackages
    latexPackages
    cloudPackages
    embeddedPackages
    appPackages
  ];

  darwinOnlyPackages = with pkgs; [
    aerospace
    colima
    docker-credential-helpers
    macskk
  ];
in {
  home.packages =
    packages
    ++ lib.optionals pkgs.stdenv.isDarwin darwinOnlyPackages;
}
