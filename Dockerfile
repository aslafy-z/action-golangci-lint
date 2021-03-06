FROM golangci/golangci-lint:v1.21-alpine

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v0.9.14

RUN apk --no-cache add git && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
