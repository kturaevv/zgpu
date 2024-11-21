{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    fzf # find * -type f | fzf > selected
    zig
    rustc
    cargo
    llvmPackages.libclang
    llvmPackages.clang     # Full clang
  ];

  shellHook = ''
    # Point bindgen to the correct libclang
    export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"
    # Help bindgen find clang
    export BINDGEN_EXTRA_CLANG_ARGS="-I${pkgs.llvmPackages.libclang.lib}/lib/clang/${pkgs.llvmPackages.libclang.version}/include"
    '';
  }
