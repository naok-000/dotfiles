{markdown-formatter-ja}: final: prev:
{
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
// prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  emacs = prev.emacs.overrideAttrs (old: {
    # Emacs 30.2 detects C23 C keywords, but Darwin Objective-C sources are
    # compiled without those keywords in the local macOS toolchain.
    postPatch =
      (old.postPatch or "")
      + ''
        sed -i '/#if defined WINDOWSNT/i #include <stdalign.h>\n#include <stdbool.h>' src/conf_post.h
      '';
  });
}
