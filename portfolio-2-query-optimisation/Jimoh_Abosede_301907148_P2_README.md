# Synthetic Bank and Fintech Transfers — SQL queries

## 1. Show related transfer, account, customer records (up to 20).

```sql
SELECT t0."transfer_id" AS "transfer_transfer_id",
       t0."amount" AS "transfer_amount",
       t1."account_id" AS "account_account_id",
       t1."account_number" AS "account_account_number",
       t2."customer_id" AS "customer_customer_id",
       t2."email" AS "customer_email"
FROM portfolio."transfer" t0
JOIN portfolio."account" t1 ON t0."source_account_id" = t1."account_id"
JOIN portfolio."customer" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."transfer_id", t1."account_id", t2."customer_id"
LIMIT 20;
```

| transfer_transfer_id | transfer_amount | account_account_id | account_account_number | customer_customer_id | customer_email |
| --- | --- | --- | --- | --- | --- |
| 3001 | 125 | 2001 | ACCT-SYN-001 | 1001 | ava.chen@example.test |

## 2. Find account records where customer_id matches 1001 (up to 20).

```sql
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 1001
ORDER BY "account_id"
LIMIT 20;
```

| account_id | customer_id | account_number | currency | balance | opened_on | status |
| --- | --- | --- | --- | --- | --- | --- |
| 2001 | 1001 | ACCT-SYN-001 | USD | 2500 | 2025-01-11 | active |

## 3. Count transfer records for each source_account_id (up to 20 groups).

```sql
SELECT "source_account_id", count(*) AS record_count
FROM portfolio."transfer"
GROUP BY "source_account_id"
ORDER BY record_count DESC, "source_account_id" NULLS LAST
LIMIT 20;
```

| source_account_id | record_count |
| --- | --- |
| 2001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.437 | 2.335, 4.501, 2.437 | Sort → Seq Scan | 274 |
| After index | 0.267 | 0.266, 0.267, 0.298 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.437 ms to 0.267 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.303..2.306 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.014..2.266 rows=50 loops=1)
Planning Time: 0.362 ms
Execution Time: 2.335 ms
```

### Before index, run 2

```text
Sort (actual time=4.446..4.45 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.035..4.39 rows=50 loops=1)
Planning Time: 0.615 ms
Execution Time: 4.501 ms
```

### Before index, run 3

```text
Sort (actual time=2.404..2.407 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.015..2.364 rows=50 loops=1)
Planning Time: 0.372 ms
Execution Time: 2.437 ms
```

### After index, run 1

```text
Sort (actual time=0.208..0.211 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.033..0.172 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.586 ms
Execution Time: 0.266 ms
```

### After index, run 2

```text
Sort (actual time=0.211..0.214 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.034..0.173 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.02..0.02 rows=50 loops=1)
Planning Time: 0.551 ms
Execution Time: 0.267 ms
```

### After index, run 3

```text
Sort (actual time=0.242..0.244 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.062..0.205 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.552 ms
Execution Time: 0.298 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Jimoh_Abosede_301907148_P2_Queries.sql, then Jimoh_Abosede_301907148_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Jimoh_Abosede_301907148_P2_QueryResults.png) · [Index comparison](screenshots/Jimoh_Abosede_301907148_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

