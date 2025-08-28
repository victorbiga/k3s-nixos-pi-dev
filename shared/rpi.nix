{ config, pkgs, lib, ... }:

let
  rpiVersion = config.raspberry-pi-nix.board;
in
{
  # Boot settings
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_rpi;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelParams = [
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
    ];
    kernelModules = [ "rbd" ];
  };

  # Raspberry Pi specific settings
  hardware.raspberry-pi.fkms-3d.enable = true;

  # Conditionally import settings based on Raspberry Pi version
  imports = [
    (lib.mkIf (rpiVersion == "bcm2711") ./rpi4.nix)
    (lib.mkIf (rpiVersion == "bcm2712") ./rpi5.nix)
  ];
}