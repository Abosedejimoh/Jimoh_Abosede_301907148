-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_on")
VALUES (1001, 'pk-customer@example.test', '2025-04-01');

-- 2. customer unique. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_on")
VALUES (9001, 'ava.chen@example.test', '2025-04-02');

-- 3. customer nn id. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_on")
VALUES (NULL, 'nn-customer-id@example.test', '2025-04-03');

-- 4. customer nn email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_on")
VALUES (9002, NULL, '2025-04-04');

-- 5. customer nn created. Expected: created_on, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_on")
VALUES (9003, 'nn-customer-date@example.test', NULL);

-- 6. account pk. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (2001, 1001, 'ACCT-SYN-901', 'USD', 50, '2025-04-05', 'active');

-- 7. account unique. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9004, 1001, 'ACCT-SYN-001', 'USD', 50, '2025-04-06', 'active');

-- 8. account fk. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9005, 99999, 'ACCT-SYN-902', 'USD', 50, '2025-04-07', 'active');

-- 9. account nn id. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (NULL, 1001, 'ACCT-SYN-903', 'USD', 50, '2025-04-08', 'active');

-- 10. account nn customer. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9006, NULL, 'ACCT-SYN-904', 'USD', 50, '2025-04-09', 'active');

-- 11. account nn number. Expected: account_number, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9007, 1001, NULL, 'USD', 50, '2025-04-10', 'active');

-- 12. account nn currency. Expected: currency, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9008, 1001, 'ACCT-SYN-905', NULL, 50, '2025-04-11', 'active');

-- 13. account nn balance. Expected: balance, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9009, 1001, 'ACCT-SYN-906', 'USD', NULL, '2025-04-12', 'active');

-- 14. account nn opened. Expected: opened_on, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9010, 1001, 'ACCT-SYN-907', 'USD', 50, NULL, 'active');

-- 15. account nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9011, 1001, 'ACCT-SYN-908', 'USD', 50, '2025-04-13', NULL);

-- 16. transfer pk. Expected: pk_transfer, SQLSTATE 23505.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (3001, 2001, 2002, 25, 'USD', '2025-04-14T10:00:00Z', 'posted');

-- 17. transfer fk source. Expected: fk_transfer_0, SQLSTATE 23503.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9012, 99999, 2002, 25, 'USD', '2025-04-15T10:00:00Z', 'posted');

-- 18. transfer fk destination. Expected: fk_transfer_1, SQLSTATE 23503.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9013, 2001, 99999, 25, 'USD', '2025-04-16T10:00:00Z', 'posted');

-- 19. transfer nn id. Expected: transfer_id, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (NULL, 2001, 2002, 25, 'USD', '2025-04-17T10:00:00Z', 'posted');

-- 20. transfer nn source. Expected: source_account_id, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9014, NULL, 2002, 25, 'USD', '2025-04-18T10:00:00Z', 'posted');

-- 21. transfer nn destination. Expected: destination_account_id, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9015, 2001, NULL, 25, 'USD', '2025-04-19T10:00:00Z', 'posted');

-- 22. transfer nn amount. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9016, 2001, 2002, NULL, 'USD', '2025-04-20T10:00:00Z', 'posted');

-- 23. transfer nn currency. Expected: currency, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9017, 2001, 2002, 25, NULL, '2025-04-21T10:00:00Z', 'posted');

-- 24. transfer nn created. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9018, 2001, 2002, 25, 'USD', NULL, 'posted');

-- 25. transfer nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9019, 2001, 2002, 25, 'USD', '2025-04-22T10:00:00Z', NULL);

-- 26. account check balance. Expected: account_nonnegative_balance, SQLSTATE 23514.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on", "status")
VALUES (9020, 1001, 'ACCT-SYN-909', 'USD', -1, '2025-04-23', 'active');

-- 27. transfer check amount. Expected: transfer_positive_amount, SQLSTATE 23514.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9021, 2001, 2002, 0, 'USD', '2025-04-24T10:00:00Z', 'posted');

-- 28. transfer check distinct. Expected: transfer_distinct_accounts, SQLSTATE 23514.
INSERT INTO portfolio."transfer" ("transfer_id", "source_account_id", "destination_account_id", "amount", "currency", "created_at", "status")
VALUES (9022, 2001, 2001, 25, 'USD', '2025-04-25T10:00:00Z', 'posted');
