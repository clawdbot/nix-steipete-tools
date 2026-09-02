{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.2/gogcli_0.38.2_darwin_arm64.tar.gz";
      hash = "sha256-F5ZhetPF7VKQyJ0zu7OZ0bndWZPwqlq7rwvgrqudAp0=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.2/gogcli_0.38.2_linux_amd64.tar.gz";
      hash = "sha256-2CcksXe0r/ii+gsKsYqyvQDSbg5XQfozGhe2bF4fZP4=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.2/gogcli_0.38.2_linux_arm64.tar.gz";
      hash = "sha256-zJwY/NRBxTltu81F6WzRbh9NHLdouUjmueCLgubqT4E=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.38.2";

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
