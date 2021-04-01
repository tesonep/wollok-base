Class {
	#name : #WollokUnaryOperationNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'operation',
		'rightOperand'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokUnaryOperationNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitUnaryOperation: self
]

{ #category : #generated }
WollokUnaryOperationNode >> nodeVariables [
	^ #(#rightOperand)
]

{ #category : #generated }
WollokUnaryOperationNode >> operation [
	^ operation
]

{ #category : #generated }
WollokUnaryOperationNode >> operation: aSmaCCToken [
	operation := aSmaCCToken
]

{ #category : #generated }
WollokUnaryOperationNode >> rightOperand [
	^ rightOperand
]

{ #category : #generated }
WollokUnaryOperationNode >> rightOperand: aWollokAbstractNodeNode [
	self rightOperand notNil
		ifTrue: [ self rightOperand parent: nil ].
	rightOperand := aWollokAbstractNodeNode.
	self rightOperand notNil
		ifTrue: [ self rightOperand parent: self ]
]

{ #category : #generated }
WollokUnaryOperationNode >> tokenVariables [
	^ #(#operation)
]
