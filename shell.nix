{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = [ pkgs.buildPackages.love pkgs.zip pkgs.unzip ];
}
