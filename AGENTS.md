# AGENTS.md

## Project Overview

This repository is for managing dotfiles and system configuration using Nix, Nix Flakes, and home-manager. The goal is to create a portable and reproducible configuration that can be easily applied to different machines, including both macOS and Linux systems.

## Key Features

- Dotfiles are managed using _Nix_, _Nix Flakes_, and _home-manager_.
- The configuration is designed to be portable and reproducible across different machines, includes macOS and Linux.

## Usage

### Initial Setup

```console
$ sudo nix run nix-darwin -- switch --flake .#kobayashinaoto
```

### Update

```console
$ git add . && sudo darwin-rebuild -- switch --flake .#kobayashinaoto
```

## Quick Guide

- Entry point: `flake.nix`
  - Home Manager is loaded from `nix/home/default.nix`.
- Add packages: `nix/home/packages.nix`
  - Put CLI and development tools in a single `packages` list.
  - Keep platform-specific additions in `darwinOnlyPackages`.
- Manage config files: `nix/home/config-files.nix`
  - Use `xdg.configFile` for files under `~/.config`.
  - Use `home.file` only for minimal exceptions (for example dotfiles in `$HOME` root).
- Add or change app behavior: `nix/modules/`
  - `nix/modules/dev/` for editor/development tools.
  - `nix/modules/shell/` for shell and CLI tools.
