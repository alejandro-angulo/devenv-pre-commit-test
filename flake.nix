{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";

    patched-pre-commit-hooks.url = "github:alejandro-angulo/pre-commit-hooks.nix/prevent-copies";
    devenv.inputs.pre-commit-hooks.follows = "patched-pre-commit-hooks";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  languages.javascript = {
                    enable = true;
                    npm.install.enable = true;
                  };

                  pre-commit = {
                    hooks.prettier.enable = true;
                    settings.prettier = {
                      binPath = ./node_modules/.bin/prettier;
                      skipBinCopy = true;
                    };
                  };

                  enterShell = ''
                    export PATH=./node_modules/.bin:$PATH
                  '';
                }
              ];
            };
          });
    };
}
