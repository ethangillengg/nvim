# Shell for bootstrapping flake-enabled nix and other tooling
# { pkgs,  ... }: {
#   default = pkgs.mkShell {
#     nativeBuildInputs = with pkgs; [
#       lua-language-server
#       stylua
#       git
#     ];
#   };
# }

{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [pkgs.bashInteractive];
        buildInputs = with pkgs; [
          lua-language-server
          stylua
        ];

      };
    });
}
