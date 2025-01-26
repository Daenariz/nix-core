{ config, lib, ... }:

let
  cfg = config.services.rss-bridge;
  fqdn = "${cfg.subdomain}.${config.networking.domain}";

  inherit (lib) mkIf mkOption types;
in
{
  options.services.rss-bridge = {
    subdomain = mkOption {
      type = types.str;
      default = "rss";
      description = "Subdomain for Nginx virtual host.";
    };
    forceSSL = mkOption {
      type = types.bool;
      default = true;
      description = "Force SSL for Nginx virtual host.";
    };
  };

  config = mkIf cfg.enable {
    services.rss-bridge = {
      virtualHost = fqdn;
      config = {
        system.enabled_bridges = [ "*" ];
      };
    };

    systemd.tmpfiles.rules = [ "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} -" ];

    services.nginx.virtualHosts."${fqdn}" = {
      forceSSL = cfg.forceSSL;
      enableACME = cfg.forceSSL;
    };
  };
}
