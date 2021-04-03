FROM alpine

EXPOSE 53/udp

RUN apk add --no-cache curl && \
    curl -L https://github.com/AdguardTeam/dnsproxy/releases/download/v0.36.0/dnsproxy-linux-amd64-v0.36.0.tar.gz | \
    tar xz linux-amd64/dnsproxy --strip-component=1 -C /usr/bin/ && \
    curl -L https://github.com/tuna/freedns-go/releases/download/v2020.9.17/freedns-go-linux-amd64 -o /usr/bin/freedns-go && \
    curl -L https://github.com/shawn1m/overture/releases/latest/download/overture-linux-amd64.zip | unzip - overture-linux-amd64 && \
    mv overture-linux-amd64 /usr/bin/overture && \
    chmod +x /usr/bin/dnsproxy /usr/bin/freedns-go /usr/bin/overture

COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/overture /etc/overture

CMD ["/usr/bin/supervisord"]
