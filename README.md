Flake for [imput's Helium browser](https://helium.computer/)

The source is kept up to date via a Github Action.

# Usage

```nix
helium-browser = {
  url = "github:imxyy1soope1/helium-browser-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

```nix
environment.systemPackages = [
  inputs.helium-browser.packages."${pkgs.stdenv.hostPlatform.system}".helium
];
```

# Binary Cache

This repository sets up a experimental binary cache via a GitHub Action. If you want to use the binary cache,
add this to your `nix.conf`:

```conf
extra-substituters = [other substituters...] https://imxyy1soope1.github.io/helium-browser-flake
extra-trusted-public-keys = [other public keys...] imxyy-soope-helium-1:kR7+fAmD9WhTFzUA+55rZ5bE5vhb8zmJrOJC1IE+C7Y=
```

Or:

```nix
nix.settings = {
  extra-substituters = [ "https://imxyy1soope1.github.io/helium-browser-flake" ];
  extra-trusted-public-keys = [ "imxyy-soope-helium-1:kR7+fAmD9WhTFzUA+55rZ5bE5vhb8zmJrOJC1IE+C7Y=" ];
};
```
