Class {
	#name : #WollokFixtureNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'fixtureToken',
		'leftBraceToken',
		'elements',
		'semicolonTokens',
		'rightBraceToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokFixtureNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitFixture: self
]

{ #category : #generated }
WollokFixtureNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
WollokFixtureNode >> compositeTokenVariables [
	^ #(#semicolonTokens)
]

{ #category : #generated }
WollokFixtureNode >> elements [
	^ elements
]

{ #category : #generated }
WollokFixtureNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #generated }
WollokFixtureNode >> fixtureToken [
	^ fixtureToken
]

{ #category : #generated }
WollokFixtureNode >> fixtureToken: aSmaCCToken [
	fixtureToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
WollokFixtureNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokFixtureNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokFixtureNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokFixtureNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokFixtureNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokFixtureNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokFixtureNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokFixtureNode >> tokenVariables [
	^ #(#fixtureToken #leftBraceToken #rightBraceToken)
]
