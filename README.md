# Orders Clean Architecture

Este projeto é um desafio da **Full Cycle** focado na aplicação prática dos conceitos de **Clean Architecture** em Go. O objetivo é construir um sistema de gerenciamento de pedidos (orders) que expõe múltiplas interfaces (REST, gRPC e GraphQL) mantendo a lógica de negócio isolada e independente de frameworks.

## 📋 Sobre o Projeto

O sistema implementa operações CRUD para pedidos, seguindo os princípios da Clean Architecture:
- **Separação de responsabilidades** entre camadas
- **Independência de frameworks** e ferramentas externas
- **Testabilidade** através de interfaces e injeção de dependências
- **Flexibilidade** para adicionar novos pontos de entrada (REST, gRPC, GraphQL)

### Principais Funcionalidades
- ✅ Criar pedidos (Create Order)
- ✅ Listar pedidos (List Orders)
- ✅ Exposição via REST API, gRPC e GraphQL
- ✅ Publicação de eventos via RabbitMQ
- ✅ Persistência em MySQL

## 🏗️ Estrutura do Projeto

O projeto segue a estrutura da Clean Architecture, organizada da seguinte forma:

```
.
├── cmd/
│   └── server/              # Ponto de entrada da aplicação
│       ├── main.go          # Inicialização dos servidores
│       ├── wire.go          # Configuração do Wire (DI)
│       └── wire_gen.go      # Código gerado pelo Wire
│
├── configs/
│   └── config.go            # Carregamento de configurações
│
├── internal/
│   ├── entity/              # Camada de Entidades (Domain)
│   │   ├── order.go         # Entidade Order
│   │   └── interface.go     # Interfaces do domínio
│   │
│   ├── usecase/             # Camada de Casos de Uso (Application)
│   │   ├── create_order.go  # Caso de uso: criar pedido
│   │   └── list_order.go    # Caso de uso: listar pedidos
│   │
│   ├── infra/               # Camada de Infraestrutura
│   │   ├── database/        # Implementação do repositório
│   │   ├── web/             # Handlers REST
│   │   ├── grpc/            # Serviços gRPC
│   │   │   ├── pb/          # Protocol Buffers gerados
│   │   │   ├── protofiles/  # Definições .proto
│   │   │   └── service/     # Implementação dos serviços
│   │   └── graph/           # Resolvers GraphQL
│   │       ├── schema.graphqls    # Schema GraphQL
│   │       ├── schema.resolvers.go # Implementação resolvers
│   │       └── generated.go       # Código gerado pelo gqlgen
│   │
│   ├── event/               # Sistema de eventos
│   │   ├── order_created.go # Evento de pedido criado
│   │   └── handler/         # Handlers de eventos
│   │
│   └── db/                  # Código gerado pelo sqlc
│
├── pkg/
│   └── events/              # Sistema de event dispatcher
│
├── sql/
│   ├── migrations/          # Migrations do banco
│   └── queries/             # Queries SQL (sqlc)
│
├── api/
│   └── order.http           # Exemplos de requisições HTTP
│
├── docker-compose.yaml      # MySQL e RabbitMQ
├── gqlgen.yaml              # Configuração do GraphQL
├── sqlc.yaml                # Configuração do sqlc
├── Makefile                 # Comandos automatizados
└── .env                     # Variáveis de ambiente
```

### Camadas da Clean Architecture

1. **Entities (Domain)** - `internal/entity/`
   - Contém as regras de negócio fundamentais
   - Independente de qualquer framework ou tecnologia

2. **Use Cases (Application)** - `internal/usecase/`
   - Orquestra o fluxo de dados entre entities e infraestrutura
   - Contém a lógica de aplicação

3. **Interface Adapters** - `internal/infra/`
   - Adaptadores para diferentes interfaces (REST, gRPC, GraphQL)
   - Implementações de repositórios

4. **Frameworks & Drivers** - `pkg/`, bibliotecas externas
   - Ferramentas e frameworks utilizados

## 🛠️ Tecnologias e Bibliotecas

### Core
- **Go 1.25.1** - Linguagem de programação
- **Clean Architecture** - Padrão arquitetural

### Banco de Dados
- **MySQL 5.7** - Banco de dados relacional
- **[sqlc](https://sqlc.dev/)** - Gerador de código type-safe para SQL
  - Gera código Go a partir de queries SQL
  - Elimina necessidade de escrever código boilerplate
  - Type-safe em tempo de compilação

### APIs e Comunicação
- **[gRPC](https://grpc.io/)** - Framework de RPC de alta performance
  - Protocol Buffers para serialização
  - Comunicação binária eficiente
  - Suporte a streaming

- **[GraphQL](https://graphql.org/)** - Query language para APIs
  - **[gqlgen](https://gqlgen.com/)** - Gerador de código GraphQL para Go
  - Schema-first development
  - Type-safe resolvers

- **REST API** - API HTTP tradicional
  - **[chi](https://github.com/go-chi/chi)** - Router HTTP leve e rápido

### Mensageria
- **[RabbitMQ](https://www.rabbitmq.com/)** - Message broker
  - **[streadway/amqp](https://github.com/streadway/amqp)** - Cliente Go para AMQP
  - Sistema de eventos assíncronos

### Migrations
- **[golang-migrate](https://github.com/golang-migrate/migrate)** - Ferramenta de database migrations
  - Versionamento do schema do banco
  - Rollback de migrations
  - Suporte para múltiplos bancos de dados

### Dependency Injection
- **[Wire](https://github.com/google/wire)** - Gerador de código para DI
  - Compile-time dependency injection
  - Elimina reflexão em runtime
  - Type-safe

### Configuração
- **[Viper](https://github.com/spf13/viper)** - Gerenciamento de configurações
  - Suporte a múltiplos formatos (.env, JSON, YAML)
  - Variáveis de ambiente

### Testes
- **[Testify](https://github.com/stretchr/testify)** - Framework de testes
  - Assertions e mocks
  - Test suites

### Protocol Buffers
- **[protobuf](https://protobuf.dev/)** - Serialização de dados
  - Definição de contratos gRPC
  - Geração de código para múltiplas linguagens

## 🚀 Setup do Projeto

### Pré-requisitos

- **Go 1.25+** instalado
- **Docker** e **Docker Compose** instalados
- **Make** instalado (geralmente já vem no Linux/Mac)
- **Protocol Buffers Compiler (protoc)** instalado

### Instalação do protoc

**Linux:**
```bash
sudo apt update
sudo apt install -y protobuf-compiler
protoc --version  # Verificar instalação
```

**macOS:**
```bash
brew install protobuf
protoc --version  # Verificar instalação
```

**Windows:**
- Baixe o binário em [GitHub Releases](https://github.com/protocolbuffers/protobuf/releases)
- Adicione ao PATH

### 1. Clone o Repositório

```bash
git clone https://github.com/alexduzi/orderscleanarch.git
cd orderscleanarch
```

### 2. Instale as Ferramentas de Desenvolvimento

```bash
make install-tools
```

Este comando instala:
- Wire (dependency injection)
- protoc-gen-go (gerador de código Protocol Buffers)
- protoc-gen-go-grpc (gerador de código gRPC)
- gqlgen (gerador de código GraphQL)

### 3. Configure as Variáveis de Ambiente

```bash
cp .env.example .env
```

Edite o arquivo `.env` conforme necessário:

```env
# Database Configuration
DB_DRIVER=mysql
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root
DB_NAME=orders

# Server Ports
WEB_SERVER_PORT=:8000
GRPC_SERVER_PORT=50051
GRAPHQL_SERVER_PORT=8080

# RabbitMQ Configuration
RABBITMQ_URL=amqp://guest:guest@localhost:5672/
```

### 4. Setup Completo (Docker + Migrations + Code Generation)

```bash
make setup
```

Este comando executa:
1. `docker-compose up -d` - Sobe MySQL e RabbitMQ
2. `make migrate` - Executa as migrations do banco
3. `make generate` - Gera todo o código necessário (Wire, gRPC, GraphQL)

### Ou faça o setup passo a passo:

```bash
# 1. Subir containers Docker (MySQL + RabbitMQ)
make docker-up

# 2. Executar migrations
make migrate

# 3. Gerar código
make generate
```

## 🎮 Comandos do Makefile

### Comandos Principais

```bash
# Rodar a aplicação
make run

# Build da aplicação
make build

# Setup completo do projeto
make setup
```

### Geração de Código

```bash
# Gerar código de injeção de dependências (Wire)
make wire

# Gerar código gRPC a partir dos .proto
make grpc

# Gerar código GraphQL a partir do schema
make graphql

# Gerar todo o código (Wire + gRPC + GraphQL)
make generate
```

### Database

```bash
# Executar migrations
make migrate

# Reverter última migration
make migratedown

# Criar nova migration
make createmigration
```

### Docker

```bash
# Subir containers (MySQL + RabbitMQ)
make docker-up

# Parar containers
make docker-down

# Ver logs dos containers
make docker-logs
```

### Testes

```bash
# Executar todos os testes
make test

# Executar testes com coverage
make test-coverage
```

### Utilitários

```bash
# Limpar arquivos gerados
make clean

# Baixar dependências
make deps

# Instalar ferramentas de desenvolvimento
make install-tools
```

## 📡 Testando as APIs

### REST API

O servidor REST roda na porta `8000` (configurável via `.env`).

**Criar um pedido:**
```bash
curl -X POST http://localhost:8000/order \
  -H "Content-Type: application/json" \
  -d '{
    "id": "123",
    "price": 100.5,
    "tax": 10.5
  }'
```

**Listar pedidos:**
```bash
curl http://localhost:8000/listorders
```

### gRPC

O servidor gRPC roda na porta `50051` (configurável via `.env`).

Use ferramentas como [grpcurl](https://github.com/fullstorydev/grpcurl) ou [BloomRPC](https://github.com/bloomrpc/bloomrpc):

```bash
# Criar pedido
grpcurl -plaintext -d '{
  "id": "123",
  "price": 100.5,
  "tax": 10.5
}' localhost:50051 pb.OrderService/CreateOrder

# Listar pedidos
grpcurl -plaintext localhost:50051 pb.OrderService/ListOrders
```

### GraphQL

O servidor GraphQL roda na porta `8080` (configurável via `.env`).

Acesse o **GraphQL Playground**: [http://localhost:8080](http://localhost:8080)

**Criar pedido:**
```graphql
mutation {
  createOrder(input: {
    id: "123"
    price: 100.5
    tax: 10.5
  }) {
    id
    price
    tax
    finalPrice
  }
}
```

**Listar pedidos:**
```graphql
query {
  listOrders {
    id
    price
    tax
    finalPrice
  }
}
```

## 🔄 Fluxo de Desenvolvimento

1. **Modificou o schema do banco?**
   ```bash
   make createmigration  # Criar nova migration
   make migrate          # Aplicar migration
   ```

2. **Modificou queries SQL?**
   ```bash
   # Edite os arquivos em sql/queries/
   # Regere o código sqlc (incluso no make generate)
   make generate
   ```

3. **Modificou o schema GraphQL?**
   ```bash
   # Edite internal/infra/graph/schema.graphqls
   make graphql
   ```

4. **Modificou os arquivos .proto?**
   ```bash
   # Edite internal/infra/grpc/protofiles/order.proto
   make grpc
   ```

5. **Modificou a injeção de dependências?**
   ```bash
   # Edite cmd/server/wire.go
   make wire
   ```

## 📚 Estrutura de Dados

### Order Entity

```go
type Order struct {
    ID         string
    Price      float64
    Tax        float64
    FinalPrice float64
}
```

## 🎯 Conceitos Aplicados

### Clean Architecture
- ✅ Separação em camadas (Entity, Use Case, Interface Adapters, Frameworks)
- ✅ Dependency Rule (dependências apontam para dentro)
- ✅ Independência de frameworks
- ✅ Testabilidade

### Design Patterns
- ✅ Repository Pattern
- ✅ Use Case Pattern
- ✅ Dependency Injection
- ✅ Event Dispatcher
- ✅ Adapter Pattern

### SOLID Principles
- ✅ Single Responsibility Principle
- ✅ Open/Closed Principle
- ✅ Liskov Substitution Principle
- ✅ Interface Segregation Principle
- ✅ Dependency Inversion Principle

## 🐛 Troubleshooting

### Erro ao conectar no MySQL
```bash
# Verifique se os containers estão rodando
docker-compose ps

# Reinicie os containers
make docker-down
make docker-up
```

### Erro ao gerar código
```bash
# Certifique-se de ter instalado as ferramentas
make install-tools

# Limpe e regere
make clean
make generate
```

### Porta já em uso
```bash
# Altere as portas no arquivo .env
WEB_SERVER_PORT=:8001
GRPC_SERVER_PORT=50052
GRAPHQL_SERVER_PORT=8081
```