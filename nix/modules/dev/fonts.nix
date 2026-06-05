{pkgs, ...}: let
  ibm-plex-sans-jp = pkgs.stdenvNoCC.mkDerivation {
    pname = "ibm-plex-sans-jp";
    version = pkgs.ibm-plex.version;

    src = pkgs.fetchzip {
      url = "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-jp%40${pkgs.ibm-plex.version}/ibm-plex-sans-jp.zip";
      hash = "sha256-hUl/SSkN6q3pDTtrY2mJepw3ljhhLJskGbxfsTl9TuI=";
    };

    installPhase = ''
      runHook preInstall

      install -Dm644 fonts/complete/otf/hinted/*.otf -t "$out/share/fonts/opentype"
      install -Dm644 fonts/complete/ttf/hinted/*.ttf -t "$out/share/fonts/truetype"

      runHook postInstall
    '';

    meta =
      pkgs.ibm-plex.meta
      // {
        description = "IBM Plex Sans JP";
      };
  };
in {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    hackgen-font
    hackgen-nf-font
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    udev-gothic-nf
    biz-ud-gothic
    ibm-plex
    inter
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
    ibm-plex-sans-jp
    plemoljp-nf
    sarasa-gothic
    atkinson-hyperlegible
  ];
}
