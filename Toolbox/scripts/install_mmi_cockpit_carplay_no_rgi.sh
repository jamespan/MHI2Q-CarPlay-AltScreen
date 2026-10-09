#!/bin/sh
# Menu entry: keep the map, disable native/Java/renderer route guidance.
ALTS_INSTALL_RGI_MODE=NO
export ALTS_INSTALL_RGI_MODE
exec /bin/sh "${0%/*}/install_mmi_cockpit_carplay_rx.sh" "$@"
