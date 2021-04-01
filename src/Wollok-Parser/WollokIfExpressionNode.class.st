Class {
	#name : #WollokIfExpressionNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'ifToken',
		'leftParenToken',
		'condition',
		'rightParenToken',
		'then',
		'elseToken',
		'else'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokIfExpressionNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitIfExpression: self
]

{ #category : #generated }
WollokIfExpressionNode >> condition [
	^ condition
]

{ #category : #generated }
WollokIfExpressionNode >> condition: aWollokAbstractNodeNode [
	self condition notNil
		ifTrue: [ self condition parent: nil ].
	condition := aWollokAbstractNodeNode.
	self condition notNil
		ifTrue: [ self condition parent: self ]
]

{ #category : #generated }
WollokIfExpressionNode >> else [
	^ else
]

{ #category : #generated }
WollokIfExpressionNode >> else: aWollokAbstractNodeNode [
	self else notNil
		ifTrue: [ self else parent: nil ].
	else := aWollokAbstractNodeNode.
	self else notNil
		ifTrue: [ self else parent: self ]
]

{ #category : #generated }
WollokIfExpressionNode >> elseToken [
	^ elseToken
]

{ #category : #generated }
WollokIfExpressionNode >> elseToken: aSmaCCToken [
	elseToken := aSmaCCToken
]

{ #category : #generated }
WollokIfExpressionNode >> ifToken [
	^ ifToken
]

{ #category : #generated }
WollokIfExpressionNode >> ifToken: aSmaCCToken [
	ifToken := aSmaCCToken
]

{ #category : #generated }
WollokIfExpressionNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokIfExpressionNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokIfExpressionNode >> nodeVariables [
	^ #(#condition #then #else)
]

{ #category : #generated }
WollokIfExpressionNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokIfExpressionNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokIfExpressionNode >> then [
	^ then
]

{ #category : #generated }
WollokIfExpressionNode >> then: aWollokAbstractNodeNode [
	self then notNil
		ifTrue: [ self then parent: nil ].
	then := aWollokAbstractNodeNode.
	self then notNil
		ifTrue: [ self then parent: self ]
]

{ #category : #generated }
WollokIfExpressionNode >> tokenVariables [
	^ #(#ifToken #leftParenToken #rightParenToken #elseToken)
]
