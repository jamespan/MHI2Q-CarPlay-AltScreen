#!/bin/sh
# Menu entry: install the map and route guidance together.
ALTS_INSTALL_RGI_MODE=WITH
export ALTS_INSTALL_RGI_MODE
exec /bin/sh "${0%/*}/install_mmi_cockpit_carplay_rx.sh" "$@"
