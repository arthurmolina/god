# GOD - Gocase Order Dispatcher

## Instalation

Download or clone this repo

    git clone 

Must setup the database in `config/databased.yml` and then execute:

    $ bundle install
    $ rails db:create db:migrate db:seed

To run the application:

    $ rails s

## Stack used in this project

 - Ruby v2.5.0
 - Rails API v5.1.6
 - GraphQL
 - PostgreSQL v9.6.6 (older version can be used)

## API Documentation

The API documentation and interaction is available here: http://localhost:3000/gq

### Authentication

To create a user:

    $ curl -H "Content-Type: application/json" -X POST -d '{"query":"mutation signUp($name: String, $email: String, $password: String, $purchase_channel_id: Int){\n  sign_up(name: $name, email: $email, password: $password, password_confirmation:$password, purchase_channel_id: $purchase_channel_id) {\n    name\n    token\n  }\n}\n","variables":{"name":"Arthur","email":"arthurmolina@gmail.com","password":"123","purchase_channel_id":1},"operationName":"signUp"}' http://localhost:3000/graphql

User has four roles: admin, stores, production, transportation.

To login:

    $ curl -H "Content-Type: application/json" -X POST -d '{"query":"mutation login($email: String, $password: String){\n  login(email: $email, password: $password) {\n    name\n    token\n  }\n}\n","variables":{"email":"arthurmolina@gmail.com","password":"123","purchase_channel_id":1},"operationName":"login"}' http://localhost:3000/graphql

Getting this result:

    {"data":{"login":{"name":"ArtzAdmin","token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MjM0MDgzMjZ9.YPIfnK5nyM94VDW0725cXhZ-ekRxs2wdcXNsRP9Ynk4"}}}

It will receive a token that can be used as _Header: Authorization_ or as a variable _"Authorization"_.

### Queries

We have 16 queries. This query get a list of two batches with some information and the order _BR691322_:

    $ curl -H "Content-Type: application/json" -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MjM0MDgzMjZ9.YPIfnK5nyM94VDW0725cXhZ-ekRxs2wdcXNsRP9Ynk4" -X POST -d '{"query":"{\n  batches(first: 2, after: \"Mg==\", sortBy: createdAt_ASC, filter: {status: production}){\n    pageInfo{\n      hasNextPage\n      hasPreviousPage\n      startCursor\n      endCursor\n    }\n    edges{\n      node{\n        reference\n        id\n        status\n        errors\n        orders{\n          edges{\n            node{\n              id\n              reference\n            }\n          }\n        }\n      }\n    }\n  },\n  order(reference: \"BR691322\") {\n    batch_id\n    total_value\n  },\n}\n","variables":{"Authorization":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MjM0MDgzMjZ9.YPIfnK5nyM94VDW0725cXhZ-ekRxs2wdcXNsRP9Ynk4"},"operationName":null}' http://localhost:3000/graphql

## Workflow in Action

1. Create a new Order

    mutation creatingANewOrder{
      createOrder(reference: "BR2018042", purchase_channel_id: 1, client_id: 5, delivery_service_id: 2, total_value: 123.20, line_items: " [{sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}, {sku: powebank-sunshine, capacity: 10000mah}, {sku: earphone-standard, color: white}]"){
        reference
        status
      }
    }

Result:

    {
      "data": {
        "createOrder": {
          "reference": "BR2018042",
          "status": "new_order"
        }
      }
    }

2. Get the status of an Order

    {
      order(reference: "BR2018042") {
        status
      }
    }

Result: 

    {
      "data": {
        "order": {
          "status": "new_order"
        }
      }
    }

3. List the Orders of a Purchase Channel

    {
      orders(first: 2, filter: {purchase_channel_id: 1, only_not_associated_to_batch: true}) {
        edges{
          node{
            id
            reference
            total_value
            purchase_channel{
              name
            }
          }
        }
      }
    }

Result:

    {
      "data": {
        "orders": {
          "edges": [
            {
              "node": {
                "id": "T3JkZXItNTE=",
                "reference": "BR2018042",
                "total_value": 123.2,
                "purchase_channel": {
                  "name": "Site BR"
                }
              }
            },
            {
              "node": {
                "id": "T3JkZXItMQ==",
                "reference": "BR372785",
                "total_value": 53.12,
                "purchase_channel": {
                  "name": "Site BR"
                }
              }
            }
          ]
        }
      }
    }

4. Create a Batch

    mutation createABatch {
      createBatch(reference: "BR2018BATCH", order_references: ["BR2018042", "BR372785"]) {
        reference
        status
        purchase_channel{
          name
        }
      }
    }

Result: 
    {
      "data": {
        "createBatch": {
          "reference": "BR2018BATCH",
          "status": "production",
          "purchase_channel": {
            "name": "Site BR"
          }
        }
      }
    }

5. Produce a Batch

    mutation produceABatch {
      changeStatusBatch(reference: "BR2018BATCH", status: closing) {
        reference
        status
        purchase_channel{
          name
        }
      }
    }

Result:

    {
      "data": {
        "changeStatusBatch": {
          "reference": "BR2018BATCH",
          "status": "closing",
          "purchase_channel": {
            "name": "Site BR"
          }
        }
      }
    }

6. Close part of a Batch for a Delivery Service

    mutation produceABatch {
      changeStatusBatch(reference: "BR2018BATCH", status: sent) {
        reference
        status
        purchase_channel{
          name
        }
      }
    }

Result:

    {
      "data": {
        "changeStatusBatch": {
          "reference": "BR2018BATCH",
          "status": "sent",
          "purchase_channel": {
            "name": "Site BR"
          }
        }
      }
    }

7. A simple financial report

    {
      report(year: 2018, month: Apr, purchase_channel_id: 1) {
        id
        orders
        reference
        status
        total_value
      },
      reportSummary(year: 2018, purchase_channel_agregated: true){
        month
        orders
        purchase_channel{
          id
          name
        }
        total_value
      }
    }

Result: 

    {
      "data": {
        "report": [
          {
            "id": "QmF0Y2hSZXBvcnQtMTE=",
            "orders": 2,
            "reference": "BR2018BATCH",
            "status": "sent",
            "total_value": 176.32
          }
        ],
        "reportSummary": [
          {
            "month": 4,
            "orders": 2,
            "purchase_channel": {
              "id": "UHVyY2hhc2VDaGFubmVsLTE=",
              "name": "Site BR"
            },
            "total_value": 176.32
          },
          {
            "month": 4,
            "orders": 3,
            "purchase_channel": {
              "id": "UHVyY2hhc2VDaGFubmVsLTU=",
              "name": "Twitter BR"
            },
            "total_value": 156.23
          },
          {
            "month": 4,
            "orders": 2,
            "purchase_channel": {
              "id": "UHVyY2hhc2VDaGFubmVsLTc=",
              "name": "Iguatemi Store"
            },
            "total_value": 37.87
          },
          {
            "month": 4,
            "orders": 3,
            "purchase_channel": {
              "id": "UHVyY2hhc2VDaGFubmVsLTk=",
              "name": "Grand Plaza Store"
            },
            "total_value": 153.01
          }
        ]
      }
    }

## Test

Just run:

    $ rspec

