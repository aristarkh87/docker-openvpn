FROM kylemanna/openvpn

COPY ./ovpn_genconfig /usr/local/bin/
RUN chmod a+x /usr/local/bin/*
