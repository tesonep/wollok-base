Class {
	#name : #WollokReturnExpressionNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'returnToken',
		'expression'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokReturnExpressionNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitReturnExpression: self
]

{ #category : #generated }
WollokReturnExpressionNode >> expression [
	^ expression
]

{ #category : #generated }
WollokReturnExpressionNode >> expression: aWollokAbstractNodeNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aWollokAbstractNodeNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
WollokReturnExpressionNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
WollokReturnExpressionNode >> returnToken [
	^ returnToken
]

{ #category : #generated }
WollokReturnExpressionNode >> returnToken: aSmaCCToken [
	returnToken := aSmaCCToken
]

{ #category : #generated }
WollokReturnExpressionNode >> tokenVariables [
	^ #(#returnToken)
]
