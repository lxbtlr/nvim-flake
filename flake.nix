# flake.nix
{
  description = "Baby's first flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };
  outputs = { self, nixpkgs, neovim }:
    let
      overlayFlakeInputs = prev: final: {
        neovim = neovim.packages.x86_64-linux.neovim;
      };

      overlayMynvim = prev: final: {
        mynvim = import ./packages/mynvim.nix {
          pkgs = final;
        };
      };

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ overlayFlakeInputs overlayMynvim ];
      };

    in {
      packages.x86_64-linux.default = pkgs.mynvim;
      apps.x86_64-linux.default = {
        type = "app";
        program = "${pkgs.mynvim}/bin/nvim";
      };
  };
}
