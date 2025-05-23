{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.wayland.windowManager.hyprland;
  app = cfg.applications.matrix-client.default;

  inherit (lib) mkIf;
in
{
  config = mkIf (cfg.enable && app == "element-desktop") {
    home.packages = [ pkgs.element-desktop ];
  };
}
