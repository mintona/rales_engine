# Rales Engine

## Description
Rales Engine is an API designed to expose fabricated sales data. It includes endpoints for records, relationships and business intelligence. There are six resources which can be queried through a variety of endpoints. The business intelligence endpoints were built with complex SQL and ActiveRecord queries and can be used for sales tracking.

## Use Rales Engine

### Implementation
* Install [Ruby 2.4.1](https://ruby-doc.org/core-2.4.1/)
* Install [Rails 5.2.4](https://guides.rubyonrails.org/v5.2/)
* Install [PostgreSQL](https://www.postgresql.org/docs/)
* Clone this repo with: `$ git clone git@github.com:mintona/rales_engine.git`
* Run the following commands to set-up the Rails app:
```
$ bundle install
$ bundle update
$ rails db:setup
```
* To import data to your development database:
```
$ rails import:merchants
$ rails import:customers
$ rails import:items
$ rails import:invoices
$ rails import:item_invoices
$ rails import:transactions
```
* Note: This application uses the following gems for testing, which are included in the gemfile and will instill upon `bundle install`:
   * `rspec-rails`
   * `shoulda-matchers`
   * `factory_bot_rails`

## Record Endpoints
There are 6 data categories (resources) in this API:
* Merchants
* Customers
* Items
* Invoices
* Invoice Items
* Transactions

### Index of Record
Each data category includes an index endpoint, which renders a JSON response containing all appropriate records:
* `GET /api/v1/merchants`
* `GET /api/v1/customers`
* `GET /api/v1/items`
* `GET /api/v1/invoices`
* `GET /api/v1/invoice_items`
* `GET /api/v1/transactions`

### Show Record
Each data category includes a show endpoint, which renders a JSON response of the appropriate record:
* `GET /api/v1/resource/:id`

### Search Capabilities
#### Single Finders
Each data category offers a find endpoint, which returns a single object. Find endpoints work with any attribute defined on the data type, as can been seen in the schema below:
* `GET /api/v1/resource/find?parameters`
* Example: `GET /api/v1/merchants/find?name=Schroeder-Jerde`
* Note: All single finders are case insensitive.
#### Multi-Finders
Each data category offers a find_all endpoint which yields all matches for the query.
* `GET /api/v1/resource/find_all?parameters`
* Note: All multi finders are case insensitive.
#### Random
Each data category offers a random endpoint, which returns a random object.
* `GET /api/v1/resource/random`

### Relationship Endpoints
The following relationship data can be obtained via the following endpoints:
#### Merchants
* `GET /api/v1/merchants/:id/items` returns a collection of items associated with that merchant
* `GET /api/v1/merchants/:id/invoices` returns a collection of invoices associated with that merchant from their known orders

#### Invoices
* `GET /api/v1/invoices/:id/transactions` returns a collection of associated transactions
* `GET /api/v1/invoices/:id/invoice_items` returns a collection of associated invoice items
* `GET /api/v1/invoices/:id/items` returns a collection of associated items
* `GET /api/v1/invoices/:id/customer` returns the associated customer
* `GET /api/v1/invoices/:id/merchant` returns the associated merchant

#### Invoice Items
* `GET /api/v1/invoice_items/:id/invoice` returns the associated invoice
* `GET /api/v1/invoice_items/:id/item` returns the associated item

#### Items
* `GET /api/v1/items/:id/invoice_items` returns a collection of associated invoice items
* `GET /api/v1/items/:id/merchant` returns the associated merchant

#### Transactions
* `GET /api/v1/transactions/:id/invoice` returns the associated invoice

#### Customers
* `GET /api/v1/customers/:id/invoices` returns a collection of associated invoices
* `GET /api/v1/customers/:id/transactions` returns a collection of associated transactions

### Business Intelligence Endpoints
Specified business logic queries can be accessed from the following endpoints:

* `GET /api/v1/merchants/most_revenue?quantity=x` returns the top x merchants ranked by total revenue
* `GET /api/v1/merchants/revenue?date=x` returns the total revenue for date x across all merchants
* `GET /api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the most total number of successful transactions.
* `GET /api/v1/items/most_revenue?quantity=x` returns the top x items ranked by total revenue generated
* `GET /api/v1/items/:id/best_day returns` the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.
* `GET /api/v1/customers/:id/favorite_merchant` returns a merchant where the customer has conducted the most successful transactions

## Testing
Rales Engine was developed using Test Driven Development. The test suite is written with [RSpec](https://github.com/rspec/rspec). All models were tested at the model level and controllers with controller testing. Factory Bot was used on all models to speed up testing.

To run the entire test suite:

`$ rspec`

To run controller tests only:

`$ rspec spec/requests`

To run model tests only:

`$ rspec spec/models`

## Schema
A PostreSQL database is used for this project, composed of 6 separate resource tables.

The schema is depicted below:
![alt text](https://github.com/mintona/rales_engine/blob/master/db/schema_photo.png "Rales Engine Schema")
