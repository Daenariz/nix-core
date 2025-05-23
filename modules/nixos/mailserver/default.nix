{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mailserver;
  fqdn = "${cfg.subdomain}.${config.networking.domain}";

  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;

  isNotEmptyStr = (import ../../../lib).isNotEmptyStr; # FIXME: cannot get lib overlay to work
in
{
  imports = [ inputs.nixos-mailserver.nixosModules.mailserver ];

  options.mailserver = {
    subdomain = mkOption {
      type = types.str;
      default = "mail";
      description = "Subdomain for rDNS";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = isNotEmptyStr cfg.subdomain;
        message = "nix-core/nixos/mailserver: config.mailserver.subdomain cannot be empty.";
      }
    ];

    mailserver = {
      inherit fqdn;

      domains = mkDefault [ config.networking.domain ];
      certificateScheme = mkDefault "acme-nginx";
    };

    environment.systemPackages = [ pkgs.mailutils ];
  };
}
