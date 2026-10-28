# Synthetic Bank and Fintech Transfers — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | account records (list) |
| --- | --- |
| 1001 | [2001] |
| 1002 | [2002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | ACCT-SYN-001 | 1001 | ava.chen@example.test |
| 2002 | 1002 | ACCT-SYN-002 | 1002 | noah.park@example.test |

Key: account_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## account_example

| account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | ACCT-SYN-001 | 1001 | ava.chen@example.test |
| 2002 | 1002 | ACCT-SYN-002 | 1002 | noah.park@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | email | created_on |
| --- | --- | --- |
| 1001 | ava.chen@example.test | 2025-01-10 |
| 1002 | noah.park@example.test | 2025-02-14 |

## account

| account_id | customer_id | account_number | currency | balance | opened_on | status |
| --- | --- | --- | --- | --- | --- | --- |
| 2001 | 1001 | ACCT-SYN-001 | USD | 2500 | 2025-01-11 | active |
| 2002 | 1002 | ACCT-SYN-002 | USD | 875 | 2025-02-15 | active |

## transfer

| transfer_id | source_account_id | destination_account_id | amount | currency | created_at | status |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | 2002 | 125 | USD | 2025-03-01T10:30:00+00:00 | posted |

## Dependencies

- customer: (customer_id) → email, created_on
- account: (account_id) → customer_id, account_number, currency, balance, opened_on, status
- transfer: (transfer_id) → source_account_id, destination_account_id, amount, currency, created_at, status

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
