FROM golang:1.23-alpine AS BUILDER

WORKDIR /api

COPY go.mod go.sum ./
RUN go mod download

COPY ./ ./

RUN go build -o ChildApi ./cmd/ChildManagerApi/main.go

FROM amneziavpn/amnezia-wg

COPY --from=builder /api/ChildApi /ChildApi
COPY --from=builder /api/new_client_awg.sh /new_client_awg.sh
COPY --from=builder /api/new_client_correct_output.sh /new_client_correct_output.sh

RUN chmod a+x /new_client_awg.sh
RUN chmod a+x /new_client_correct_output.sh
RUN chmod a+x /ChildApi

EXPOSE 8000
EXPOSE 39522

CMD ["./ChildApi"]
