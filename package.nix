{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      info = (builtins.fromJSON (builtins.readFile ./sources.json)).${system};

      pname = "helium";
      version = info.version;

      src = pkgs.fetchurl {
        url = info.tar_url;
        hash = info.tar_sha256;
      };

      helium = pkgs.stdenv.mkDerivation {
        inherit pname version src;

        desktopItems = [
          (pkgs.makeDesktopItem {
            name = "helium-browser";
            desktopName = "Helium";
            exec = "helium %U";
            startupWMClass = "helium-browser";
            startupNotify = true;
            mimeTypes = [
              "application/pdf"
              "application/rdf+xml"
              "application/rss+xml"
              "application/xhtml+xml"
              "application/xhtml_xml"
              "application/xml"
              "image/gif"
              "image/jpeg"
              "image/png"
              "image/webp"
              "text/html"
              "text/xml"
              "x-scheme-handler/http"
              "x-scheme-handler/https"
              "x-scheme-handler/webcal"
              "x-scheme-handler/mailto"
              "x-scheme-handler/about"
              "x-scheme-handler/unknown"
            ];
          })
        ];

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          patchelfUnstable
          copyDesktopItems
          qt6.wrapQtAppsHook
        ];

        # borrowed from nixpkgs
        buildInputs = with pkgs; [
          qt6.qtbase

          bzip2
          flac
          speex
          libevent
          expat
          libjpeg
          snappy
          libcap
          minizip
          libwebp
          libusb1
          re2
          ffmpeg
          libxslt
          libxml2
          nasm
          nspr
          nss
          util-linux
          alsa-lib
          libkrb5
          glib
          gtk3
          dbus-glib
          xorg.libXScrnSaver
          xorg.libXcursor
          xorg.libXtst
          xorg.libxshmfence
          libGLU
          libGL
          dri-pkgconfig-stub
          libgbm
          pciutils
          protobuf
          speechd-minimal
          xorg.libXdamage
          at-spi2-core
          pipewire
          libva
          libdrm
          wayland
          libxkbcommon
          curl
          libepoxy
          libffi
          libevdev

          systemd

          libgcrypt
          cups
        ];

        runtimeDependencies = with pkgs; [ libGL ];

        patchelfFlags = [ "--no-clobber-old-sections" ];
        autoPatchelfIgnoreMissingDeps = [
          "libQt5Core.so.5"
          "libQt5Gui.so.5"
          "libQt5Widgets.so.5"
        ];

        installPhase = ''
          runHook preInstall

          libExecPath="$prefix/libexec/${pname}-bin-$version"
          mkdir -p "$libExecPath"
          cp -rv ./ "$libExecPath/"

          mkdir -p $out/bin
          wrapQtApp "$libExecPath/chrome" \
            --prefix LD_LIBRARY_PATH : "$rpath"
          ln -s "$libExecPath/chrome" "$out/bin/${pname}"

          runHook postInstall
        '';
      };
    in
    {
      packages = {
        inherit helium;
        default = helium;
      };
    };
}
