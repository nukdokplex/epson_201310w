{
  description = "";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-24.05";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = import ./default.nix { inherit pkgs; };
    };
}
