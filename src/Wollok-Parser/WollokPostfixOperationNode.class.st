Class {
	#name : #WollokPostfixOperationNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'operand',
		'operation'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokPostfixOperationNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitPostfixOperation: self
]

{ #category : #generated }
WollokPostfixOperationNode >> nodeVariables [
	^ #(#operand)
]

{ #category : #generated }
WollokPostfixOperationNode >> operand [
	^ operand
]

{ #category : #generated }
WollokPostfixOperationNode >> operand: aWollokAbstractNodeNode [
	self operand notNil
		ifTrue: [ self operand parent: nil ].
	operand := aWollokAbstractNodeNode.
	self operand notNil
		ifTrue: [ self operand parent: self ]
]

{ #category : #generated }
WollokPostfixOperationNode >> operation [
	^ operation
]

{ #category : #generated }
WollokPostfixOperationNode >> operation: aSmaCCToken [
	operation := aSmaCCToken
]

{ #category : #generated }
WollokPostfixOperationNode >> tokenVariables [
	^ #(#operation)
]
