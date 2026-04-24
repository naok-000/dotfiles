{pkgs, ...}: let
  colimaStart = pkgs.writeShellScript "colima-start" ''
    if ! ${pkgs.colima}/bin/colima start; then
      exit 1
    fi

    ${pkgs.docker}/bin/docker context use colima >/dev/null
  '';
in {
  launchd.user.agents.colima = {
    serviceConfig = {
      Label = "local.colima";
      ProgramArguments = [
        "${colimaStart}"
      ];
      RunAtLoad = true;
    };
  };
}
