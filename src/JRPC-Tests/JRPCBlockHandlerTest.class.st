"
A JRPCBlockHandlerTest is a test class for testing the behavior of JRPCBlockHandler
"
Class {
	#name : #JRPCBlockHandlerTest,
	#superclass : #TestCase,
	#category : #'JRPC-Tests'
}

{ #category : #test }
JRPCBlockHandlerTest >> testCheckParametersForRequest [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x | ].
	self should: [ 
		handler checkParametersForRequest: JRPCRequestObject new
	] raise: JRPCInvalidParameters.
	
	self should: [ 
		handler checkParametersForRequest: (JRPCRequestObject new params: #(1 2); yourself)
	] raise: JRPCInvalidParameters.

	self should: [ 
		handler checkParametersForRequest: (JRPCRequestObject new params: { #x -> 1 . #y -> 2 } asDictionary; yourself)
	] raise: JRPCInvalidParameters.
	
	self should: [ 
		handler checkParametersForRequest: (JRPCRequestObject new params: { #y -> 1 } asDictionary; yourself)
	] raise: JRPCInvalidParameters.
	
	"The two next will not raise error."
	handler checkParametersForRequest: (JRPCRequestObject new params: #(1); yourself).
		
	handler checkParametersForRequest: (JRPCRequestObject new params: { #x -> 1 } asDictionary; yourself)
]

{ #category : #test }
JRPCBlockHandlerTest >> testExecuteWithArgumentsBeingArray [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assertCollection: (handler executeWithArguments: #(1 2)) equals: 3
]

{ #category : #test }
JRPCBlockHandlerTest >> testExecuteWithArgumentsDictionary [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assertCollection: (handler executeWithArguments: { 'x' -> 1. 'y' -> 2 } asDictionary) equals: 3
]

{ #category : #test }
JRPCBlockHandlerTest >> testParametersCount [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assert: handler parametersCount equals: 2
]

{ #category : #test }
JRPCBlockHandlerTest >> testParametersNames [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assertCollection: handler parametersNames equals: #(#x #y)
]

{ #category : #test }
JRPCBlockHandlerTest >> testUnnamedBlockHandlerRaiseErrorWhenMethodNameIsAsked [
	| handler |
	handler := JRPCBlockHandler new
					block: [ :x :y | x + y ];
					yourself.
					
	self should: [ handler methodName ] raise: Error withExceptionDo: [ :error |
		error description = 'It is mandatory to specify the #methodName of a block handler via #methodName: method on instance side.' ]
]

{ #category : #test }
JRPCBlockHandlerTest >> testCheckParametersForRequestAcceptsASubsetOfTheNamedParameters [

	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y |  ].

	"A procedure may have optional parameters, so a by-name request is free to
	 name only some of them, and to name none of them at all."
	handler checkParametersForRequest: (JRPCRequestObject new
			 params: { (#x -> 1) } asDictionary;
			 yourself).
	handler checkParametersForRequest: (JRPCRequestObject new
			 params: { (#y -> 2) } asDictionary;
			 yourself).
	handler checkParametersForRequest: (JRPCRequestObject new
			 params: Dictionary new;
			 yourself).

	"A name the procedure does not declare is still invalid."
	self
		should: [
				handler checkParametersForRequest: (JRPCRequestObject new
						 params: { (#z -> 3) } asDictionary;
						 yourself) ]
		raise: JRPCInvalidParameters
]

{ #category : #test }
JRPCBlockHandlerTest >> testCheckParametersForRequestRejectsParametersThatAreNeitherListNorDictionary [

	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x |  ].

	self
		should: [
				handler checkParametersForRequest: (JRPCRequestObject new
						 params: 'bar';
						 yourself) ]
		raise: JRPCInvalidParameters
]

{ #category : #test }
JRPCBlockHandlerTest >> testExecuteWithArgumentsPlacesNamedParametersByName [

	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y |
			           {
				           x.
				           y } ].

	"A parameter the request leaves out is passed as nil, and the ones it does
	 name keep their own position rather than shifting into the gap."
	self assertCollection: (handler executeWithArguments: { ('y' -> 2) } asDictionary) equals: { nil. 2 }.
	self assertCollection: (handler executeWithArguments: { ('x' -> 1) } asDictionary) equals: { 1. nil }.
	self assertCollection: (handler executeWithArguments: Dictionary new) equals: { nil. nil }
]
