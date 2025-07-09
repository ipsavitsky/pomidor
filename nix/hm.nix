{ pomidor }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.pomidor;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.pomidor = {
    enable = mkEnableOption "pomidor";

    package = mkOption {
      type = types.package;
      default = pomidor;
      description = "The pomidor package to install";
    };

    settings = mkOption {
      type = tomlFormat.type;
      default = {};
      example = literalExpression ''
        [ntfy]
        topic = "topic123"
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."pomidor/config.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "config.toml" cfg.settings;
    };
  };
}
