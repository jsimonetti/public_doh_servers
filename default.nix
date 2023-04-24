{ pkgs ? import <nixpkgs> { }
, src ? ./.
}:


pkgs.stdenv.mkDerivation {
  name = "public_doh_servers";
  inherit src;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir $out;
    cp $src/*.list $out;
    cp $src/*.set $out;
  '';
}
