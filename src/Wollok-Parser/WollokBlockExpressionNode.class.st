Class {
	#name : #WollokBlockExpressionNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'leftBraceToken',
		'expressions',
		'semicolonTokens',
		'rightBraceToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokBlockExpressionNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitBlockExpression: self
]

{ #category : #generated }
WollokBlockExpressionNode >> compositeNodeVariables [
	^ #(#expressions)
]

{ #category : #generated }
WollokBlockExpressionNode >> compositeTokenVariables [
	^ #(#semicolonTokens)
]

{ #category : #generated }
WollokBlockExpressionNode >> expressions [
	^ expressions
]

{ #category : #generated }
WollokBlockExpressionNode >> expressions: anOrderedCollection [
	self setParents: self expressions to: nil.
	expressions := anOrderedCollection.
	self setParents: self expressions to: self
]

{ #category : #'generated-initialize-release' }
WollokBlockExpressionNode >> initialize [
	super initialize.
	expressions := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokBlockExpressionNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokBlockExpressionNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokBlockExpressionNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokBlockExpressionNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokBlockExpressionNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokBlockExpressionNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokBlockExpressionNode >> tokenVariables [
	^ #(#leftBraceToken #rightBraceToken)
]
