{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
      };
    };
    joshbooks = {
      url = "github:joshuakb2/joshbooks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      agenix,
      joshbooks,
      ...
    }:
    {
      nixosConfigurations.joshuabaker = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
          joshbooks.nixosModules.default
          ./configuration.nix
        ];
      };
    };
}
