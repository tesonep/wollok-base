Class {
	#name : #WollokSuiteNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'describeToken',
		'name',
		'leftBraceToken',
		'members',
		'semicolonTokens',
		'tests',
		'rightBraceToken',
		'fixture'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokSuiteNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitSuite: self
]

{ #category : #generated }
WollokSuiteNode >> compositeNodeVariables [
	^ #(#members #tests)
]

{ #category : #generated }
WollokSuiteNode >> compositeTokenVariables [
	^ #(#semicolonTokens)
]

{ #category : #accessing }
WollokSuiteNode >> constructors [

	^ #()
]

{ #category : #generated }
WollokSuiteNode >> describeToken [
	^ describeToken
]

{ #category : #generated }
WollokSuiteNode >> describeToken: aSmaCCToken [
	describeToken := aSmaCCToken
]

{ #category : #generated }
WollokSuiteNode >> fixture [
	^ fixture
]

{ #category : #generated }
WollokSuiteNode >> fixture: aWollokFixtureNode [
	self fixture notNil
		ifTrue: [ self fixture parent: nil ].
	fixture := aWollokFixtureNode.
	self fixture notNil
		ifTrue: [ self fixture parent: self ]
]

{ #category : #'generated-initialize-release' }
WollokSuiteNode >> initialize [
	super initialize.
	members := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
	tests := OrderedCollection new: 2.
]

{ #category : #generated }
WollokSuiteNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokSuiteNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokSuiteNode >> members [
	^ members
]

{ #category : #generated }
WollokSuiteNode >> members: anOrderedCollection [
	self setParents: self members to: nil.
	members := anOrderedCollection.
	self setParents: self members to: self
]

{ #category : #accessing }
WollokSuiteNode >> methods [
	
	^ tests , (members select: [:e | e isKindOf: WollokMethodDeclarationNode ])
]

{ #category : #generated }
WollokSuiteNode >> name [
	^ name
]

{ #category : #generated }
WollokSuiteNode >> name: aWollokStringLiteralNode [
	self name notNil
		ifTrue: [ self name parent: nil ].
	name := aWollokStringLiteralNode.
	self name notNil
		ifTrue: [ self name parent: self ]
]

{ #category : #generated }
WollokSuiteNode >> nodeVariables [
	^ #(#name #fixture)
]

{ #category : #generated }
WollokSuiteNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokSuiteNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokSuiteNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokSuiteNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokSuiteNode >> tests [
	^ tests
]

{ #category : #generated }
WollokSuiteNode >> tests: anOrderedCollection [
	self setParents: self tests to: nil.
	tests := anOrderedCollection.
	self setParents: self tests to: self
]

{ #category : #generated }
WollokSuiteNode >> tokenVariables [
	^ #(#describeToken #leftBraceToken #rightBraceToken)
]

{ #category : #'as yet unclassified' }
WollokSuiteNode >> variables [
	
	^ members select: [ :e | e isKindOf: WollokVariableDeclarationNode ]
]
