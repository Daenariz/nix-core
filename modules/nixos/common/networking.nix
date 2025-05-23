{ config, lib, ... }:

let
  inherit (lib) mkDefault;

  isNotEmptyStr = (import ../../../lib).isNotEmptyStr; # FIXME: cannot get lib overlay to work
in
{
  config = {
    assertions = [
      {
        assertion = isNotEmptyStr config.networking.domain;
        message = "nix-core/nixos/common: config.networking.domain cannot be empty.";
      }
      {
        assertion = isNotEmptyStr config.networking.hostName;
        message = "nix-core/nixos/common: config.networking.hostName cannot be empty.";
      }
    ];

    networking = {
      domain = mkDefault "${config.networking.hostName}.local";

      # NetworkManager
      useDHCP = false;
      wireless.enable = false;
      networkmanager.enable = true;
    };
  };
}
