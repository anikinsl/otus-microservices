FROM golang:1.24.4 AS builder

WORKDIR /app
COPY main.go main.go
COPY go.mod go.mod
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o service .
RUN chmod 0755 service

FROM gcr.io/distroless/static
COPY --from=builder /app/service /
ENTRYPOINT ["/service"]
