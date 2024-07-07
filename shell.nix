let
  # try to keep this in line with Norsk
  pinnedNixHash = "57610d2f8f0937f39dbd72251e9614b1561942d8";
  pinnedNix =
    builtins.fetchGit {
      name = "nixpkgs-pinned";
      url = "https://github.com/NixOS/nixpkgs.git";
      rev = "${pinnedNixHash}";
    };

  nixpkgs =
    import pinnedNix {};

in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    nodejs-18_x
    nodePackages.typescript-language-server
    nodePackages."@tailwindcss/language-server"
    nodePackages.vscode-langservers-extracted
    esbuild # presumably we can get this from NPM too???
    rsync
    yq-go
   ];

}

