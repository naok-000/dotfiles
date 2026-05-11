# dotfiles

## Initial setup

```console
$ sudo nix run nix-darwin -- switch --flake .#kobayashinaotaro
```

## Initial setup (Ubuntu)

```console
$ nix run home-manager -- switch --flake .#ubuntu
```

## Update

```console
$ sudo darwin-rebuild switch --flake .#kobayashinaotaro
```

## Update (Ubuntu)

```console
$ home-manager switch --flake .#ubuntu
```

## Update codex (llm-agents)

```console
$ nix flake update --update-input llm-agents
$ git add . && sudo darwin-rebuild switch --flake .#kobayashinaotaro
```

## Package Management Policy

- CLI and development tools are managed by Nix (`nix/home/packages.nix` and modules).
- Fonts are managed by Nixpkgs through `nix/modules/dev/fonts.nix`.
- GUI apps are managed by Homebrew Casks declared through `nix-darwin` `homebrew` options.
- Avoid installing unmanaged packages with ad-hoc `brew install` where possible.
