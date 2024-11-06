{ pkgs, ... }:

{

  home.packages = [

    pkgs.zls
    pkgs.nixd
    pkgs.lua-language-server
  ];
}
