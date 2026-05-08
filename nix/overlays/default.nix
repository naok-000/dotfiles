{
  markdown-formatter-ja,
}: final: prev: {
  czg = final.callPackage ../pkgs/czg.nix {};
  markdown-formatter-ja = markdown-formatter-ja.packages.${final.stdenv.hostPlatform.system}.default;
  mo = final.callPackage ../pkgs/mo.nix {};
}
