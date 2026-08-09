{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.35.0/gogcli_0.35.0_darwin_arm64.tar.gz";
      hash = "sha256-BoGMUKEiLJs0RpCljWuo0HX3vimu7YJb0XdBuuJzSDM=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.35.0/gogcli_0.35.0_linux_amd64.tar.gz";
      hash = "sha256-xOfjScU9PmnjZynUMVoOCAqFpLR2eoSUPwdQZ5Mby98=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.35.0/gogcli_0.35.0_linux_arm64.tar.gz";
      hash = "sha256-bbJCkEdB4oDl5i/5JJ/nbAdbrVzGwG2EHgEWIoA9zjQ=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.35.0";

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
