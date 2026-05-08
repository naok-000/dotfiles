{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}: let
  version = "1.5.2";
  sources = {
    aarch64-darwin = {
      file = "mo_v${version}_darwin_arm64.zip";
      hash = "sha256-gHFUrxXUV0bugu7KFN36c7ZnHIYIyxSe2qpaIPa1IZ8=";
    };
    x86_64-linux = {
      file = "mo_v${version}_linux_amd64.tar.gz";
      hash = "sha256-5X/kbDScVqe5cLuveS15wUnLGzpB/ykmXon4ECKyBRY=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system};
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "mo";
    inherit version;

    src = fetchurl {
      url = "https://github.com/k1LoW/mo/releases/download/v${finalAttrs.version}/${source.file}";
      inherit (source) hash;
    };

    nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [unzip];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      install -Dm755 mo "$out/bin/mo"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Markdown viewer that opens .md files in a browser";
      homepage = "https://github.com/k1LoW/mo";
      license = licenses.mit;
      mainProgram = "mo";
      platforms = builtins.attrNames sources;
    };
  })
