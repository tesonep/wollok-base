Class {
	#name : #WollokNamedObjectNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'objectToken',
		'name',
		'leftBraceToken',
		'variables',
		'semicolonTokens',
		'members',
		'rightBraceToken',
		'mixed_withToken',
		'mixins',
		'andTokens',
		'commaTokens',
		'inheritsToken',
		'superclass',
		'leftParenToken',
		'parentParameters',
		'rightParenToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokNamedObjectNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitNamedObject: self
]

{ #category : #generated }
WollokNamedObjectNode >> andTokens [
	^ andTokens
]

{ #category : #generated }
WollokNamedObjectNode >> andTokens: anOrderedCollection [
	andTokens := anOrderedCollection
]

{ #category : #generated }
WollokNamedObjectNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokNamedObjectNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokNamedObjectNode >> compositeNodeVariables [
	^ #(#variables #members #mixins)
]

{ #category : #generated }
WollokNamedObjectNode >> compositeTokenVariables [
	^ #(#semicolonTokens #andTokens #commaTokens)
]

{ #category : #accessing }
WollokNamedObjectNode >> constructors [

	^ #()
]

{ #category : #generated }
WollokNamedObjectNode >> inheritsToken [
	^ inheritsToken
]

{ #category : #generated }
WollokNamedObjectNode >> inheritsToken: aSmaCCToken [
	inheritsToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
WollokNamedObjectNode >> initialize [
	super initialize.
	variables := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
	members := OrderedCollection new: 2.
	mixins := OrderedCollection new: 2.
	andTokens := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokNamedObjectNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokNamedObjectNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokNamedObjectNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokNamedObjectNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokNamedObjectNode >> members [
	^ members
]

{ #category : #generated }
WollokNamedObjectNode >> members: anOrderedCollection [
	self setParents: self members to: nil.
	members := anOrderedCollection.
	self setParents: self members to: self
]

{ #category : #accessing }
WollokNamedObjectNode >> methods [
	
	^ members select: [ :e | e isKindOf: WollokMethodDeclarationNode ]
]

{ #category : #generated }
WollokNamedObjectNode >> mixed_withToken [
	^ mixed_withToken
]

{ #category : #generated }
WollokNamedObjectNode >> mixed_withToken: aSmaCCToken [
	mixed_withToken := aSmaCCToken
]

{ #category : #generated }
WollokNamedObjectNode >> mixins [
	^ mixins
]

{ #category : #generated }
WollokNamedObjectNode >> mixins: anOrderedCollection [
	self setParents: self mixins to: nil.
	mixins := anOrderedCollection.
	self setParents: self mixins to: self
]

{ #category : #generated }
WollokNamedObjectNode >> name [
	^ name
]

{ #category : #generated }
WollokNamedObjectNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
WollokNamedObjectNode >> nodeVariables [
	^ #(#superclass #parentParameters)
]

{ #category : #generated }
WollokNamedObjectNode >> objectToken [
	^ objectToken
]

{ #category : #generated }
WollokNamedObjectNode >> objectToken: aSmaCCToken [
	objectToken := aSmaCCToken
]

{ #category : #generated }
WollokNamedObjectNode >> parentParameters [
	^ parentParameters
]

{ #category : #generated }
WollokNamedObjectNode >> parentParameters: aWollokAbstractNodeNode [
	self parentParameters notNil
		ifTrue: [ self parentParameters parent: nil ].
	parentParameters := aWollokAbstractNodeNode.
	self parentParameters notNil
		ifTrue: [ self parentParameters parent: self ]
]

{ #category : #generated }
WollokNamedObjectNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokNamedObjectNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokNamedObjectNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokNamedObjectNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokNamedObjectNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokNamedObjectNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokNamedObjectNode >> superclass [
	^ superclass
]

{ #category : #generated }
WollokNamedObjectNode >> superclass: aWollokQualifiedNameNode [
	self superclass notNil
		ifTrue: [ self superclass parent: nil ].
	superclass := aWollokQualifiedNameNode.
	self superclass notNil
		ifTrue: [ self superclass parent: self ]
]

{ #category : #generated }
WollokNamedObjectNode >> tokenVariables [
	^ #(#objectToken #name #leftBraceToken #rightBraceToken #mixed_withToken #inheritsToken #leftParenToken #rightParenToken)
]

{ #category : #generated }
WollokNamedObjectNode >> variables [
	^ variables
]

{ #category : #generated }
WollokNamedObjectNode >> variables: anOrderedCollection [
	self setParents: self variables to: nil.
	variables := anOrderedCollection.
	self setParents: self variables to: self
]
