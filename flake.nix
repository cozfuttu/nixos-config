{
  description = "FuttuOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    username = "cozfuttu";
    host = "msi";
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
     "${host}" = nixpkgs.lib.nixosSystem {
        specialArgs = { 
	  inherit inputs;
	  inherit username;
	  inherit host;
	  inherit system;
	};
        modules = [
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/${host}/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
	    home-manager.extraSpecialArgs = {
	      inherit inputs;
	      inherit username;
	      inherit host;
	    };
          }
          inputs.stylix.nixosModules.stylix
        ];
      };
    };
  };
}
