// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("transfer_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("transfer_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "transfer_requested",
                    "transfer_posted"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "transfer"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "transfer_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("transfer_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_requested",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 3001
            },
            "snapshot": {
                "transfer_id": 3001,
                "source_account_id": 2001,
                "destination_account_id": 2002,
                "amount": 125,
                "currency": "USD",
                "created_at": "2025-03-01T10:30:00Z",
                "status": "posted"
            }
        },
        "embedded": {
            "account": [
                {
                    "key": {
                        "account_id": 2001
                    },
                    "snapshot": {
                        "account_id": 2001,
                        "customer_id": 1001,
                        "account_number": "ACCT-SYN-001",
                        "currency": "USD",
                        "balance": 2500,
                        "opened_on": "2025-01-11",
                        "status": "active"
                    },
                    "via": [
                        "transfer.source_account_id → account"
                    ]
                },
                {
                    "key": {
                        "account_id": 2002
                    },
                    "snapshot": {
                        "account_id": 2002,
                        "customer_id": 1002,
                        "account_number": "ACCT-SYN-002",
                        "currency": "USD",
                        "balance": 875,
                        "opened_on": "2025-02-15",
                        "status": "active"
                    },
                    "via": [
                        "transfer.destination_account_id → account"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_posted",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 3001
            },
            "snapshot": {
                "transfer_id": 3001,
                "source_account_id": 2001,
                "destination_account_id": 2002,
                "amount": 125,
                "currency": "USD",
                "created_at": "2025-03-01T10:30:00Z",
                "status": "posted"
            }
        },
        "embedded": {
            "account": [
                {
                    "key": {
                        "account_id": 2001
                    },
                    "snapshot": {
                        "account_id": 2001,
                        "customer_id": 1001,
                        "account_number": "ACCT-SYN-001",
                        "currency": "USD",
                        "balance": 2500,
                        "opened_on": "2025-01-11",
                        "status": "active"
                    },
                    "via": [
                        "transfer.source_account_id → account"
                    ]
                },
                {
                    "key": {
                        "account_id": 2002
                    },
                    "snapshot": {
                        "account_id": 2002,
                        "customer_id": 1002,
                        "account_number": "ACCT-SYN-002",
                        "currency": "USD",
                        "balance": 875,
                        "opened_on": "2025-02-15",
                        "status": "active"
                    },
                    "via": [
                        "transfer.destination_account_id → account"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "metadata": "illustrative metadata",
                "provider_reference": "illustrative provider_reference"
            }
        }
    }
]));
  await db.getCollection("transfer_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("transfer_events").find({"eventType":"transfer_requested"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("transfer_events").find({"source.key.transfer_id":3001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("transfer_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("transfer_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("transfer_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transfer_requested",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "transfer_id": 3001
        },
        "snapshot": {
            "transfer_id": 3001,
            "source_account_id": 2001,
            "destination_account_id": 2002,
            "amount": 125,
            "currency": "USD",
            "created_at": "2025-03-01T10:30:00Z",
            "status": "posted"
        }
    },
    "embedded": {
        "account": [
            {
                "key": {
                    "account_id": 2001
                },
                "snapshot": {
                    "account_id": 2001,
                    "customer_id": 1001,
                    "account_number": "ACCT-SYN-001",
                    "currency": "USD",
                    "balance": 2500,
                    "opened_on": "2025-01-11",
                    "status": "active"
                },
                "via": [
                    "transfer.source_account_id → account"
                ]
            },
            {
                "key": {
                    "account_id": 2002
                },
                "snapshot": {
                    "account_id": 2002,
                    "customer_id": 1002,
                    "account_number": "ACCT-SYN-002",
                    "currency": "USD",
                    "balance": 875,
                    "opened_on": "2025-02-15",
                    "status": "active"
                },
                "via": [
                    "transfer.destination_account_id → account"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("transfer_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transfer_requested",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "transfer_id": 3001
        },
        "snapshot": {
            "transfer_id": 3001,
            "source_account_id": 2001,
            "destination_account_id": 2002,
            "amount": 125,
            "currency": "USD",
            "created_at": "2025-03-01T10:30:00Z",
            "status": "posted"
        }
    },
    "embedded": {
        "account": [
            {
                "key": {
                    "account_id": 2001
                },
                "snapshot": {
                    "account_id": 2001,
                    "customer_id": 1001,
                    "account_number": "ACCT-SYN-001",
                    "currency": "USD",
                    "balance": 2500,
                    "opened_on": "2025-01-11",
                    "status": "active"
                },
                "via": [
                    "transfer.source_account_id → account"
                ]
            },
            {
                "key": {
                    "account_id": 2002
                },
                "snapshot": {
                    "account_id": 2002,
                    "customer_id": 1002,
                    "account_number": "ACCT-SYN-002",
                    "currency": "USD",
                    "balance": 875,
                    "opened_on": "2025-02-15",
                    "status": "active"
                },
                "via": [
                    "transfer.destination_account_id → account"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("transfer_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
