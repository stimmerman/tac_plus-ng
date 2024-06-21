FROM alpine:3.20

LABEL org.opencontainers.image.authors="Sander Timmerman <stimmerman@users.noreply.github.com>"
LABEL org.opencontainers.image.source="https://github.com/stimmerman/tac_plus-ng"
LABEL org.opencontainers.image.documentation="https://github.com/stimmerman/tac_plus-ng"
LABEL org.opencontainers.image.description="TACACS+ container for lab use"

RUN apk add --no-cache \
        build-base \
        c-ares-dev \
        curl \
        curl-dev \
        freeradius-client-dev \
        libretls-dev \
        linux-pam-dev \
        openssl-dev \
        pcre2-dev \
        perl \
        perl-authen-radius \
        perl-ldap \
        perl-net-ip \
        perl-sys-syslog


RUN wget https://github.com/MarcJHuber/event-driven-servers/archive/refs/heads/master.zip -O event-driven-servers-master.zip && \
    unzip event-driven-servers-master.zip && \
    rm event-driven-servers-master.zip && \
    cd event-driven-servers-master && \
    ./configure tac_plus-ng && \
    make && \
    make install

ADD tac_plus-ng.cfg /usr/local/etc/tac_plus-ng.cfg

Expose 49

CMD ["/usr/local/sbin/tac_plus-ng", "/usr/local/etc/tac_plus-ng.cfg"]
