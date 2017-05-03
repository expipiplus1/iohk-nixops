with (import ./../lib.nix);

let
  timeWarpReceiver = { pkgs, ... }: {
    imports = [ ./../modules/timewarp-node.nix . ];
    services.timewarp-node.enable = true;
    networking.firewall.enable = mkForce false;
  };
  timeWarpSender = { pkgs, ... }: {
    imports = [ timeWarpReceiver ];
    services.timewarp-node.sender = true;
  };
  snd-node-eu = timeWarpSender "eu-central-1" (pairs: pairs.cardano-test-eu-central);
  rcv-node-eu = timeWarpReceiver "eu-central-1" (pairs: pairs.cardano-test-eu-central);
  rcv-node-us = timeWarpReceiver "us-west-1" (pairs: pairs.cardano-test-us);
  rcv-node-asia = timeWarpReceiver "ap-southeast-1" (pairs: pairs.cardano-test-asia);
  rcv-node-sydney = timeWarpReceiver "ap-southeast-2" (pairs: pairs.cardano-test-sydney);
  rcv-node-sa = timeWarpReceiver "sa-east-1" (pairs: pairs.cardano-test-sa);
in {
  network.description = "TimeWarp experiments";

  timewarp0 = timeWarpSender;
  timewarp1 = timeWarpReceiver;
  timewarp2 = timeWarpReceiver;
  timewarp3 = timeWarpReceiver;
  timewarp4 = timeWarpReceiver;
}
