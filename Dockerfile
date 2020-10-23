FROM arm32v7/alpine:3.12

LABEL maintainer="Peter Dave Hello <hsu@peterdavehello.org>"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
RUN apk -U upgrade
RUN apk -v add tor@edge curl

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk
RUN apk add glibc-2.30-r0.apk
RUN apk add glibc-bin-2.30-r0.apk

RUN chmod 700 /var/lib/tor
RUN rm -rf /var/cache/apk/*
RUN tor --version
COPY torrc /etc/tor/

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD curl --fail --socks5-hostname localhost:9150 -I -L 'https://www.facebookcorewwwi.onion/' || exit 1

EXPOSE 53/udp 9150/tcp

CMD ["/usr/bin/tor", "-f", "/etc/tor/torrc"]
