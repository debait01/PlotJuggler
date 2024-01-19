# PlotJuggler Flatpak

Flatpak build of [PlotJuggler](https://github.com/facontidavide/PlotJuggler).

ROS plugins are not supported by now.

## Locally build & install

Assuming `flatpak-builder` is installed, then simply run:

```sh
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --user --install --install-deps-from=flathub --force-clean build com.facontidavide.PlotJuggler.yml
```

This will create a build directory named `build`.
