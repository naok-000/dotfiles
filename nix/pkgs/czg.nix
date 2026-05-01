{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nix-update-script,
  nodejs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "czg";
  version = "1.13.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/czg/-/czg-${finalAttrs.version}.tgz";
    hash = "sha256-vNJoDpD0lKN7EsLUWEbQlnQ2aebCmL11Zm1dmI8jwFg=";
  };

  nativeBuildInputs = [makeWrapper];

  unpackPhase = ''
    runHook preUnpack
    tar -xzf "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/node_modules/czg"
    cp -r package/* "$out/lib/node_modules/czg/"

    mkdir -p "$out/bin"
    makeWrapper ${nodejs}/bin/node "$out/bin/czg" \
      --add-flags "$out/lib/node_modules/czg/bin/index.js"
    makeWrapper ${nodejs}/bin/node "$out/bin/git-czg" \
      --add-flags "$out/lib/node_modules/czg/bin/index.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    attrPath = "czg";
    extraArgs = [ "--flake" ];
  };

  meta = with lib; {
    description = "Interactive Commitizen CLI that generates standardized git commit messages";
    homepage = "https://cz-git.qbb.sh/cli/";
    license = licenses.mit;
    mainProgram = "czg";
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [binaryBytecode];
  };
})
