Class {
	#name : #WollokSetLiteralNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'_LeftBraceToken',
		'rightBraceToken',
		'elements',
		'commaTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokSetLiteralNode >> _LeftBraceToken [
	^ _LeftBraceToken
]

{ #category : #generated }
WollokSetLiteralNode >> _LeftBraceToken: aSmaCCToken [
	_LeftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokSetLiteralNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitSetLiteral: self
]

{ #category : #generated }
WollokSetLiteralNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokSetLiteralNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokSetLiteralNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
WollokSetLiteralNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
WollokSetLiteralNode >> elements [
	^ elements
]

{ #category : #generated }
WollokSetLiteralNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
WollokSetLiteralNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokSetLiteralNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokSetLiteralNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokSetLiteralNode >> tokenVariables [
	^ #(#_LeftBraceToken #rightBraceToken)
]
