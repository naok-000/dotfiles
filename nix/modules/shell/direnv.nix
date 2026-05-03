{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    package = pkgs.direnv.overrideAttrs {
      checkPhase = ''
        runHook preCheck
        make test-go test-bash test-fish
        runHook postCheck
      '';
    };
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
