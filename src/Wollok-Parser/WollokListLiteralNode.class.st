Class {
	#name : #WollokListLiteralNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'leftBracketToken',
		'rightBracketToken',
		'elements',
		'commaTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokListLiteralNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitListLiteral: self
]

{ #category : #generated }
WollokListLiteralNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokListLiteralNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokListLiteralNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
WollokListLiteralNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
WollokListLiteralNode >> elements [
	^ elements
]

{ #category : #generated }
WollokListLiteralNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
WollokListLiteralNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokListLiteralNode >> leftBracketToken [
	^ leftBracketToken
]

{ #category : #generated }
WollokListLiteralNode >> leftBracketToken: aSmaCCToken [
	leftBracketToken := aSmaCCToken
]

{ #category : #generated }
WollokListLiteralNode >> rightBracketToken [
	^ rightBracketToken
]

{ #category : #generated }
WollokListLiteralNode >> rightBracketToken: aSmaCCToken [
	rightBracketToken := aSmaCCToken
]

{ #category : #generated }
WollokListLiteralNode >> tokenVariables [
	^ #(#leftBracketToken #rightBracketToken)
]
