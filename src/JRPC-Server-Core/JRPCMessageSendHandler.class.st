"
I am an handler that, when executed, sends the message with selector #messageSelector to the #receiver.

For example,

JRPCMessageSendHandler new
	methodName: 'plus';
	messageSelector: #+;
	receiver: 1;
	yourself
	
Will the send #+ message to the instance of SmallInteger 1 with the arguments provided.
"
Class {
	#name : 'JRPCMessageSendHandler',
	#superclass : 'JRPCAbstractHandler',
	#instVars : [
		'receiver',
		'messageSelector'
	],
	#category : 'JRPC-Server-Core',
	#package : 'JRPC-Server-Core'
}

{ #category : 'parameters-checking' }
JRPCMessageSendHandler >> checkParametersForRequest: aJRPCRequestObject [
	"Positional parameters must match the procedure's arity: there is no way to
	 leave one out and still say which the others are. Named parameters may give
	 a subset of them, so that a procedure can have optional parameters, but every
	 name given must be one the procedure declares."

	| params names |
	params := aJRPCRequestObject params.
	params ifNil: [
			self parametersCount = 0 ifFalse: [ JRPCInvalidParameters signal ].
			^ self ].

	params isDictionary ifFalse: [
			(params isArray and: [ params size = self parametersCount ]) ifFalse: [ JRPCInvalidParameters signal ].
			^ self ].

	names := self parametersNames collect: [ :each | each asString ].
	params keysDo: [ :each | (names includes: each asString) ifFalse: [ JRPCInvalidParameters signal ] ]
]

{ #category : 'evaluation' }
JRPCMessageSendHandler >> executeWithArguments: anArrayOrDictionary [
	"Named parameters are placed by name, so a parameter the request leaves out
	 is passed as nil rather than shifting the ones that follow it into its place."

	| arguments |
	arguments := anArrayOrDictionary isDictionary
		             ifTrue: [ self parametersNames collect: [ :each | anArrayOrDictionary at: each asString ifAbsent: [ nil ] ] ]
		             ifFalse: [ anArrayOrDictionary ifNil: [ #(  ) ] ].

	^ self send: self messageSelector to: self receiver with: arguments
]

{ #category : 'accessing' }
JRPCMessageSendHandler >> messageSelector [

	^ messageSelector
]

{ #category : 'accessing' }
JRPCMessageSendHandler >> messageSelector: anObject [

	messageSelector := anObject
]

{ #category : 'accessing' }
JRPCMessageSendHandler >> parametersCount [
	"Returns the number of parameters expected by the handler."

	^ self parametersNames size
]

{ #category : 'accessing' }
JRPCMessageSendHandler >> parametersNames [
	"The procedure's parameter names, in the order it takes them.
	 The selector is looked up through the hierarchy, so a receiver
	 may inherit the method that implements the procedure."

	^ (self receiver class lookupSelector: self messageSelector) argumentNames
]

{ #category : 'accessing' }
JRPCMessageSendHandler >> receiver [

	^ receiver
]

{ #category : 'accessing' }
JRPCMessageSendHandler >> receiver: anObject [

	receiver := anObject
]

{ #category : 'private' }
JRPCMessageSendHandler >> send: aSelector to: aReceiver with: arguments [

	^ aReceiver perform: aSelector withArguments: arguments
]
