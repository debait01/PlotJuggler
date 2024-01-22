{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      plotjuggler = (with pkgs; stdenv.mkDerivation {
          pname = "plotjuggler";
          version = "0.0.1";
          src = fetchgit {
            url = "https://github.com/debait01/PlotJuggler.git";
            rev = "569f1d6c4652bb4cf52f8608f781d5a88e2b5cd";
            sha256 = "sha256-YO9EEXvXCT5m6Lv7QOTctpKbN87YS6n0XVX1ir5ImSk=";
            fetchSubmodules = true;
          };
          postPatch = ''
            substituteInPlace CMakeLists.txt \
              --replace "set(PJ_PLUGIN_INSTALL_DIRECTORY bin)" "set(PJ_PLUGIN_INSTALL_DIRECTORY lib/plugins)"
            substituteInPlace plotjuggler_app/mainwindow.cpp \
              --replace "QCoreApplication::applicationDirPath()" "\"$out/lib/plugins\""
          '';
        
          nativeBuildInputs = with pkgs; [ cmake libsForQt5.qt5.wrapQtAppsHook ];
          buildInputs = with pkgs; [ libsForQt5.qt5.qtsvg libsForQt5.qt5.qtwebsockets mosquitto libdwarf protobuf zeromq zstd libsForQt5.qt5.qtx11extras glfw glm libsForQt5.qt5.qtwayland ];
        }
      );
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = plotjuggler;
      devShell = pkgs.mkShell {
        buildInputs = [
          plotjuggler
        ];
      };
    }
  );
}
