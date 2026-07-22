# disko-config.nix – disk layout for NixOS
# Works with both BIOS (Legacy) and UEFI, using GPT.
# WARNING: This will DESTROY ALL DATA on the target disk!

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # Device will be passed via --disk argument at runtime.
        # Example: --disk main /dev/vda
        content = {
          type = "gpt";
          partitions = {
            # 1 MiB BIOS boot partition (for GRUB on BIOS+GPT)
            # Only needed if you boot in legacy BIOS mode.
            bios-boot = {
              size = "1M";
              type = "EF02";   # GPT partition type for BIOS boot
            };

            # 1 GiB EFI System Partition (ESP) – required for UEFI
            esp = {
              size = "1G";
              type = "EF00";   # GPT partition type for ESP
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            # 10 GiB swap partition
            swap = {
              size = "10G";
              content = {
                type = "swap";
                # resumeDevice = true; # uncomment if you want hibernation support
              };
            };

            # Root partition – takes the rest of the disk
            root = {
              size = "100%";    # all remaining space
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
