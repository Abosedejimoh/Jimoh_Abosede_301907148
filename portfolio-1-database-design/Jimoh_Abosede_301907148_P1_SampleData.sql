-- Fictional sample records for Synthetic Bank and Fintech Transfers.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "email", "created_on") VALUES (1001, 'ava.chen@example.test', '2025-01-10');
INSERT INTO portfolio."customer" ("customer_id", "email", "created_on") VALUES (1002, 'noah.park@example.test', '2025-02-14');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status") VALUES (2001, 1001, 'ACCT-SYN-001', 'USD', 2500, '2025-01-11', 'active');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status") VALUES (2002, 1002, 'ACCT-SYN-002', 'USD', 875, '2025-02-15', 'active');
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status") VALUES (3001, 2001, 2002, 125, 'USD', '2025-03-01T10:30:00Z', 'posted');
COMMIT;
