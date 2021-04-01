Class {
	#name : #WollokObjectLiteralNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'objectToken',
		'leftBraceToken',
		'members',
		'semicolonTokens',
		'rightBraceToken',
		'mixed_withToken',
		'mixins',
		'andTokens',
		'commaTokens',
		'inheritsToken',
		'superclass',
		'leftParenToken',
		'superclassParameters',
		'rightParenToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokObjectLiteralNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitObjectLiteral: self
]

{ #category : #generated }
WollokObjectLiteralNode >> andTokens [
	^ andTokens
]

{ #category : #generated }
WollokObjectLiteralNode >> andTokens: anOrderedCollection [
	andTokens := anOrderedCollection
]

{ #category : #generated }
WollokObjectLiteralNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokObjectLiteralNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokObjectLiteralNode >> compositeNodeVariables [
	^ #(#members #mixins)
]

{ #category : #generated }
WollokObjectLiteralNode >> compositeTokenVariables [
	^ #(#semicolonTokens #andTokens #commaTokens)
]

{ #category : #accessing }
WollokObjectLiteralNode >> constructors [

	^ #()
]

{ #category : #generated }
WollokObjectLiteralNode >> inheritsToken [
	^ inheritsToken
]

{ #category : #generated }
WollokObjectLiteralNode >> inheritsToken: aSmaCCToken [
	inheritsToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
WollokObjectLiteralNode >> initialize [
	super initialize.
	members := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
	mixins := OrderedCollection new: 2.
	andTokens := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokObjectLiteralNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokObjectLiteralNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokObjectLiteralNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokObjectLiteralNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokObjectLiteralNode >> members [
	^ members
]

{ #category : #generated }
WollokObjectLiteralNode >> members: anOrderedCollection [
	self setParents: self members to: nil.
	members := anOrderedCollection.
	self setParents: self members to: self
]

{ #category : #accessing }
WollokObjectLiteralNode >> methods [
	
	^ members select: [ :e | e isKindOf: WollokMethodDeclarationNode   ]
]

{ #category : #generated }
WollokObjectLiteralNode >> mixed_withToken [
	^ mixed_withToken
]

{ #category : #generated }
WollokObjectLiteralNode >> mixed_withToken: aSmaCCToken [
	mixed_withToken := aSmaCCToken
]

{ #category : #generated }
WollokObjectLiteralNode >> mixins [
	^ mixins
]

{ #category : #generated }
WollokObjectLiteralNode >> mixins: anOrderedCollection [
	self setParents: self mixins to: nil.
	mixins := anOrderedCollection.
	self setParents: self mixins to: self
]

{ #category : #generated }
WollokObjectLiteralNode >> nodeVariables [
	^ #(#superclass #superclassParameters)
]

{ #category : #generated }
WollokObjectLiteralNode >> objectToken [
	^ objectToken
]

{ #category : #generated }
WollokObjectLiteralNode >> objectToken: aSmaCCToken [
	objectToken := aSmaCCToken
]

{ #category : #generated }
WollokObjectLiteralNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokObjectLiteralNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokObjectLiteralNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokObjectLiteralNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokObjectLiteralNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokObjectLiteralNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokObjectLiteralNode >> superclass [
	^ superclass
]

{ #category : #generated }
WollokObjectLiteralNode >> superclass: aWollokQualifiedNameNode [
	self superclass notNil
		ifTrue: [ self superclass parent: nil ].
	superclass := aWollokQualifiedNameNode.
	self superclass notNil
		ifTrue: [ self superclass parent: self ]
]

{ #category : #generated }
WollokObjectLiteralNode >> superclassParameters [
	^ superclassParameters
]

{ #category : #generated }
WollokObjectLiteralNode >> superclassParameters: aWollokAbstractNodeNode [
	self superclassParameters notNil
		ifTrue: [ self superclassParameters parent: nil ].
	superclassParameters := aWollokAbstractNodeNode.
	self superclassParameters notNil
		ifTrue: [ self superclassParameters parent: self ]
]

{ #category : #generated }
WollokObjectLiteralNode >> tokenVariables [
	^ #(#objectToken #leftBraceToken #rightBraceToken #mixed_withToken #inheritsToken #leftParenToken #rightParenToken)
]

{ #category : #accessing }
WollokObjectLiteralNode >> variables [
	
	^ members select: [ :e | e isKindOf: WollokVariableDeclarationNode  ]
]
