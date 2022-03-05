# OpenVPN for Docker

OpenVPN server in a Docker container complete with an EasyRSA PKI CA.

## Up and running

* Generate configs for server (select "Setup server")

  ```
  $ ./setup.sh -s $server_fqdn
  ```

* Run container

  ```
  $ docker-compose up -d
  ```

* Generate clients (select "Setup client"). Ovpn files are added to ./ovpn/

  ```
  $ ./setup.sh -c $username
  ```

## References

Used image from the project https://github.com/kylemanna/docker-openvpn
