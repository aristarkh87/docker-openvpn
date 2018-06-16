#!/usr/bin/env bash

get_extra_args() {
    EXTRA_CONFIG="./openvpn-extra.conf"

    while read line; do
        EXTRA_ARGS+="-e '$line' "
    done < "$EXTRA_CONFIG"
}

setup_server() {
    get_extra_args
    eval "$DOCKER_COMMAND" ovpn_genconfig -u "udp://$OVPN_SERVER" "$EXTRA_ARGS"
    eval "$DOCKER_COMMAND" ovpn_initpki
}

setup_client() {
    OVPN_DIR="./ovpn"

    mkdir -p "$OVPN_DIR"
    eval "$DOCKER_COMMAND" easyrsa build-client-full "${OVPN_CLIENT:?client is empty}" nopass
    eval "$DOCKER_COMMAND" ovpn_getclient "$OVPN_CLIENT" > "$OVPN_DIR/$OVPN_CLIENT.ovpn"
}

revoke_client() {
    eval "$DOCKER_COMMAND" easyrsa revoke "${OVPN_CLIENT:?client is empty}"
    eval "$DOCKER_COMMAND" easyrsa gen-crl
}

main() {
    select opt in server client revoke quit; do
        if [[ $opt == "server" ]]; then
            echo "Setup server ..."
            read -p 'Enter server name >>> ' OVPN_SERVER
            setup_server
        elif [[ $opt == "client" ]]; then
            echo "Setup client ..."
            read -p 'Enter client name >>> ' OVPN_CLIENT
            setup_client
        elif [[ $opt == "revoke" ]]; then
            echo "Revoke client ..."
            read -p 'Enter client name >>> ' OVPN_CLIENT
            revoke_client
        elif [[ $opt == "quit" ]]; then
            echo "Bye"
            exit
        else
            echo "Invalid"
        fi
    done
}

DOCKER_COMMAND="docker-compose run --rm openvpn"
main
