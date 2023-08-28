#!/bin/bash
if [[ "$(systemctl is-active openvpn.service)" == "inactive" ]]; then
    printf '  \xE2\x83\xA0 '
elif [[ "$(systemctl is-active openvpn.service)" == "activating" ]]; then
    printf ' ????? '
elif [[ "$(systemctl is-active openvpn.service)" == "active" ]]; then
    if ping -c 1 -q gitlab.solaredge.com > /dev/null; then
        printf '\xE2\x9C\x85'
    else
        printf '\xE2\x9D\x8C'
    fi
fi

echo
