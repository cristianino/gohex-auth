# Dockerfile for Go REST API with Hexagonal Architecture

FROM golang:1.21 AS builder

WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o api ./cmd/api/main.go

# Start a new stage from scratch
FROM alpine:latest

WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/api .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the executable
CMD ["./api"]