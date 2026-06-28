{
  config,
  pkgs,
  dotfilesMutableRoot,
  ...
}: {
  home.file = {
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesMutableRoot}/emacs";
  };

  home.packages = [
    pkgs.emacs
  ];
}
