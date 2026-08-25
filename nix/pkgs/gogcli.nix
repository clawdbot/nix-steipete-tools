{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.0/gogcli_0.38.0_darwin_arm64.tar.gz";
      hash = "sha256-G/9BDbJDd9fgqSkExYmMDX4dbZSHWr/y2ENTW8IYCjg=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.0/gogcli_0.38.0_linux_amd64.tar.gz";
      hash = "sha256-GaZ+pWdpUQ/QT+HGb8tCs618+cwdIjKNH0Vi/PBAg7I=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.0/gogcli_0.38.0_linux_arm64.tar.gz";
      hash = "sha256-bKmD7vWi/9EPw5dj1jBrYyBIG5WnbHWGJ606nmsu38w=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.38.0";

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
