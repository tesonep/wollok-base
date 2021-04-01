Class {
	#name : #WollokCatchNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'catchToken',
		'exceptionVarName',
		'expression',
		'colonToken',
		'exceptionType'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokCatchNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitCatch: self
]

{ #category : #generated }
WollokCatchNode >> catchToken [
	^ catchToken
]

{ #category : #generated }
WollokCatchNode >> catchToken: aSmaCCToken [
	catchToken := aSmaCCToken
]

{ #category : #generated }
WollokCatchNode >> colonToken [
	^ colonToken
]

{ #category : #generated }
WollokCatchNode >> colonToken: aSmaCCToken [
	colonToken := aSmaCCToken
]

{ #category : #generated }
WollokCatchNode >> exceptionType [
	^ exceptionType
]

{ #category : #generated }
WollokCatchNode >> exceptionType: aWollokQualifiedNameNode [
	self exceptionType notNil
		ifTrue: [ self exceptionType parent: nil ].
	exceptionType := aWollokQualifiedNameNode.
	self exceptionType notNil
		ifTrue: [ self exceptionType parent: self ]
]

{ #category : #generated }
WollokCatchNode >> exceptionVarName [
	^ exceptionVarName
]

{ #category : #generated }
WollokCatchNode >> exceptionVarName: aWollokVariableNode [
	self exceptionVarName notNil
		ifTrue: [ self exceptionVarName parent: nil ].
	exceptionVarName := aWollokVariableNode.
	self exceptionVarName notNil
		ifTrue: [ self exceptionVarName parent: self ]
]

{ #category : #generated }
WollokCatchNode >> expression [
	^ expression
]

{ #category : #generated }
WollokCatchNode >> expression: aWollokAbstractNodeNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aWollokAbstractNodeNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
WollokCatchNode >> nodeVariables [
	^ #(#exceptionVarName #expression #exceptionType)
]

{ #category : #generated }
WollokCatchNode >> tokenVariables [
	^ #(#catchToken #colonToken)
]
