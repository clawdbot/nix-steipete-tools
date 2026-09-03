{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.39.0/gogcli_0.39.0_darwin_arm64.tar.gz";
      hash = "sha256-Mtd8bjXwC+SOlmPBlhi0lHsTmO6H/xo68evFTqtsa/8=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.39.0/gogcli_0.39.0_linux_amd64.tar.gz";
      hash = "sha256-dhALzhPJdrCs88cXKg5S1MBtqVreQvYgrVdwfNUy8+g=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.39.0/gogcli_0.39.0_linux_arm64.tar.gz";
      hash = "sha256-BAmE44KR2i8j3e771nNxxb8y3mvjF31PWoFvf+UbrLc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.39.0";

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
