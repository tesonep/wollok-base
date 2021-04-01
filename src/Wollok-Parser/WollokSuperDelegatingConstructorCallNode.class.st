Class {
	#name : #WollokSuperDelegatingConstructorCallNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'superToken',
		'leftParenToken',
		'rightParenToken',
		'argumentList'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitSuperDelegatingConstructorCall: self
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> argumentList [
	^ argumentList
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> argumentList: aWollokPositionalArgumentsListNode [
	self argumentList notNil
		ifTrue: [ self argumentList parent: nil ].
	argumentList := aWollokPositionalArgumentsListNode.
	self argumentList notNil
		ifTrue: [ self argumentList parent: self ]
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> nodeVariables [
	^ #(#argumentList)
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> superToken [
	^ superToken
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> superToken: aSmaCCToken [
	superToken := aSmaCCToken
]

{ #category : #generated }
WollokSuperDelegatingConstructorCallNode >> tokenVariables [
	^ #(#superToken #leftParenToken #rightParenToken)
]
