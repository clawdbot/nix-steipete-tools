{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.13.3/discrawl_0.13.3_darwin_arm64.tar.gz";
      hash = "sha256-ZkAo9fNIn+cBhv3B2Z0pVt9p6nVNSh8UrMQFfATBZaE=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.13.3/discrawl_0.13.3_linux_amd64.tar.gz";
      hash = "sha256-2bpTwxN7AkfSIVGXCLxw8jxk90slEmZbJ6sMPnFGQsE=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.13.3/discrawl_0.13.3_linux_arm64.tar.gz";
      hash = "sha256-WYWTf2sxuV7EvQa56B2dXb2iFwcnO1AWpr6JeDQYZH8=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.13.3";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/discrawl"
    cp $(find . -type f -name discrawl | head -1) "$out/bin/discrawl"
    chmod 0755 "$out/bin/discrawl"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/discrawl/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/discrawl/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mirror Discord into SQLite and search server history locally";
    homepage = "https://github.com/openclaw/discrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "discrawl";
  };
}
