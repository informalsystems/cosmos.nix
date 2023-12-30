{inputs, ...}: {
  flake.packages."x86_64-linux" = {
      aarch64-linux-vm =
        let pkgs-x86_64 = inputs.nixpkgs.legacyPackages."x86_64-linux";
            pkgs-aarch64 = inputs.nixpkgs.legacyPackages."aarch64-linux";
            drive-flags = "format=raw,readonly=on";
        in pkgs-x86_64.writeScriptBin "run-nixos-vm-aarch64" ''

        #!${pkgs-x86_64.runtimeShell} \
        ${pkgs-x86_64.qemu_full}/bin/qemu-system-aarch64 \
        -machine virt \
        -cpu cortex-a57 \
        -m 40G \
        -nographic \
        -drive if=pflash,file=${pkgs-aarch64.OVMF.fd}/AAVMF/QEMU_EFI-pflash.raw,${drive-flags} \
        -drive file=${inputs.self.packages."x86_64-linux".aarch64-linux-iso}/iso/nixos.iso,${drive-flags}
        '';

      aarch64-linux-iso =
        let aarch64-iso-module = {pkgs, lib, ...}: {
              system.stateVersion = "23.05";
              nixpkgs.buildPlatform.system = "x86_64-linux";
              nixpkgs.hostPlatform.system = "aarch64-linux";

              boot.loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
                timeout = lib.mkForce 0;
              };

              users.users.test = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
                initialPassword = "test";
              };
  
              nix = {
                package = pkgs.nixFlakes;
                settings = {
                  experimental-features = ["nix-command" "flakes"];
                };
              };

              environment.systemPackages = with pkgs; [
                vim
                htop
                postgresql_16
              ];

              services.getty.autologinUser = "root";
            };
        in inputs.nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "iso";
          modules = [ aarch64-iso-module ];
      };
    };
  }
