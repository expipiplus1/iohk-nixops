{ config, pkgs, lib, ... }:

with (import ./../lib.nix);

{
  options = {
  };

  config = {
    services.cardano-node = {
      executable = "${(import ./../default.nix {}).cardano-sl-explorer-static}/bin/cardano-explorer";
      autoStart = true;
    };

    imports = [ ./common.nix ];

    networking.firewall.allowedTCPPorts = [
      80 # nginx
      8110 # websocket
    ];

    services.nginx = {
      enable = true;
      virtualHosts = {
        "explorer.iohkdev.io" = {
          # TLS provided by cloudfront
          locations = {
            "/" = {
              # TODO: one day we'll build purescript with Nix!
              # but today, this is built by ./scripts/generate-explorer-frontend.sh
              root = ./../cardano-sl-explorer/frontend/dist;
              # Serve static files or fallback to browser history api
              tryFiles = "$uri /index.html";
            };
            "/api/".proxyPass = "http://localhost:8100";
          };
          # Otherwise nginx serves files with timestamps unixtime+1 from /nix/store
          extraConfig = ''
            if_modified_since off;
            add_header Last-Modified "";
            etag off;
          '';
        };
      };
    };
  };
}
