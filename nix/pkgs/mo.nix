{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}: let
  version = "1.6.3";
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "mo";
    inherit version;

    src = fetchurl {
      url = "https://github.com/k1LoW/mo/releases/download/v${finalAttrs.version}/mo_v${finalAttrs.version}_linux_amd64.tar.gz";
      hash = "sha256-sobqdBSeLI9zzbjjioK9YiOnhpYoAb3pq2p1CcJcjfA=";
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      install -Dm755 mo "$out/bin/mo"

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script {
      attrPath = "mo";
      extraArgs = ["--flake"];
    };

    meta = with lib; {
      description = "Markdown viewer that opens .md files in a browser";
      homepage = "https://github.com/k1LoW/mo";
      license = licenses.mit;
      mainProgram = "mo";
      platforms = ["x86_64-linux"];
    };
  })
