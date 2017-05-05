{ config, pkgs, lib, resources, ... }:

with (import ./../lib.nix);

optionalAttrs (generatingAMI == false) {
 deployment.targetEnv = "ec2";
 deployment.ec2.instanceType = mkDefault "t2.large";
 deployment.ec2.region = mkDefault region;
 deployment.ec2.keyPair = mkDefault resources.ec2KeyPairs.cardano-test-eu-central;
 deployment.ec2.securityGroups = mkDefault ["cardano-deployment"];
 deployment.ec2.ami = mkDefault (import ./../modules/amis.nix).${config.deployment.ec2.region};
 deployment.ec2.accessKeyId = mkDefault "cardano-deployer";
 deployment.ec2.ebsInitialRootDiskSize = mkDefault 30;
}
