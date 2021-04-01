Class {
	#name : #WollokClassNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'classToken',
		'name',
		'leftBraceToken',
		'variables',
		'semicolonTokens',
		'constructors',
		'members',
		'rightBraceToken',
		'mixed_withToken',
		'mixins',
		'andTokens',
		'commaTokens',
		'inheritsToken',
		'superclass'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokClassNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitClass: self
]

{ #category : #generated }
WollokClassNode >> andTokens [
	^ andTokens
]

{ #category : #generated }
WollokClassNode >> andTokens: anOrderedCollection [
	andTokens := anOrderedCollection
]

{ #category : #generated }
WollokClassNode >> classToken [
	^ classToken
]

{ #category : #generated }
WollokClassNode >> classToken: aSmaCCToken [
	classToken := aSmaCCToken
]

{ #category : #generated }
WollokClassNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokClassNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokClassNode >> compositeNodeVariables [
	^ #(#variables #constructors #members #mixins)
]

{ #category : #generated }
WollokClassNode >> compositeTokenVariables [
	^ #(#semicolonTokens #andTokens #commaTokens)
]

{ #category : #generated }
WollokClassNode >> constructors [
	^ constructors
]

{ #category : #generated }
WollokClassNode >> constructors: anOrderedCollection [
	self setParents: self constructors to: nil.
	constructors := anOrderedCollection.
	self setParents: self constructors to: self
]

{ #category : #generated }
WollokClassNode >> inheritsToken [
	^ inheritsToken
]

{ #category : #generated }
WollokClassNode >> inheritsToken: aSmaCCToken [
	inheritsToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
WollokClassNode >> initialize [
	super initialize.
	variables := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
	constructors := OrderedCollection new: 2.
	members := OrderedCollection new: 2.
	mixins := OrderedCollection new: 2.
	andTokens := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokClassNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokClassNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokClassNode >> members [
	^ members
]

{ #category : #generated }
WollokClassNode >> members: anOrderedCollection [
	self setParents: self members to: nil.
	members := anOrderedCollection.
	self setParents: self members to: self
]

{ #category : #accessing }
WollokClassNode >> methods [
	
	^ members select: [ :e | e isKindOf: WollokMethodDeclarationNode ]
]

{ #category : #generated }
WollokClassNode >> mixed_withToken [
	^ mixed_withToken
]

{ #category : #generated }
WollokClassNode >> mixed_withToken: aSmaCCToken [
	mixed_withToken := aSmaCCToken
]

{ #category : #generated }
WollokClassNode >> mixins [
	^ mixins
]

{ #category : #generated }
WollokClassNode >> mixins: anOrderedCollection [
	self setParents: self mixins to: nil.
	mixins := anOrderedCollection.
	self setParents: self mixins to: self
]

{ #category : #generated }
WollokClassNode >> name [
	^ name
]

{ #category : #generated }
WollokClassNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
WollokClassNode >> nodeVariables [
	^ #(#superclass)
]

{ #category : #generated }
WollokClassNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokClassNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokClassNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokClassNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokClassNode >> superclass [
	^ superclass
]

{ #category : #generated }
WollokClassNode >> superclass: aWollokQualifiedNameNode [
	self superclass notNil
		ifTrue: [ self superclass parent: nil ].
	superclass := aWollokQualifiedNameNode.
	self superclass notNil
		ifTrue: [ self superclass parent: self ]
]

{ #category : #generated }
WollokClassNode >> tokenVariables [
	^ #(#classToken #name #leftBraceToken #rightBraceToken #mixed_withToken #inheritsToken)
]

{ #category : #generated }
WollokClassNode >> variables [
	^ variables
]

{ #category : #generated }
WollokClassNode >> variables: anOrderedCollection [
	self setParents: self variables to: nil.
	variables := anOrderedCollection.
	self setParents: self variables to: self
]
