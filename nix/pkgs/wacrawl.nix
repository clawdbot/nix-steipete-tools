{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.3.7/wacrawl_0.3.7_darwin_arm64.tar.gz";
      hash = "sha256-YHvADxiJEV6xAL5fqXcvvOWg+pu1pHCAZgdfYPH+o7g=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.3.7/wacrawl_0.3.7_linux_amd64.tar.gz";
      hash = "sha256-n/7XYywefLtiuu/gnVoFa91HkFAoSTgtW21Anrl2WKI=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.3.7/wacrawl_0.3.7_linux_arm64.tar.gz";
      hash = "sha256-qaXjCLgIMYu76wiGyxnnNFtU4Xe8nAQx4uiFcmYNIx8=";
    };
  };
in
stdenv.mkDerivation {
  pname = "wacrawl";
  version = "0.3.7";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/wacrawl"
    cp $(find . -type f -name wacrawl | head -1) "$out/bin/wacrawl"
    chmod 0755 "$out/bin/wacrawl"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/wacrawl/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/wacrawl/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Read-only local archive and search for WhatsApp Desktop data";
    homepage = "https://github.com/steipete/wacrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "wacrawl";
  };
}
