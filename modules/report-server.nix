{ config, pkgs, lib, ... }:

with (import ./../lib.nix);

let
  report-server = (import ./../default.nix {}).cardano-report-server-static;
  cfg = config.services.report-server;
in {
  options = {
    services.report-server = {
      port = mkOption { type = types.int; default = 8080; };
      logsdir = mkOption { type = types.path; default = "/var/lib/report-server"; };
    };
  };

  config = {

    imports = [ ./common.nix ];
    users = {
      users.report-server = {
        group = "report-server";
        home = cfg.logsdir;
        createHome = true;
      };
      groups.report-server = {};
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.report-server = {
      description   = "";
      after         = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "report-server";
        Group = "report-server";
        ExecStart = ''
          ${report-server}/bin/cardano-report-server -p ${toString cfg.port} --logsdir ${cfg.logsdir}
        '';
      };
    };
  };
}
