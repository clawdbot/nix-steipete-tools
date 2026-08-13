{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.36.0/gogcli_0.36.0_darwin_arm64.tar.gz";
      hash = "sha256-XLW1IQh5dpvGoCvZzzntGw3j8HE7OX7L3e/pXdK+YYs=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.36.0/gogcli_0.36.0_linux_amd64.tar.gz";
      hash = "sha256-spD8/pB3iaHvtoWpM24qbH+VmMPACq2o1sQ37ryGyJE=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.36.0/gogcli_0.36.0_linux_arm64.tar.gz";
      hash = "sha256-9o48Nck2TepaTlFdE6I6sw3tRkAckNieKVPco5XX/kI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.36.0";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp gog "$out/bin/gog"
    chmod 0755 "$out/bin/gog"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Google CLI for Gmail, Calendar, Drive, and Contacts";
    homepage = "https://github.com/openclaw/gogcli";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "gog";
  };
}
