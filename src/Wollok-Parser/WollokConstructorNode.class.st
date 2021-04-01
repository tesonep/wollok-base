Class {
	#name : #WollokConstructorNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'constructorToken',
		'leftParenToken',
		'rightParenToken',
		'expression',
		'equalToken',
		'delegatingConstructorCall',
		'parameters',
		'commaTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokConstructorNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitConstructor: self
]

{ #category : #generated }
WollokConstructorNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokConstructorNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokConstructorNode >> compositeNodeVariables [
	^ #(#parameters)
]

{ #category : #generated }
WollokConstructorNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
WollokConstructorNode >> constructorToken [
	^ constructorToken
]

{ #category : #generated }
WollokConstructorNode >> constructorToken: aSmaCCToken [
	constructorToken := aSmaCCToken
]

{ #category : #generated }
WollokConstructorNode >> delegatingConstructorCall [
	^ delegatingConstructorCall
]

{ #category : #generated }
WollokConstructorNode >> delegatingConstructorCall: aWollokAbstractNodeNode [
	self delegatingConstructorCall notNil
		ifTrue: [ self delegatingConstructorCall parent: nil ].
	delegatingConstructorCall := aWollokAbstractNodeNode.
	self delegatingConstructorCall notNil
		ifTrue: [ self delegatingConstructorCall parent: self ]
]

{ #category : #generated }
WollokConstructorNode >> equalToken [
	^ equalToken
]

{ #category : #generated }
WollokConstructorNode >> equalToken: aSmaCCToken [
	equalToken := aSmaCCToken
]

{ #category : #generated }
WollokConstructorNode >> expression [
	^ expression
]

{ #category : #generated }
WollokConstructorNode >> expression: aWollokBlockExpressionNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aWollokBlockExpressionNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #'generated-initialize-release' }
WollokConstructorNode >> initialize [
	super initialize.
	parameters := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokConstructorNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokConstructorNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokConstructorNode >> nodeVariables [
	^ #(#expression #delegatingConstructorCall)
]

{ #category : #generated }
WollokConstructorNode >> parameters [
	^ parameters
]

{ #category : #generated }
WollokConstructorNode >> parameters: anOrderedCollection [
	self setParents: self parameters to: nil.
	parameters := anOrderedCollection.
	self setParents: self parameters to: self
]

{ #category : #generated }
WollokConstructorNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokConstructorNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokConstructorNode >> tokenVariables [
	^ #(#constructorToken #leftParenToken #rightParenToken #equalToken)
]
