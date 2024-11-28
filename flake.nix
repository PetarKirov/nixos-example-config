{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            docker-client
            opentofu
            kubectl
            jq
            nixos-rebuild
          ];
        };

        packages.get-disk-usage = pkgs.writeShellScriptBin "get-disk-usage" ''
          du -sh /etc
        '';

        packages.hello-python = pkgs.writers.writePython3Bin "hello-python" {} ''
          print("Hello from Python")
        '';
      };

      flake = {
        nixosConfigurations.example-nixos-config = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
