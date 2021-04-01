Class {
	#name : #WollokMethodDeclarationNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'methodToken',
		'name',
		'leftParenToken',
		'rightParenToken',
		'expression',
		'expressionReturns',
		'native',
		'parameters',
		'commaTokens',
		'override'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokMethodDeclarationNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitMethodDeclaration: self
]

{ #category : #generated }
WollokMethodDeclarationNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokMethodDeclarationNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokMethodDeclarationNode >> compositeNodeVariables [
	^ #(#parameters)
]

{ #category : #generated }
WollokMethodDeclarationNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
WollokMethodDeclarationNode >> expression [
	^ expression
]

{ #category : #generated }
WollokMethodDeclarationNode >> expression: aWollokAbstractNodeNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aWollokAbstractNodeNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
WollokMethodDeclarationNode >> expressionReturns [
	^ expressionReturns
]

{ #category : #generated }
WollokMethodDeclarationNode >> expressionReturns: aSmaCCToken [
	expressionReturns := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
WollokMethodDeclarationNode >> initialize [
	super initialize.
	parameters := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokMethodDeclarationNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #accessing }
WollokMethodDeclarationNode >> methodNode [
	
	^ self
]

{ #category : #generated }
WollokMethodDeclarationNode >> methodToken [
	^ methodToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> methodToken: aSmaCCToken [
	methodToken := aSmaCCToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> name [
	^ name
]

{ #category : #generated }
WollokMethodDeclarationNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> native [
	^ native
]

{ #category : #generated }
WollokMethodDeclarationNode >> native: aSmaCCToken [
	native := aSmaCCToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
WollokMethodDeclarationNode >> override [
	^ override
]

{ #category : #generated }
WollokMethodDeclarationNode >> override: aSmaCCToken [
	override := aSmaCCToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> parameters [
	^ parameters
]

{ #category : #generated }
WollokMethodDeclarationNode >> parameters: anOrderedCollection [
	self setParents: self parameters to: nil.
	parameters := anOrderedCollection.
	self setParents: self parameters to: self
]

{ #category : #generated }
WollokMethodDeclarationNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokMethodDeclarationNode >> tokenVariables [
	^ #(#methodToken #name #leftParenToken #rightParenToken #expressionReturns #native #override)
]
