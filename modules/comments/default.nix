{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.vim.comments;
in
{
  options.vim.comments = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable comments plugin";
    };

    type = mkOption {
      default = "nerdcommenter";
      description = "Set the comments plugin. Options: [nerdcommenter] [kommentary]";
      type = types.enum [ "nerdcommenter" "kommentary" ];
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg: if cond then msg else "";
    in
    {
      vim.startPlugins = [ pkgs.neovimPlugins.${cfg.type} ];
        /* if (cfg.type == "kommentary")
        then [ pkgs.neovimPlugins.${cfg.type} ]
        else [ pkgs.vimPlugins.${cfg.type} ]; */

      vim.luaConfigRC = ''
        ${writeIf (cfg.type == "kommentary") ''
          -- Kommentary config
          require('kommentary.config').setup();
          require('kommentary.config').configure_language("nix", {
              single_line_comment_string = "#",
          })
          ''
        }
      '';
    }
  );
}
