Class {
	#name : #WollokSelfDelegatingConstructorCallNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'selfToken',
		'leftParenToken',
		'rightParenToken',
		'argumentList'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitSelfDelegatingConstructorCall: self
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> argumentList [
	^ argumentList
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> argumentList: aWollokPositionalArgumentsListNode [
	self argumentList notNil
		ifTrue: [ self argumentList parent: nil ].
	argumentList := aWollokPositionalArgumentsListNode.
	self argumentList notNil
		ifTrue: [ self argumentList parent: self ]
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> nodeVariables [
	^ #(#argumentList)
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> selfToken [
	^ selfToken
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> selfToken: aSmaCCToken [
	selfToken := aSmaCCToken
]

{ #category : #generated }
WollokSelfDelegatingConstructorCallNode >> tokenVariables [
	^ #(#selfToken #leftParenToken #rightParenToken)
]
