Class {
	#name : 'JRPCMockHandler',
	#superclass : 'JRPCPragmaHandler',
	#category : 'JRPC-Tests',
	#package : 'JRPC-Tests'
}

{ #category : 'accessing' }
JRPCMockHandler class >> defaultMethodName [

	^ 'mock'
]

{ #category : 'adding' }
JRPCMockHandler >> add: x with: y [

	<jrpc>
	^ x + y
]
