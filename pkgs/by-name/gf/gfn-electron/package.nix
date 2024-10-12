{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron_29,
  autoPatchelfHook,
  nss,
  nspr,
  dbus,
  atk,
  at-spi2-atk,
  cups,
  gtk3,
  pango,
  cairo,
  libjpeg,
  libXcomposite,
  libXdamage,
  libXfixes,
  libXrandr,
  mesa,
  expat,
  libpng,
  libxkbcommon,
  alsa-lib,
  pulseaudio,
  flac,
  at-spi2-core,
  libxslt,
  udev,
  libGL,
  wrapGAppsHook3,
}:
buildNpmPackage rec {
  pname = "gfn-electron";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "hmlendea";
    repo = "gfn-electron";
    rev = "v${version}";
    hash = "sha256-kTnM4wSDqP2V8hb4mDhbQYpVYouSnUkjuuCfITb/xgY=";
  };

  postPatch = ''
    sed -i '/"electron"/d' package.json
  '';

  npmDepsHash = "sha256-27N0hWOfkLQGaGspm4aCoVF6PWiUOAKs+JzbdQV94lo=";

  forceGitDeps = true;

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  nativeBuildInputs = [
    autoPatchelfHook
    electron_29
    wrapGAppsHook3
  ];

  buildInputs = [
    nss
    nspr
    dbus
    atk
    at-spi2-atk
    cups
    gtk3
    pango
    cairo
    libjpeg
    libXcomposite
    libXdamage
    libXfixes
    libXrandr
    mesa
    expat
    libpng
    libxkbcommon
    alsa-lib
    pulseaudio
    flac
    at-spi2-core
    libxslt
    electron_29
  ];

  runtimeDependencies = map lib.getLib [
    udev
  ];

  buildPhase = ''
    runHook preBuild

    npm exec electron-builder -- \
      --dir \
      -c.electronDist="${electron_29.dist}" \
      -c.electronVersion="${electron_29.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -a ./dist/* $out/

    runHook postInstall
  '';

  postFixup = ''
    mkdir $out/bin
    makeWrapper $out/linux-unpacked/.electron-wrapped $out/bin/gfn-electron \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
        ]
      }"
  '';

  meta = {
    description = "Linux Desktop client for Nvidia's GeForce NOW game streaming service";
    homepage = "https://github.com/hmlendea/gfn-electron";
    mainProgram = "gfn-electron";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aucub ];
  };
}
