# Examples
## Client
Given a server using HTTP protocol, listening on port 4000 and exposing `'sqrt'` method which computes the square-root of its single parameter, one can write the following:

```smalltalk
(JRPCClient http: 'http://localhost:4000')
	callMethod: 'sqrt' arguments: #(4) withId: 1
```

The object returned by this expression is an instance of `JRPCSuccessResponseObject`.
Its `result` instance variable contains the result of `sqrt` method applied on `4`. That is to say, it contains `2.0`.
Its `id` instance variable contains the `id` specified previously.

Ids map the responses returned by the server to the requests sent by the client.
Ids are managed by the developer using the client.

## Server
To create a server using HTTP protocol, listening on port 4000 and defining a handler for `'sqrt'` which computes the square-root of its single parameter, one can write the following:

```smalltalk
server := JRPCServer http
		port: 4000;
		addHandlerNamed: 'sqrt' block: [ :x | x sqrt ];
		yourself.
```

To start it, send it `#start`:

```smalltalk
server start
```

To stop it, send it `#stop`:

```smalltalk
server stop
```

## Additional data provided in error messages
[JSON-RPC 2.0 specification](https://www.jsonrpc.org/specification) specifies that in error messages, a `data` field can optionally be set to provide additional information about the error. However, this field structure is specified by the server. This section describes what the current implementation stores in the `data` field.

**A server does not send it unless you ask.** What it describes is the inside
of the image, and the clients of a JSON-RPC server have no business knowing
any of that, so `includesErrorData` is off and errors answer a code and a
message alone. Turn it on where the clients are your own:

```smalltalk
server := JRPCServer http
  port: 4000;
  includesErrorData: true;
  addHandlerNamed: 'divide' block: [ :x :y | x / y ];
  yourself.

server start.
```

This server has a handler implementing the division of `x` by `y`. In Pharo, dividing a `Number` by `0` results in a `ZeroDivide` error. Thus, the following code:

```smalltalk
(JRPCClient http: 'http://localhost:4000')
	callMethod: 'divide' arguments: #(1 0) withId: 1.
```

Will result in a JSON-RPC error that looks like this:

```json
{
	"jsonrpc" : "2.0",
	"id" : 1,
	"error" : {
		"data" : {
			"tag" : "",
			"errorClass" : "ZeroDivide",
			"signalerContext" : "SmallInteger>>/",
			"messageText" : "",
			"signaler" : "1"
		},
		"message" : "Internal JSON-RPC error.",
		"code" : -32603
	}
}
```

Mind the `data` sub-field inside the `error` field. It contains additional data about the error for which the structure is defined by this particular implementation.

The structure is the following:
```js
{
  "errorClass" : String, // The class of the Pharo error.
  "signaler" : String, // The object to which the message was sent when the error occurred.
  "signalerContext" : String, // The method in which the error was raised, formatted as Class>>method
  "messageText" : String, // The message the Pharo error holds.
  "tag" : String // The tag of the Pharo error.
}
```
