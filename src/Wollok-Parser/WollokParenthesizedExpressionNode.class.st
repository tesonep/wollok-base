Class {
	#name : #WollokParenthesizedExpressionNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'leftParenToken',
		'expression',
		'rightParenToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokParenthesizedExpressionNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitParenthesizedExpression: self
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> expression [
	^ expression
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> expression: aWollokAbstractNodeNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aWollokAbstractNodeNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokParenthesizedExpressionNode >> tokenVariables [
	^ #(#leftParenToken #rightParenToken)
]
