Class {
	#name : #WollokAssignmentNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'variable',
		'operation',
		'value'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokAssignmentNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitAssignment: self
]

{ #category : #generated }
WollokAssignmentNode >> nodeVariables [
	^ #(#variable #value)
]

{ #category : #generated }
WollokAssignmentNode >> operation [
	^ operation
]

{ #category : #generated }
WollokAssignmentNode >> operation: aSmaCCToken [
	operation := aSmaCCToken
]

{ #category : #generated }
WollokAssignmentNode >> tokenVariables [
	^ #(#operation)
]

{ #category : #generated }
WollokAssignmentNode >> value [
	^ value
]

{ #category : #generated }
WollokAssignmentNode >> value: aWollokAbstractNodeNode [
	self value notNil
		ifTrue: [ self value parent: nil ].
	value := aWollokAbstractNodeNode.
	self value notNil
		ifTrue: [ self value parent: self ]
]

{ #category : #generated }
WollokAssignmentNode >> variable [
	^ variable
]

{ #category : #generated }
WollokAssignmentNode >> variable: aWollokVariableNode [
	self variable notNil
		ifTrue: [ self variable parent: nil ].
	variable := aWollokVariableNode.
	self variable notNil
		ifTrue: [ self variable parent: self ]
]
