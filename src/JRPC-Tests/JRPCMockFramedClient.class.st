"
I am a stream client that tunnels JSON-RPC inside another protocol's framing, the way the language server protocol puts a header part in front of the payload.

I exist to show that framing is a subclass's business: #sendRequestContent: is given the serialized request and answers what the server sent, so everything between the two is mine to decide.
"
Class {
	#name : 'JRPCMockFramedClient',
	#superclass : 'JRPCStreamClient',
	#category : 'JRPC-Tests',
	#package : 'JRPC-Tests'
}

{ #category : 'private - sending' }
JRPCMockFramedClient >> frame: aString [

	^ String streamContents: [ :stream |
			  stream
				  nextPutAll: 'Content-Length: ';
				  nextPutAll: aString size asString;
				  nextPutAll: self headerSeparator;
				  nextPutAll: aString ]
]

{ #category : 'private - sending' }
JRPCMockFramedClient >> headerSeparator [

	^ String with: Character lf with: Character lf
]

{ #category : 'private - sending' }
JRPCMockFramedClient >> sendRequestContent: aString [

	^ self unframe: (super sendRequestContent: (self frame: aString))
]

{ #category : 'private - sending' }
JRPCMockFramedClient >> unframe: aString [

	| separator |
	separator := aString indexOfSubCollection: self headerSeparator.
	separator = 0 ifTrue: [ ^ aString ].
	^ aString allButFirst: separator + self headerSeparator size - 1
]
