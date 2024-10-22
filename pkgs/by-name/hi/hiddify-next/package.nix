{
  lib,
  fetchFromGitHub,
  flutter,
  buildGoModule,
}:
let
  pname = "hiddify-next";
  version = "2.5.7";
  src = fetchFromGitHub {
    owner = "hiddify";
    repo = "hiddify-next";
    rev = "v${version}";
    hash = "sha256-6lHvbZhCTgeQ410WlMqMMAK9+WWmlfkl7Z2jv7oWA8s=";
    fetchSubmodules = true;
  };
  hiddify-core = buildGoModule rec {
    inherit pname version src;
    modRoot = "./libcore";
    vendorHash = "sha256-a7NFZt4/w2+oaZG3ncaOrrhASxUptcWS/TeaIQrgLe4=";
    GO_PUBLIC_FLAGS = ''
      -tags="with_gvisor,with_quic,with_wireguard,with_ech,with_utls,with_clash_api,with_grpc" \
      -trimpath \
      -ldflags="-w -s" \
    '';
    buildPhase = ''
      runHook preBuild
      go build ${GO_PUBLIC_FLAGS} -buildmode=c-shared -o libcore.so ./custom
      CGO_LDFLAGS=libcore.so go build ${GO_PUBLIC_FLAGS} -o HiddifyCli ./cli/bydll
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib $out/bin
      cp libcore.so $out/lib
      cp HiddifyCli $out/bin
      runHook postInstall
    '';
  };
in
flutter.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  preBuild = ''
    cp -a ${hiddify-core}/lib ./libcore/bin/lib
    cp -a ${hiddify-core}/bin/HiddifyCli ./libcore/bin/HiddifyCli
  '';

  gitHashes = {
    circle_flags = "sha256-dqORH4yj0jU8r9hP9NTjrlEO0ReHt4wds7BhgRPq57g=";
    flutter_easy_permission = "sha256-fs2dIwFLmeDrlFIIocGw6emOW1whGi9W7nQ7mHqp8R0=";
    humanizer = "sha256-zsDeol5l6maT8L8R6RRtHyd7CJn5908nvRXIytxiPqc=";
  };

  meta = {
    description = "Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc. It’s an open-source, secure and ad-free";
    homepage = "https://hiddify.com";
    mainProgram = "hiddify";
    license = lib.licenses.cc-by-nc-sa-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aucub ];
  };
}
