{...}: {
  xdg.enable = true;
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        theme = {
          activeBorderColor = ["blue" "bold"];
          inactiveBorderColor = ["default"];
          searchingActiveBorderColor = ["cyan" "bold"];
          optionsTextColor = ["blue"];
          selectedLineBgColor = ["blue"];
          inactiveViewSelectedLineBgColor = ["bold"];
          cherryPickedCommitFgColor = ["blue"];
          cherryPickedCommitBgColor = ["cyan"];
          markedBaseCommitFgColor = ["blue"];
          markedBaseCommitBgColor = ["yellow"];
          unstagedChangesColor = ["red"];
          defaultFgColor = ["default"];
        };
      };
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --light --paging=never";
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
