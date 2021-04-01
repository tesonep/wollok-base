Class {
	#name : #WollokTryNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'tryToken',
		'expression',
		'catchBlocks',
		'then_alwaysToken',
		'alwaysExpression'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokTryNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitTry: self
]

{ #category : #generated }
WollokTryNode >> alwaysExpression [
	^ alwaysExpression
]

{ #category : #generated }
WollokTryNode >> alwaysExpression: aWollokAbstractNodeNode [
	self alwaysExpression notNil
		ifTrue: [ self alwaysExpression parent: nil ].
	alwaysExpression := aWollokAbstractNodeNode.
	self alwaysExpression notNil
		ifTrue: [ self alwaysExpression parent: self ]
]

{ #category : #generated }
WollokTryNode >> catchBlocks [
	^ catchBlocks
]

{ #category : #generated }
WollokTryNode >> catchBlocks: anOrderedCollection [
	self setParents: self catchBlocks to: nil.
	catchBlocks := anOrderedCollection.
	self setParents: self catchBlocks to: self
]

{ #category : #generated }
WollokTryNode >> compositeNodeVariables [
	^ #(#catchBlocks)
]

{ #category : #generated }
WollokTryNode >> expression [
	^ expression
]

{ #category : #generated }
WollokTryNode >> expression: aWollokAbstractNodeNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aWollokAbstractNodeNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #'generated-initialize-release' }
WollokTryNode >> initialize [
	super initialize.
	catchBlocks := OrderedCollection new: 2.
]

{ #category : #generated }
WollokTryNode >> nodeVariables [
	^ #(#expression #alwaysExpression)
]

{ #category : #generated }
WollokTryNode >> then_alwaysToken [
	^ then_alwaysToken
]

{ #category : #generated }
WollokTryNode >> then_alwaysToken: aSmaCCToken [
	then_alwaysToken := aSmaCCToken
]

{ #category : #generated }
WollokTryNode >> tokenVariables [
	^ #(#tryToken #then_alwaysToken)
]

{ #category : #generated }
WollokTryNode >> tryToken [
	^ tryToken
]

{ #category : #generated }
WollokTryNode >> tryToken: aSmaCCToken [
	tryToken := aSmaCCToken
]
