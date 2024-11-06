{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  dmenu = pkgs.dmenu.override {
    patches = [
      ./patches/center.diff
      ./patches/gruvbox.diff
    ];
  };
  dwl = pkgs.dwl.overrideAttrs (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
      pkgs.fcft
      pkgs.libdrm
      pkgs.wayland-protocols
      pkgs.xorg.libX11
      pkgs.xorg.libXinerama
      pkgs.cairo
      pkgs.pango
    ];
    patches = (oldAttrs.patches or [ ]) ++ [
      ./dwl-patch/alwayscenter.patch
      ./dwl-patch/attachbottom.patch
      ./dwl-patch/gaps.patch
      ./dwl-patch/focusdir.patch
      # ./dwl-patch/ipc.patch
    ];
    prePatch = ''
      cp ${./dwl-conf.h} config.def.h
    '';
  });
in
{
  home.username = "pita";
  home.homeDirectory = "/home/pita";

  home.stateVersion = "24.05";

  imports = [
    ./configs/init.nix
  ];

  home.packages = [
    dmenu
  ];
  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    SHELL = "fish";
    XCURSOR_THEME = "GoogleDot-White";
    XCURSOR_SIZE = "24";
    XDG_CURSOR_THEME = "GoogleDot-White";
  };
  programs = {
    home-manager = {
      enable = true;
    };
    wezterm = {
      enable = true;
    };
    kitty = {
      enable = true;
    };
    foot = {
      enable = true;
    };
    btop = {
      enable = true;
    };
  };
  services = {
    dunst = {
      enable = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
}
