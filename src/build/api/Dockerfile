# Используем базовый образ Go с версией 1.24 на базе Alpine
FROM golang:1.24-alpine3.22 as builder
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

# Устанавливаем рабочую директорию в контейнере
WORKDIR /src
COPY go.mod ./

RUN --mount=type=cache,sharing=locked,target=/go/pkg/mod \
    go mod download -x
# Копируем исходный код

COPY . /src
WORKDIR /src/cmd/api

RUN CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT} \
    go build -o /bin/api -ldflags="-w -s" -v

# Второй stage для уменьшения размера образа
FROM alpine:3.22

RUN apk add --update --no-cache ca-certificates

COPY --from=builder /bin/api /api

# Указываем команду для запуска приложения
ENTRYPOINT []
CMD ["/api"]