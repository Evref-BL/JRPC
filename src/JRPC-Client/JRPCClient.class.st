"
I am an abstract client for JSON-RPC 2.0.

My subclasses define how to transmit JSON-RPC objects to a server.

To define that, #sendRequestContent: should be overriden by my subclasses. It is given the serialized request and answers what the server sent back, so a subclass only moves bytes and may frame them however its transport asks.
"
Class {
	#name : 'JRPCClient',
	#superclass : 'Object',
	#traits : 'JRPCParser',
	#classTraits : 'JRPCParser classTrait',
	#category : 'JRPC-Client',
	#package : 'JRPC-Client'
}

{ #category : 'instance creation' }
JRPCClient class >> http: aString [

	^ JRPCHTTPClient url: aString
]

{ #category : 'instance creation' }
JRPCClient class >> tcp [

	^ JRPCTCPClient new
]

{ #category : 'instance creation' }
JRPCClient class >> tcpForAddress: aSocketAddress port: anInteger [

	^ JRPCTCPClient new
		  address: aSocketAddress;
		  port: anInteger;
		  yourself
]

{ #category : 'api' }
JRPCClient >> callMethod: aString arguments: anObject withId: anInteger [
	"Call a method which takes arguments."

	^ self sendRequest: (JRPCRequestObject new
			   id: anInteger;
			   method: aString;
			   params: anObject;
			   yourself)
]

{ #category : 'api' }
JRPCClient >> callMethod: aString withId: anInteger [
	"Call a method which takes no arguments."

	^ self callMethod: aString arguments: nil withId: anInteger
]

{ #category : 'converting' }
JRPCClient >> convertJRPCJsonableObjectToJSON: aJRPCJsonableObject [

	^ String streamContents: [ :stream | self convertJRPCJsonableObjectToJSON: aJRPCJsonableObject asJRPCJSON on: stream ]
]

{ #category : 'testing' }
JRPCClient >> isClient [
	"Returns true if the trait is used in the context of a client, false in the context of a server."

	^ true
]

{ #category : 'api' }
JRPCClient >> notifyMethod: aString [

	self notifyMethod: aString arguments: nil
]

{ #category : 'api' }
JRPCClient >> notifyMethod: aString arguments: anArrayOrString [

	self sendNotification: (JRPCNotificationObject new
			 method: aString;
			 params: anArrayOrString;
			 yourself)
]

{ #category : 'private - sending' }
JRPCClient >> sendNotification: aJRPCNotificationObject [
	"When a notification is sent to the server, we do not expect an answer."

	[ self sendRequest: aJRPCNotificationObject ]
		on: JRPCIncorrectJSON , STONReaderError
		do: [ "Does nothing on purpose." ]
]

{ #category : 'private - sending' }
JRPCClient >> sendRequest: aJRPCRequestObject [
	"Sends aJRPCRequestObject to the server to which the client is connected.
	 Returns a JRPCSuccessResponseObject if everything goes well.
	 Returns a JRPCErrorResponseObject if something went wrong."

	^ self parseSupposedJRPCMessageObjectFromString:
		  (self sendRequestContent: (self convertJRPCJsonableObjectToJSON: aJRPCRequestObject))
]

{ #category : 'private - sending' }
JRPCClient >> sendRequestContent: aString [
	"To be implemented by concrete subclasses.
	 Sends aString, which holds a serialized JSON-RPC object, to the server the
	 client is connected to, and answers the String the server sent back.

	 Serializing and parsing happen in #sendRequest:, so a subclass only moves
	 bytes, and is free to wrap aString in whatever framing its transport asks
	 for, such as the header part the language server protocol puts in front."

	^ self subclassResponsibility
]
