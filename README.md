# Projeto Bancário API

## Tecnologias e Versões

- **Ruby:** 3.1.2
- **Rails:** 7.0.7
- **PostgreSQL:** 13.1 - Banco de dados utilizado.
- **RSpec:** 5.0 - Framework de testes.
- **Docker e Docker Compose**

## Padrões de Projeto e Princípios

- **Repository Pattern:** Separação da lógica de negócios da lógica de acesso aos dados.
- **Service Pattern:** Encapsulamento da lógica de negócios.
- **SOLID:** Princípios de design orientado a objetos para criar software mais escalável, manutenível e flexível.
- **DRY (Don't Repeat Yourself):** Evitar repetição de código e tornar o software mais manutenível.

## Instalação e Configuração

1. **Clone o repositório:**

```bash
git clone https://github.com/thomasalmeida/cmbc-bank-api
```

2. **Construir e Inicializar o Ambiente Docker:**

```bash
make up
```

## Testes

Para executar os testes usando RSpec:

```bash
make test
```

## Rotas

### Criar Conta

**Request**

```json
POST /api/v1/accounts
{
  "holder_first_name": "John",
	"holder_last_name": "Doe",
	"holder_cpf": "012345678901",
	"balance_in_cents": 1000,
	"password": "123123",
	"password_confirmation": "123123"
}
```

**Response**

```json
{
  "account": {
    "id": "1",
    "holder_first_name": "John",
    "holder_last_name": "Doe",
    "holder_cpf": "012345678901",
    "balance_in_cents": 1000,
    "created_at": "2023-03-14T00:00:01.502Z",
    "updated_at": "2023-03-14T00:00:01.502Z"
  }
}
```

### Autenticar Conta

**Request**

```json
POST /api/v1/login
{
	"cpf": "012345678901",
	"password": "123123"
}
```

**Response**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.XbP2YJKU..."
}
```

### Consultar Saldo (Autenticada)

**Nota:** Para rotas autenticadas, você deve passar um JWT válido no header `Authorization`.

```http
GET /api/v1/accounts/balance
Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.XbP2YJKU...
```

**Response**

```json
{
  "balance_in_cents": 1000
}
```

### Realizar Transferência (Autenticada)

**Nota:** Para rotas autenticadas, você deve passar um JWT válido no header `Authorization`.

```http
Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.XbP2YJKU...
```

**Request**

```json
POST /api/v1/transactions
{
	"sender_id": "1",
	"receiver_id": "2",
	"amount_in_cents": 500
}
```

**Response**

```json
{
  "message": "Transaction completed"
}
```

### Reverter Transferência (Autenticada)

**Nota:** Para rotas autenticadas, você deve passar um JWT válido no header `Authorization`.

```http
POST /api/v1/transactions/1/reverse
Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.XbP2YJKU...
```

**Response**

```json
{
  "message": "Transaction reversed successfully"
}
```

### Listar Transferências (Autenticada)

**Nota:** Para rotas autenticadas, você deve passar um JWT válido no header `Authorization`.

```http
Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.XbP2YJKU...
```

**Request**

```json
GET /api/v1/transactions
{
	"start_date": "2020-01-01",
	"end_date": "2020-12-31"
}
```

**Response**

```json
{
  "transactions": [
    {
      "id": "11",
      "debit_account_id": "1",
      "credit_account_id": "2",
      "amount_in_cents": 500,
      "processed_at": "2023-03-14T00:00:01.502Z",
      "reversed_at": null,
      "created_at": "2023-03-14T00:00:01.502Z",
      "updated_at": "2023-03-14T00:00:01.502Z"
    }
  ]
}
```

## Autor

Thomas Almeida
