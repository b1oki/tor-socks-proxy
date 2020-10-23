FROM resnullius/alpine-armv7l:latest

LABEL maintainer="Peter Dave Hello <hsu@peterdavehello.org>"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
RUN apk -U upgrade
RUN apk -v add tor@edge curl
RUN chmod 700 /var/lib/tor
RUN rm -rf /var/cache/apk/*
RUN tor --version
COPY torrc /etc/tor/

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD curl --fail --socks5-hostname localhost:9150 -I -L 'https://www.facebookcorewwwi.onion/' || exit 1

EXPOSE 53/udp 9150/tcp

CMD ["/usr/bin/tor", "-f", "/etc/tor/torrc"]
