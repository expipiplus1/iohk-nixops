with (import ./../lib.nix);

{
  network.description = "IOHK infrastructure";

  hydra = { config, pkgs, resources, ... }: {

    imports = [
      ./../modules/amazon-base.nix
      ./../modules/datadog.nix
    ];

    services.dd-agent.tags = ["env:production"];

    deployment.ec2 = {
      # 16G memory
      instanceType = mkForce "r3.large";
      ebsInitialRootDiskSize = mkForce 200;
      elasticIPv4 = resources.elasticIPs.hydra-ip;
      associatePublicIpAddress = true;
    };
  };

  cardano-deployer = { config, pkgs, resources, ... }: {
    imports = [
      ./../modules/common.nix
      ./../modules/amazon-base.nix
      ./../modules/datadog.nix
      ./../modules/papertrail.nix
    ];

    services.dd-agent.tags = ["env:production"];

    deployment.ec2 = {
      # 16G memory needed for 100 nodes evaluation
      instanceType = mkForce "r3.large";
      ebsInitialRootDiskSize = mkForce 50;
      elasticIPv4 = resources.elasticIPs.cardanod-ip;
      associatePublicIpAddress = true;
      ami = mkForce "ami-01f7306e";
    };
  };

  resources = {
    inherit ec2KeyPairs;
    elasticIPs = {
      hydra-ip = { inherit region accessKeyId; };
      cardanod-ip = { inherit region accessKeyId; };
    };
  };
}
