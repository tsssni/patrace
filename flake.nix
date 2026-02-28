{
  description = "metatron devenv";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      lib = nixpkgs.lib;

      systems = [ "x86_64-linux" ];

      systemAttrs = f: system: { ${system} = f system; };

      mapSystems = f: systems |> lib.map (systemAttrs f) |> lib.mergeAttrsList;

      packages = mapSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              android_sdk.accept_license = true;
              permittedInsecurePackages = [
                "gradle-6.9.4"
              ];
            };
          };
        in
        {
          default = pkgs.callPackage ./nix { };
        }
      );

      devShells = mapSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          clangd = pkgs.mkShell {
            shellHook = ''
              export SHELL=nu
            '';
            packages = with pkgs; [
              clang-tools
            ];
          };
        }
      );
    in
    {
      inherit packages devShells;
    };
}
