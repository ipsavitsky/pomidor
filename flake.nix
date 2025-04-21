{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    dlang-tools.url = "github:ipsavitsky/dlang-tools";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      dlang-tools,
      treefmt-nix,
    }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      treefmtModule = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
    in
    {
      formatter.x86_64-linux = treefmtModule.config.build.wrapper;
      packages.x86_64-linux = rec {
        default = pomidor;
        pomidor = pkgs.buildDubPackage {
          pname = "pomidor";
          version = "0.1.0";
          src = ./.;
          dubLock = ./nix/dub-lock.json;
          buildInputs = [ pkgs.ncurses ];
          compiler = pkgs.dmd;
          installPhase = ''
            runHook preInstall
            install -Dm755 pomidor -t $out/bin
            runHook postInstall
          '';
        };
      };

      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            dub-to-nix
            ncurses
            dmd
            dub
            fd
            serve-d
            dlang-tools.packages.x86_64-linux.dscanner
            dlang-tools.packages.x86_64-linux.dfmt
          ];
        };
      };
    };
}
