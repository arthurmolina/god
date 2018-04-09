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
 - Rails API v5.1.5
 - GraphQL
 - PostgreSQL v9.6.6 (older version can be used)

## API Documentation

The API documentation and interaction is available here: http://localhost:3000/gq

### Authentication

To create a user:

    $ curl -H "Content-Type: application/json" -X POST -d '{"query":"mutation signUp($name: String, $email: String, $password: String, $purchase_channel_id: Int){\n  sign_up(name: $name, email: $email, password: $password, password_confirmation:$password, purchase_channel_id: $purchase_channel_id) {\n    name\n    token\n  }\n}\n","variables":{"name":"Arthur","email":"arthurmolina@gmail.com","password":"123","purchase_channel_id":1},"operationName":"signUp"}' http://localhost:3000/graphql

User has four roles: admin, stores, production, transportation.

To login:

    $ curl -H "Content-Type: application/json" -X POST -d '{"query":"mutation login($email: String, $password: String){\n  login(email: $email, password: $password) {\n    name\n    token\n  }\n}\n","variables":{"email":"arthurmolina@gmail.com","password":"123","purchase_channel_id":1},"operationName":"login"}

It will receive a token that can be used as _Header: Authorization_ or as a variable _"Authorization"_.

### Queries

    $ curl -H "Authorization: <access_token>" http://localhost:3000/graphql

## Test

Just run:

    $ rspec

