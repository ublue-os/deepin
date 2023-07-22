if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/autostart/deepin-firstboot.desktop; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /usr/share/ublue-os/firstboot/deepin-firstboot.desktop "$HOME"/.config/autostart
    fi
fi