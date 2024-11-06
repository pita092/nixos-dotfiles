{
  # config,
  pkgs,
  inputs,
  # lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.targets.chromium.enable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.image = ./configs/nixgruvbox.png;
  stylix.polarity = "dark";
  stylix.cursor = {
    package = pkgs.google-cursor;
    name = "GoogleDot-White";
    size = 12;
  };
  stylix.fonts = {
    sizes = {
      terminal = 14;
    };
    monospace = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };

    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  stylix.targets.gtk.enable = true;
  stylix.targets.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "pita" = import ./home.nix;
    };
  };

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  programs.fish.enable = true;
  users.users.pita = {

    shell = pkgs.fish;
  };
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      dmenu
    ];
    fontconfig.enable = true;
  };

  hardware.enableAllFirmware = true;

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  systemd.tmpfiles.rules = [
    "d /var/empty/local/share/man/man1 0755 root root -"
  ];

  nix = {
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Bootloader.

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IL";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "he_IL.UTF-8";
    LC_IDENTIFICATION = "he_IL.UTF-8";
    LC_MEASUREMENT = "he_IL.UTF-8";
    LC_MONETARY = "he_IL.UTF-8";
    LC_NAME = "he_IL.UTF-8";
    LC_NUMERIC = "he_IL.UTF-8";
    LC_PAPER = "he_IL.UTF-8";
    LC_TELEPHONE = "he_IL.UTF-8";
    LC_TIME = "he_IL.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pita = {
    isNormalUser = true;
    description = "pita";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "input"
    ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    clang
    clang-tools
    git
    xorg.libX11
    gtk4
    gtk4-layer-shell
    wlroots
    libinput
    wayland
    libxkbcommon
    wayland-protocols
    pkg-config
    xorg.libxcb
    xwayland

  ];

  # environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  # 	services.xserver = {
  # 		enable = true;
  #
  # 		desktopManager = {
  # 			xterm.enable = false;
  # 		};
  #
  # 		displayManager = {
  # 			defaultSession = "none+i3";
  # 		};
  #
  # 		windowManager.i3 = {
  # 			enable = true;
  # 			extraPackages = with pkgs; [
  # 				i3status # gives you the default i3 status bar
  # 					i3lock #default i3 screen locker
  # 					i3blocks #if you are planning on using i3blocks over i3status
  # 			];
  # 		};
  # 	};

  # services.xserver = {
  #  enable = true;
  #
  #  desktopManager = {
  #   xterm.enable = false;
  #  };
  #  displayManager = {
  #   defaultSession = "none+i3";
  #  };
  #  windowManager.i3 = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  # 	  dmenu
  # 		  i3status
  # 		  i3lock
  # 		  i3blocks
  #   ];
  #  };
  # };

  # enable Sway window manager

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    dbus.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
  };

  # programs.hyprland = {
  # 	enable = true;
  # 	xwayland.enable = true;
  # };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "video=DP-3:1920x1080@144"
  ];
  environment.sessionVariables = {
    PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig:$PKG_CONFIG_PATH";
    XDG_CURSOR_THEME = "GoogleDot-Black";
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };
  system.stateVersion = "24.05"; # Did you read the comment?
}
