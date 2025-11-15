# Database migrations
createmigration:
	migrate create -ext=sql -dir=sql/migrations -seq init

migrate:
	migrate -path=sql/migrations -database "mysql://root:root@tcp(localhost:3306)/orders" -verbose up

migratedown:
	migrate -path=sql/migrations -database "mysql://root:root@tcp(localhost:3306)/orders" -verbose down

# Wire - Dependency Injection
wire:
	cd cmd/server && wire

# gRPC - Generate protobuf code
grpc:
	protoc --go_out=. --go-grpc_out=. internal/infra/grpc/protofiles/order.proto

# GraphQL - Generate code
graphql:
	go run github.com/99designs/gqlgen generate

# Generate all code (Wire + gRPC + GraphQL)
generate: wire grpc graphql

# Run the server
run:
	go run cmd/server/main.go cmd/server/wire_gen.go

# Build the application
build:
	go build -o bin/server cmd/server/main.go cmd/server/wire_gen.go

# Run tests
test:
	go test -v ./...

# Run tests with coverage
test-coverage:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

# Clean generated files
clean:
	rm -rf bin/
	rm -f coverage.out coverage.html

# Install dependencies
deps:
	go mod download
	go mod tidy

# Install development tools
install-tools:
	go install github.com/google/wire/cmd/wire@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/99designs/gqlgen@latest

# Docker compose commands
docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-logs:
	docker-compose logs -f

# Complete setup (Docker + Migrations + Generate code)
setup: docker-up migrate generate

.PHONY: createmigration migrate migratedown wire grpc graphql generate run build test test-coverage clean deps install-tools docker-up docker-down docker-logs setup