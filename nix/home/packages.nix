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
    fastfetch
    fd
    fzf
    htop
    mtr
    ripgrep
    tldr
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
    nodejs
    textlint
    pipx
    python3
    rustc
    taplo
    texlivePackages.latexindent
    uv
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
    poppler-utils
    wezterm
  ];

  packages = lib.concatLists [
    nixPackages
    shellPackages
    gitPackages
    buildPackages
    languagePackages
    cloudPackages
    embeddedPackages
    appPackages
  ];

  darwinOnlyPackages = with pkgs; [
    aerospace
    colima
    docker-credential-helpers
  ];
in {
  home.packages =
    packages
    ++ lib.optionals pkgs.stdenv.isDarwin darwinOnlyPackages;
}
