"
I test that a stream client writes the request as it is and reads the answer back, which is what lets a subclass frame the bytes for a transport that asks for it.
"
Class {
	#name : 'JRPCStreamClientTest',
	#superclass : 'TestCase',
	#category : 'JRPC-Tests',
	#package : 'JRPC-Tests'
}

{ #category : 'tests' }
JRPCStreamClientTest >> testASubclassCanTunnelTheRequestInAnotherProtocol [
	"#sendRequestContent: is handed the serialized request and answers what the
	 server sent, so a transport that frames its payloads does so there. This is
	 what the language server protocol needs, and what issue #39 asked for."

	| written client answer payload body |
	body := '{"jsonrpc":"2.0","result":19,"id":1}'.
	written := WriteStream on: String new.
	client := JRPCMockFramedClient
		          writeStream: written
		          readStream:
		          ('Content-Length: ' , body size asString , (String with: Character lf with: Character lf) , body) readStream
		          requestsSeparator: ''.

	answer := client callMethod: 'subtract' arguments: #( 42 23 ) withId: 1.

	self assert: (written contents beginsWith: 'Content-Length: ').
	payload := client unframe: written contents.
	self assert: ((STONJSON fromString: payload) at: 'method') equals: 'subtract'.

	self assert: answer class equals: JRPCSuccessResponseObject.
	self assert: answer result equals: 19
]

{ #category : 'tests' }
JRPCStreamClientTest >> testWritesTheRequestAsItIsAndParsesTheAnswer [

	| written client answer sent |
	written := WriteStream on: String new.
	client := JRPCStreamClient
		          writeStream: written
		          readStream: '{"jsonrpc":"2.0","result":19,"id":1}' readStream
		          requestsSeparator: (String with: Character lf).

	answer := client callMethod: 'subtract' arguments: #( 42 23 ) withId: 1.

	"The request goes out as the JSON object itself, not as a JSON string holding it."
	sent := written contents.
	self assert: (sent endsWith: (String with: Character lf)).
	sent := STONJSON fromString: sent trimBoth.
	self assert: (sent at: 'method') equals: 'subtract'.
	self assertCollection: (sent at: 'params') equals: #( 42 23 ).
	self assert: (sent at: 'id') equals: 1.

	self assert: answer class equals: JRPCSuccessResponseObject.
	self assert: answer result equals: 19
]
