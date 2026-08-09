{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/poltergeist/releases/download/v2.1.6/poltergeist-macos-universal-v2.1.6.tar.gz";
      hash = "sha256-UGTmV9hEU6T3eBNEsDKT4G3WG8KHZjCsMrx7WIGi8Nc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "poltergeist";
  version = "2.1.6";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp poltergeist "$out/bin/poltergeist"
    cp polter "$out/bin/polter"
    chmod 0755 "$out/bin/poltergeist" "$out/bin/polter"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Universal file watcher with auto-rebuild for any language or build system";
    homepage = "https://github.com/steipete/poltergeist";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "poltergeist";
  };
}
