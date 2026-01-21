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

  toSDLValue =
    v:
    if isString v then
      "\"${v}\""
    else if isBool v then
      (if v then "true" else "false")
    else if isInt v then
      toString v
    else
      throw "Unsupported value type: ${builtins.typeOf v}";

  toSDLSection =
    name: attrs:
    concatStringsSep "\n" (
      [ "${name} {" ] ++ (mapAttrsToList (k: v: "  ${k} ${toSDLValue v}") attrs) ++ [ "}" ]
    );

  generateSDL =
    name: settings:
    pkgs.writeText name (
      concatStringsSep "\n\n" (
        mapAttrsToList (k: v: if isAttrs v then toSDLSection k v else "${k} ${toSDLValue v}") settings
      )
    );
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
      type = types.attrs;
      default = { };
      example = literalExpression ''
        {
          type = "native";
          split = "short";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."pomidor/config.sdl" = mkIf (cfg.settings != { }) {
      source = generateSDL "config.sdl" cfg.settings;
    };
  };
}
