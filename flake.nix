{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    markedpp.url = "github:commenthol/markedpp";
    markedpp.flake = false;
  };

  outputs = { self, nixpkgs, markedpp }:
    let
      allSystems = [ "x86_64-linux" ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.buildNpmPackage {
          name = "markedpp";
          src = markedpp;

          buildInputs = with pkgs; [
            nodejs_18
          ];

          npmDepsHash = "sha256-++NbF4W79mfTThCNGbLMjwgciOlhLGyBeGzEtNhg8lE=";

          prePatch = ''
            cp ${./package-lock.json} ./package-lock.json
          '';

          dontNpmPrune = true;
        };
      });
    };
}
