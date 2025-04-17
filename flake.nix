{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
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
          ];
        };
      };
  };
}
