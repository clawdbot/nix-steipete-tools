{ lib, stdenv, fetchurl, ffmpeg }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/camsnap/releases/download/v0.4.1/camsnap_0.4.1_darwin_arm64.tar.gz";
      hash = "sha256-njQ4AXcOSgjqt+5Mrd09ETKb0+NhSf1cqmzjb9aHZGM=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/camsnap/releases/download/v0.4.1/camsnap_0.4.1_linux_amd64.tar.gz";
      hash = "sha256-xFnceN2IuL0J9i80a4oAdmi1kiBCDGH25m5YVDT95kw=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/camsnap/releases/download/v0.4.1/camsnap_0.4.1_linux_arm64.tar.gz";
      hash = "sha256-EFsAsyfLLyIVqEGXYApJH/9VMdkn0ovYjL879f/tWIQ=";
    };
  };
in
stdenv.mkDerivation {
  pname = "camsnap";
  version = "0.4.1";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/camsnap"
    cp $(find . -type f -name camsnap | head -1) "$out/bin/camsnap"
    chmod 0755 "$out/bin/camsnap"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/camsnap/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/camsnap/"
    fi
    runHook postInstall
  '';

  propagatedBuildInputs = [ ffmpeg ];

  meta = with lib; {
    description = "One command to grab frames, clips, or motion alerts from RTSP/ONVIF cams";
    homepage = "https://github.com/steipete/camsnap";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "camsnap";
  };
}
