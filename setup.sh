#!/usr/bin/env bash

DOCKER_COMMAND="docker-compose run --rm openvpn"

get_extra_args() {
    EXTRA_CONFIG="./openvpn-extra.conf"

    while read line; do
        EXTRA_ARGS+="-e '$line' "
    done < "$EXTRA_CONFIG"
}

setup_server() {
    echo "Setup server ..."
    get_extra_args
    OVPN_SERVER="$1"
    eval "$DOCKER_COMMAND" ovpn_genconfig -u "udp://$OVPN_SERVER" "$EXTRA_ARGS"
    eval "$DOCKER_COMMAND" ovpn_initpki
}

setup_client() {
    echo "Setup client ..."
    OVPN_DIR="./ovpn"
    OVPN_CLIENT="$1"
    mkdir -p "$OVPN_DIR"
    eval "$DOCKER_COMMAND" easyrsa build-client-full "${OVPN_CLIENT:?client is empty}" nopass
    eval "$DOCKER_COMMAND" ovpn_getclient "$OVPN_CLIENT" > "$OVPN_DIR/$OVPN_CLIENT.ovpn"
}

revoke_client() {
    echo "Revoke client ..."
    OVPN_CLIENT="$1"
    eval "$DOCKER_COMMAND" easyrsa revoke "${OVPN_CLIENT:?client is empty}"
    eval "$DOCKER_COMMAND" easyrsa gen-crl
}

main() {
    while getopts "c:r:s:" opt; do
        case $opt in
            c)
                setup_client "$OPTARG"
                ;;
            r)
                revoke_client "$OPTARG"
                ;;
            s)
                setup_server "$OPTARG"
                ;;
        esac
    done
}

main
