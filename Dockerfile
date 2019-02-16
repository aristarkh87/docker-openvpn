FROM kylemanna/openvpn

COPY ./ovpn_genconfig.patch /tmp
RUN patch /usr/local/bin/ovpn_genconfig < /tmp/ovpn_genconfig.patch
