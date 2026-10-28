# Synthetic Bank and Fintech Transfers — database design

My case study records customer, account, transfer.

## Users

- Synthetic account holders
- Fintech operations analysts

## Main operations

- Open an account for a customer
- Post an internal account transfer
- Review and summarize transfer activity

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A synthetic account holder who may own multiple accounts. |
| account | A synthetic account owned by one customer, with a balance and currency. |
| transfer | A synthetic record of a transfer from one account to another. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| created_on | DATE |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| currency | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| opened_on | DATE |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customer.customer_id
- Unique key: (account_number).

## transfer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| transfer_id | BIGINT | PK | Yes |
| source_account_id | BIGINT | FK | Yes |
| destination_account_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| currency | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- source_account_id → account.account_id
- destination_account_id → account.account_id

## Relationships and business rules

- Each customer email is unique.
- Each fictional account number is unique.
- Every account references an existing customer through customer_id.
- Every transfer references an existing source account through source_account_id.
- Every transfer references an existing destination account through destination_account_id.
- An account balance must be greater than or equal to zero.
- A transfer amount must be greater than zero.
- A transfer's source and destination account identifiers must differ.

## Assumptions

- Customer, account, and transfer identifiers are synthetic and globally unique across all entity tables.
- A transfer moves funds between two distinct accounts in the same currency.
- Each account belongs to one customer; a customer may own multiple accounts.
- For a simple normalization example, use account as the root entity and customer as its single parent; do not repeat ancestor roles.
- The transfer operation checks the source balance and updates both account balances atomically.
- The model excludes external payment rails, real customer data, and regulatory workflows.

