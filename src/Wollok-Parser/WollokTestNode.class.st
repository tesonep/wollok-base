Class {
	#name : #WollokTestNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'testToken',
		'name',
		'leftBraceToken',
		'elements',
		'semicolonTokens',
		'rightBraceToken',
		'only'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokTestNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitTest: self
]

{ #category : #generated }
WollokTestNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
WollokTestNode >> compositeTokenVariables [
	^ #(#semicolonTokens)
]

{ #category : #generated }
WollokTestNode >> elements [
	^ elements
]

{ #category : #generated }
WollokTestNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
WollokTestNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokTestNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokTestNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokTestNode >> name [
	^ name
]

{ #category : #generated }
WollokTestNode >> name: aWollokStringLiteralNode [
	self name notNil
		ifTrue: [ self name parent: nil ].
	name := aWollokStringLiteralNode.
	self name notNil
		ifTrue: [ self name parent: self ]
]

{ #category : #generated }
WollokTestNode >> nodeVariables [
	^ #(#name)
]

{ #category : #generated }
WollokTestNode >> only [
	^ only
]

{ #category : #generated }
WollokTestNode >> only: aSmaCCToken [
	only := aSmaCCToken
]

{ #category : #generated }
WollokTestNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokTestNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokTestNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokTestNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokTestNode >> testToken [
	^ testToken
]

{ #category : #generated }
WollokTestNode >> testToken: aSmaCCToken [
	testToken := aSmaCCToken
]

{ #category : #generated }
WollokTestNode >> tokenVariables [
	^ #(#testToken #leftBraceToken #rightBraceToken #only)
]
