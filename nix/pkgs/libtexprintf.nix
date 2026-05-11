{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libtexprintf";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "bartp5";
    repo = "libtexprintf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OXDcohfSfik0H1MpoznN267OVTYkW75N+TIF6lRRvZ0=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script {
    attrPath = "libtexprintf";
    extraArgs = ["--flake"];
  };

  meta = with lib; {
    description = "Library and CLI for pretty-printing TeX-like math as UTF-8 text";
    homepage = "https://github.com/bartp5/libtexprintf";
    license = licenses.gpl3Only;
    mainProgram = "utftex";
    platforms = platforms.unix;
  };
})
