{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.1/gogcli_0.38.1_darwin_arm64.tar.gz";
      hash = "sha256-utaGhwlNK6A007LDae8uYIziM/W203UssFUIsMSb1QI=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.1/gogcli_0.38.1_linux_amd64.tar.gz";
      hash = "sha256-ZXaCjtaFKUm6QkuWfD/0Jos9nJDiAfkP49U5/joVHrs=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.38.1/gogcli_0.38.1_linux_arm64.tar.gz";
      hash = "sha256-RiNCVCRy3PNhdEz+XhWjVANktMUSBXfkUZ//vRr8ZZY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.38.1";

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
