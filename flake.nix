{
  description = "Public DOH Servers";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      defaultPackage = self.packages.default;

      packages = {
        default = self.packages.${system}.public_doh_servers;

        public_doh_servers = nixpkgs.legacyPackages.${system}.callPackage self {
          src = self;
        };
      };
    });
}
