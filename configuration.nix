# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.overlays = [
    (final: prev: {
      openslides-manage-service = final.callPackage ./packages/openslides-manage-service.nix {};
    })
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  boot.loader.grub.forceInstall = true;
  boot.loader.timeout = 10;

  networking.hostName = "joshuabaker"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "US/Denver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joshua = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYEtwhOUhooRNQ2KX/tQOyjQ+H3xRQcl87B2gGk3yp2 joshua@Joshua-PC-Nix"
    ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    inetutils
    mtr
    openslides-manage-service
    sysstat
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    X11Forwarding = true;
  };

  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  virtualisation.docker.enable = true;

  services.httpd = {
    enable = true;
    virtualHosts = {
      "joshuabaker.me" = {
        addSSL = true;
        enableACME = true;
        globalRedirect = "https://www.joshuabaker.me/";
      };
      "www.joshuabaker.me" = {
        documentRoot = "/var/www/html";
        enableACME = true;
        forceSSL = true;
      };
      "files.joshuabaker.me" = {
        documentRoot = "/var/www/files";
        enableACME = true;
        forceSSL = true;
      };
      "keepass.joshuabaker.me" =
      let
        databasesDir = "/files/keepass";
      in
        {
          documentRoot = "/files/keeweb";
          enableACME = true;
          forceSSL = true;

          extraConfig = ''
            DavLockDB /var/run/httpd/DavLockDB
            <Directory ${databasesDir}>
              DAV On
              Header always set Access-Control-Allow-Origin "https://app.keeweb.info"
              Header always set Access-Control-Allow-Methods "*"
              Header always set Access-Control-Allow-Headers "Authorization, Cache-Control"
              DirectoryIndex disabled
            </Directory>
          '';

          locations."/basic" = {
            alias = databasesDir;
            extraConfig = ''
              AuthType Basic
              AuthName "keepass"
              AuthBasicProvider file
              AuthUserFile ${config.age.secrets.keepass-basic.path}
              Require valid-user
              AliasPreservePath on
            '';
          };
          locations."/digest" = {
            alias = databasesDir;
            extraConfig = ''
              AuthType Digest
              AuthName "keepass"
              AuthUserFile ${config.age.secrets.keepass-digest.path}
              Require valid-user
              AliasPreservePath on
            '';
          };
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;

  security.acme = {
    acceptTerms = true;
    defaults.email = "joshuakb2@gmail.com";
  };

  age.secrets.keepass-basic = {
    file = ./secrets/keepass-basic.age;
    group = "wwwrun";
    mode = "440";
  };
  age.secrets.keepass-digest = {
    file = ./secrets/keepass-digest.age;
    group = "wwwrun";
    mode = "440";
  };
  age.identityPaths = [ "/root/.ssh/id_ed25519" ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

