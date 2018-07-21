# OpenVPN for Docker
[![Build Status](https://travis-ci.org/aristarkh87/docker-openvpn.svg?branch=master)](https://travis-ci.org/aristarkh87/docker-openvpn)

OpenVPN server in a Docker container complete with an EasyRSA PKI CA.

## Quick Start

* Pick a name for the `$OVPN_DATA` data volume container. It's recommended to
  use the `ovpn-data-` prefix to operate seamlessly with the reference systemd
  service.  Users are encourage to replace `example` with a descriptive name of
  their choosing.

  ```
  OVPN_DATA="$(pwd)/ovpn-data"
  ```

* Initialize the `$OVPN_DATA` container that will hold the configuration files
  and certificates.  The container will prompt for a passphrase to protect the
  private key used by the newly generated certificate authority.

  ```
  docker run -v "$OVPN_DATA":"/etc/openvpn" --log-driver=none --rm registry.gitlab.com/aristarkh87/freedom/openvpn ovpn_genconfig -u udp://freedom.aristarkh.net
  docker run -v "$OVPN_DATA":"/etc/openvpn" --log-driver=none --rm -it registry.gitlab.com/aristarkh87/freedom/openvpn ovpn_initpki
  ```

* Start OpenVPN server process

  ```
  docker run -v "$OVPN_DATA":"/etc/openvpn" -d -p 1194:1194/udp --cap-add=NET_ADMIN registry.gitlab.com/aristarkh87/freedom/openvpn
  ```

* Generate a client certificate without a passphrase

  ```
  docker run -v "$OVPN_DATA":"/etc/openvpn" --log-driver=none --rm -it registry.gitlab.com/aristarkh87/freedom/openvpn easyrsa build-client-full CLIENTNAME nopass
  ```

* Retrieve the client configuration with embedded certificates

  ```
  docker run -v "$OVPN_DATA":"/etc/openvpn" --log-driver=none --rm registry.gitlab.com/aristarkh87/freedom/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
  ```

## Up and running

* Generate configs for server (select "Setup server")

  ```
  $ bash setup.sh -s $server_fqdn
  ```

* Run container

  ```
  $ docker-compose up -d
  ```

* Generate clients (select "Setup client"). Ovpn files are added to ./ovpn/

  ```
  $ bash setup.sh -c $username
  ```

## References

Used image from the project https://github.com/kylemanna/docker-openvpn
