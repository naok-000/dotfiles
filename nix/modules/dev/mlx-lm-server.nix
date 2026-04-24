{
  config,
  pkgs,
  ...
}: let
  username = config.system.primaryUser;
  homeDirectory = config.users.users.${username}.home;
  huggingFaceHome = "${homeDirectory}/.cache/huggingface";
  transformersCache = "${huggingFaceHome}/transformers";
  uvCacheDir = "${homeDirectory}/.cache/uv";
  chatTemplate = ''
    {{ messages[-1]["content"] }}
  '';
  mlxLmServer = pkgs.writeShellScript "mlx-lm-server" ''
    exec ${pkgs.uv}/bin/uv tool run \
      --python 3.11 \
      --with torch \
      --with numba \
      --from mlx-lm==0.31.1 \
      mlx_lm.server \
      --model mlx-community/plamo-2-translate \
      --trust-remote-code \
      --chat-template '${chatTemplate}' \
      --host 127.0.0.1 \
      --port 18080
  '';
in {
  launchd.user.agents.mlx-lm-server = {
    serviceConfig = {
      ProgramArguments = [
        "${mlxLmServer}"
      ];
      WorkingDirectory = homeDirectory;
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${homeDirectory}/Library/Logs/mlx-lm-server.stdout.log";
      StandardErrorPath = "${homeDirectory}/Library/Logs/mlx-lm-server.stderr.log";
      EnvironmentVariables = {
        HOME = homeDirectory;
        HF_HOME = huggingFaceHome;
        TRANSFORMERS_CACHE = transformersCache;
        UV_CACHE_DIR = uvCacheDir;
      };
    };
  };
}
