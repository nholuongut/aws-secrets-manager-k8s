# Build the manager binary
FROM golang:1.10.3 as builder
LABEL maintainer="Nho Luong <luongutnho@hotmail.com>"
# Copy in the go src
WORKDIR /go/src/github.com/nholuongut/aws-secrets-manager-k8s
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager github.com/nholuongut/aws-secrets-manager-k8s/cmd/manager

# Copy the controller-manager into a thin image
FROM ubuntu:latest
WORKDIR /
COPY --from=builder /go/src/github.com/nholuongut/aws-secrets-manager-k8s/manager .

RUN apt-get update && apt-get install -y ca-certificates
ENTRYPOINT ["/manager"]
