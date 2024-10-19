FROM golang:1.23-alpine AS BUILDER

WORKDIR /api

COPY go.mod go.sum ./
RUN go mod download

COPY ./ ./

RUN go build -o ChildApi ./cmd/ChildManagerApi/main.go

FROM amneziavpn/amnezia-wg:latest

LABEL maintainer="AmneziaVPN"

#Install required packages
RUN apk add --no-cache bash curl dumb-init
RUN apk --update upgrade --no-cache

RUN mkdir -p /opt/amnezia
COPY ./start.sh /opt/amnezia/start.sh
RUN chmod a+x /opt/amnezia/start.sh

# Tune network
RUN echo -e " \n\
  fs.file-max = 51200 \n\
  \n\
  net.core.rmem_max = 67108864 \n\
  net.core.wmem_max = 67108864 \n\
  net.core.netdev_max_backlog = 250000 \n\
  net.core.somaxconn = 4096 \n\
  \n\
  net.ipv4.tcp_syncookies = 1 \n\
  net.ipv4.tcp_tw_reuse = 1 \n\
  net.ipv4.tcp_tw_recycle = 0 \n\
  net.ipv4.tcp_fin_timeout = 30 \n\
  net.ipv4.tcp_keepalive_time = 1200 \n\
  net.ipv4.ip_local_port_range = 10000 65000 \n\
  net.ipv4.tcp_max_syn_backlog = 8192 \n\
  net.ipv4.tcp_max_tw_buckets = 5000 \n\
  net.ipv4.tcp_fastopen = 3 \n\
  net.ipv4.tcp_mem = 25600 51200 102400 \n\
  net.ipv4.tcp_rmem = 4096 87380 67108864 \n\
  net.ipv4.tcp_wmem = 4096 65536 67108864 \n\
  net.ipv4.tcp_mtu_probing = 1 \n\
  net.ipv4.tcp_congestion_control = hybla \n\
  # for low-latency network, use cubic instead \n\
  # net.ipv4.tcp_congestion_control = cubic \n\
  " | sed -e 's/^\s\+//g' | tee -a /etc/sysctl.conf && \
  mkdir -p /etc/security && \
  echo -e " \n\
  * soft nofile 51200 \n\
  * hard nofile 51200 \n\
  " | sed -e 's/^\s\+//g' | tee -a /etc/security/limits.conf

COPY ./configure_container.sh ./configure_container.sh
RUN chmod a+x ./configure_container.sh
RUN ./configure_container.sh

ENTRYPOINT [ "dumb-init", "/opt/amnezia/start.sh" ]

COPY --from=builder /api/ChildApi /ChildApi
COPY --from=builder /api/new_awg_client.sh /new_awg_client.sh
COPY --from=builder /api/new_client_config.sh /ne_client_config.sh

RUN chmod a+x /new_awg_client.sh
RUN chmod a+x /new_client_correct_output.sh
RUN chmod a+x /ChildApi

EXPOSE 8000
EXPOSE 39522

CMD ["./ChildApi"]
