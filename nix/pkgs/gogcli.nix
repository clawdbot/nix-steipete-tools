{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.37.0/gogcli_0.37.0_darwin_arm64.tar.gz";
      hash = "sha256-ihwMLAJk/cYCzOULREMeEFaSafmOBUq1UDPGUqlrfGE=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.37.0/gogcli_0.37.0_linux_amd64.tar.gz";
      hash = "sha256-kF/tC/q6+l3ecYnlBkKz+jHX/EqtUKjSfSuSBx2HWWI=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.37.0/gogcli_0.37.0_linux_arm64.tar.gz";
      hash = "sha256-Sr3pDE50zrEl8/3Ydnb/eVjon3ggl4/6Ed4mruBuchw=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.37.0";

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
