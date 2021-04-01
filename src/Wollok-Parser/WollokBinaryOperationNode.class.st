Class {
	#name : #WollokBinaryOperationNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'leftOperand',
		'operation',
		'rightOperand'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokBinaryOperationNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitBinaryOperation: self
]

{ #category : #generated }
WollokBinaryOperationNode >> leftOperand [
	^ leftOperand
]

{ #category : #generated }
WollokBinaryOperationNode >> leftOperand: aWollokAbstractNodeNode [
	self leftOperand notNil
		ifTrue: [ self leftOperand parent: nil ].
	leftOperand := aWollokAbstractNodeNode.
	self leftOperand notNil
		ifTrue: [ self leftOperand parent: self ]
]

{ #category : #generated }
WollokBinaryOperationNode >> nodeVariables [
	^ #(#leftOperand #rightOperand)
]

{ #category : #generated }
WollokBinaryOperationNode >> operation [
	^ operation
]

{ #category : #generated }
WollokBinaryOperationNode >> operation: aSmaCCToken [
	operation := aSmaCCToken
]

{ #category : #generated }
WollokBinaryOperationNode >> rightOperand [
	^ rightOperand
]

{ #category : #generated }
WollokBinaryOperationNode >> rightOperand: aWollokAbstractNodeNode [
	self rightOperand notNil
		ifTrue: [ self rightOperand parent: nil ].
	rightOperand := aWollokAbstractNodeNode.
	self rightOperand notNil
		ifTrue: [ self rightOperand parent: self ]
]

{ #category : #generated }
WollokBinaryOperationNode >> tokenVariables [
	^ #(#operation)
]
