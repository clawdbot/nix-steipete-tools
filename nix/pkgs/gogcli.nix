{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.3/gogcli_0.38.3_darwin_arm64.tar.gz";
      hash = "sha256-G0Cun426Rb7TpZtVpw+UP6shDiSOm0sdTDY+/nRKED8=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.3/gogcli_0.38.3_linux_amd64.tar.gz";
      hash = "sha256-UaKRYpsa9hH9Zgi9O1SXh7ElGa5uQl5jUvoQW3TQQi0=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.3/gogcli_0.38.3_linux_arm64.tar.gz";
      hash = "sha256-5nGU3eRXGMl3r/M4cLfY/KxpfF7+iy4ONw/xxMNJqyc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.38.3";

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
