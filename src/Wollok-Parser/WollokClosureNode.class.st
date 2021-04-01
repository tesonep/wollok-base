Class {
	#name : #WollokClosureNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'leftBraceToken',
		'parameters',
		'commaTokens',
		'equalGreaterThanToken',
		'expression',
		'rightBraceToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokClosureNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitClosure: self
]

{ #category : #generated }
WollokClosureNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokClosureNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokClosureNode >> compositeNodeVariables [
	^ #(#parameters)
]

{ #category : #generated }
WollokClosureNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
WollokClosureNode >> equalGreaterThanToken [
	^ equalGreaterThanToken
]

{ #category : #generated }
WollokClosureNode >> equalGreaterThanToken: aSmaCCToken [
	equalGreaterThanToken := aSmaCCToken
]

{ #category : #generated }
WollokClosureNode >> expression [
	^ expression
]

{ #category : #generated }
WollokClosureNode >> expression: aWollokBlockExpressionNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aWollokBlockExpressionNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #'generated-initialize-release' }
WollokClosureNode >> initialize [
	super initialize.
	parameters := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokClosureNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokClosureNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokClosureNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
WollokClosureNode >> parameters [
	^ parameters
]

{ #category : #generated }
WollokClosureNode >> parameters: anOrderedCollection [
	self setParents: self parameters to: nil.
	parameters := anOrderedCollection.
	self setParents: self parameters to: self
]

{ #category : #generated }
WollokClosureNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokClosureNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokClosureNode >> tokenVariables [
	^ #(#leftBraceToken #equalGreaterThanToken #rightBraceToken)
]
