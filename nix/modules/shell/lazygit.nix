{...}: {
  xdg.enable = true;
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
      };
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
      };
      customCommands = [
        {
          command = "czg";
          context = "files";
          output = "terminal";
          key = "c";
        }
        {
          command = "czg ai";
          context = "files";
          output = "terminal";
          key = "C";
        }
      ];
    };
  };
}
