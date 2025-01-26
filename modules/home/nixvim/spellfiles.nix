{ config, pkgs, ... }:

let
  spellDir = config.xdg.dataHome + "/nvim/site/spell";
in
{
  home.file = {
    de-spl = {
      enable = true;
      source = pkgs.fetchurl {
        url = "http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl";
        sha256 = "sha256-c8cQfqM5hWzb6SHeuSpFk5xN5uucByYdobndGfaDo9E=";
      };
      target = spellDir + "/de.utf8.spl";
    };
    de-sug = {
      enable = true;
      source = pkgs.fetchurl {
        url = "http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.sug";
        sha256 = "sha256-E9Ds+Shj2J72DNSopesqWhOg6Pm6jRxqvkerqFcUqUg=";
      };
      target = spellDir + "/de.utf8.sug";
    };
  };
}
