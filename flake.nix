{
  description = "naok-000 Home Manager configuration";
  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    neovim-nightly-overlay,
    home-manager,
    llm-agents,
    ...
  }: let
    darwinUsername = "kobayashinaotaro";
    ubuntuUsername = "kobayashinaotaro";
    darwinProfileName = darwinUsername;
    ubuntuProfileName = "ubuntu";
    darwinHomeDirectory = "/Users/${darwinUsername}";
    ubuntuHomeDirectory = "/home/${ubuntuUsername}";
    dotfilesRoot = ./.;
    overlays = [
      neovim-nightly-overlay.overlays.default
      llm-agents.overlays.default
      (import ./nix/overlays/default.nix)
    ];
    githubSigningKeys = {
      ${darwinProfileName} = "${darwinHomeDirectory}/.ssh/id_ed25519-github_sign";
      ${ubuntuProfileName} = "${ubuntuHomeDirectory}/.ssh/id_ed25519-github_sign_ubuntu";
    };

    mkGithubSigningKey = profileName:
      if builtins.hasAttr profileName githubSigningKeys
      then githubSigningKeys.${profileName}
      else throw "github signing key is not defined for profile '${profileName}'";

    mkDotfilesMutableRoot = homeDirectory: "${homeDirectory}/workspace/ghq/github.com/naok-000/dotfiles";

    mkPkgs = system:
      import nixpkgs {
        inherit system overlays;
      };

    # Build common Home Manager user identity fields.
    mkUserHome = {
      username,
      homeDirectory,
    }: {
      home.username = username;
      home.homeDirectory = homeDirectory;
    };

    # Build the shared Home Manager module block for nix-darwin.
    mkHomeManagerModule = {
      username,
      homeDirectory,
      profileName,
      githubSigningKey,
      dotfilesMutableRoot,
    }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit dotfilesRoot dotfilesMutableRoot profileName githubSigningKey;
      };
      home-manager.users.${username} =
        {
          imports = [./nix/home/default.nix];
        }
        // (mkUserHome {
          inherit username homeDirectory;
        });
    };

    # Build a nix-darwin system with shared overlays and Home Manager integration.
    mkDarwin = {
      system,
      username,
      homeDirectory,
      profileName,
      githubSigningKey,
      dotfilesMutableRoot,
    }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ({pkgs, ...}: {
            users.users.${username} = {
              home = homeDirectory;
            };
            nixpkgs.overlays = overlays;
            environment.systemPackages = [
              pkgs.vim
            ];
            # Disable nix-darwin's nix management; use Determinate Nix instead.
            nix.enable = false;
            system = {
              configurationRevision = self.rev or self.dirtyRev or null;
              stateVersion = 6;
              primaryUser = username;
            };
            nixpkgs.hostPlatform = system;
          })
          ./nix/modules/dev/homebrew.nix
          ./nix/modules/dev/colima.nix
          ./nix/modules/dev/mlx-lm-server.nix
          home-manager.darwinModules.home-manager
          (mkHomeManagerModule {
            inherit username homeDirectory profileName githubSigningKey dotfilesMutableRoot;
          })
        ];
      };

    # Build a standalone Home Manager configuration for non-darwin systems.
    mkHome = {
      system,
      username,
      homeDirectory,
      profileName,
      githubSigningKey,
      dotfilesMutableRoot,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs system;
        extraSpecialArgs = {
          inherit dotfilesRoot dotfilesMutableRoot profileName githubSigningKey;
        };
        modules = [
          ./nix/home/default.nix
          (mkUserHome {
            inherit username homeDirectory;
          })
        ];
      };
  in {
    darwinConfigurations.${darwinUsername} = mkDarwin {
      system = "aarch64-darwin";
      username = darwinUsername;
      homeDirectory = darwinHomeDirectory;
      profileName = darwinProfileName;
      githubSigningKey = mkGithubSigningKey darwinProfileName;
      dotfilesMutableRoot = mkDotfilesMutableRoot darwinHomeDirectory;
    };

    homeConfigurations = {
      ubuntu = mkHome {
        system = "x86_64-linux";
        username = ubuntuUsername;
        homeDirectory = ubuntuHomeDirectory;
        profileName = ubuntuProfileName;
        githubSigningKey = mkGithubSigningKey ubuntuProfileName;
        dotfilesMutableRoot = mkDotfilesMutableRoot ubuntuHomeDirectory;
      };
    };

    packages = {
      aarch64-darwin = let
        pkgs = mkPkgs "aarch64-darwin";
      in {
        inherit (pkgs) czg;
      };

      x86_64-linux = let
        pkgs = mkPkgs "x86_64-linux";
      in {
        inherit (pkgs) czg;
      };
    };
  };
}
