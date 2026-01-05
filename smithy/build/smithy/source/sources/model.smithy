$version: "2"
namespace example.items

use smithy.api#cors
use smithy.api#title
use smithy.api#http
use smithy.api#httpQuery
use smithy.api#httpError
use smithy.api#error
use smithy.api#readonly
use smithy.api#idempotent
use aws.protocols#restJson1


@title("Items Service")
@cors
@restJson1
service ItemsService {
  version: "2026-01-04"
  operations: [ListItems, GetItem, CreateItem, UpdateItem, DeleteItem]
}

structure Item {
  @required id: String
  @required title: String
  description: String
  @required owner_id: String
}

list ItemList { member: Item }

structure ItemsList {
  @required data: ItemList
  @required count: Integer
}

structure Message {
  @required message: String
}

structure CreateItemInput {
  @required title: String
  description: String
}

structure UpdateItemInput {
  @httpLabel
  @required id: String
  title: String
  description: String
}

structure GetItemInput {
  @httpLabel
  @required id: String
}

structure DeleteItemInput {
  @httpLabel
  @required id: String
}

structure ListItemsInput {
  @httpQuery("skip")  skip: Integer = 0
  @httpQuery("limit") limit: Integer = 100
}

@readonly
@http(method: "GET", uri: "/api/v1/items", code: 200)
operation ListItems {
  input: ListItemsInput
  output: ItemsList
  errors: [UnauthorizedError, ForbiddenError]
}

@readonly
@http(method: "GET", uri: "/api/v1/items/{id}", code: 200)
operation GetItem {
  input: GetItemInput
  output: Item
  errors: [NotFoundError, UnauthorizedError, ForbiddenError]
}

@http(method: "POST", uri: "/api/v1/items", code: 201)
operation CreateItem {
  input: CreateItemInput
  output: Item
  errors: [ValidationError, UnauthorizedError]
}

@idempotent
@http(method: "PUT", uri: "/api/v1/items/{id}", code: 200)
operation UpdateItem {
  input: UpdateItemInput
  output: Item
  errors: [NotFoundError, ValidationError, UnauthorizedError, ForbiddenError]
}

@idempotent
@http(method: "DELETE", uri: "/api/v1/items/{id}", code: 200)
operation DeleteItem {
  input: DeleteItemInput
  output: Message
  errors: [NotFoundError, UnauthorizedError, ForbiddenError]
}

@error("client")
@httpError(400)
structure ValidationError { @required detail: String }

@error("client")
@httpError(404)
structure NotFoundError { @required detail: String }

@error("client")
@httpError(401)
structure UnauthorizedError { @required detail: String }

@error("client")
@httpError(403)
structure ForbiddenError { @required detail: String }
