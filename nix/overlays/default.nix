{markdown-formatter-ja}: final: prev: {
  czg = final.callPackage ../pkgs/czg.nix {};
  libtexprintf = final.callPackage ../pkgs/libtexprintf.nix {};
  markdown-formatter-ja = final.rustPlatform.buildRustPackage {
    pname = "markdown-formatter-ja";
    version = "0.1.0";
    src = markdown-formatter-ja;
    cargoHash = "sha256-UwVk6Y/1ewdzo7ehJCKKW8sv4TX7orQdTtQCRR4EjRs=";
  };
  mo = final.callPackage ../pkgs/mo.nix {};
}
