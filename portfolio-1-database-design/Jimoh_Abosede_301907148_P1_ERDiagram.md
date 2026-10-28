# Synthetic Bank and Fintech Transfers — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text email UK
        date created_on
    }
    account {
        bigint account_id PK
        bigint customer_id FK
        text account_number UK
        text currency
        numeric balance
        date opened_on
        text status
    }
    transfer {
        bigint transfer_id PK
        bigint source_account_id FK
        bigint destination_account_id FK
        numeric amount
        text currency
        timestamptz created_at
        text status
    }
    customer ||--o{ account : "customer_id"
    account ||--o{ transfer : "source_account_id"
    account ||--o{ transfer : "destination_account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Jimoh_Abosede_301907148_ERDiagram.png)
