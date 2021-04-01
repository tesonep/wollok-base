Class {
	#name : #WollokMixinNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'mixinToken',
		'name',
		'leftBraceToken',
		'members',
		'semicolonTokens',
		'rightBraceToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokMixinNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitMixin: self
]

{ #category : #generated }
WollokMixinNode >> compositeNodeVariables [
	^ #(#members)
]

{ #category : #generated }
WollokMixinNode >> compositeTokenVariables [
	^ #(#semicolonTokens)
]

{ #category : #'generated-initialize-release' }
WollokMixinNode >> initialize [
	super initialize.
	members := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokMixinNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokMixinNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokMixinNode >> members [
	^ members
]

{ #category : #generated }
WollokMixinNode >> members: anOrderedCollection [
	self setParents: self members to: nil.
	members := anOrderedCollection.
	self setParents: self members to: self
]

{ #category : #generated }
WollokMixinNode >> mixinToken [
	^ mixinToken
]

{ #category : #generated }
WollokMixinNode >> mixinToken: aSmaCCToken [
	mixinToken := aSmaCCToken
]

{ #category : #generated }
WollokMixinNode >> name [
	^ name
]

{ #category : #generated }
WollokMixinNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
WollokMixinNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokMixinNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokMixinNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokMixinNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokMixinNode >> tokenVariables [
	^ #(#mixinToken #name #leftBraceToken #rightBraceToken)
]
