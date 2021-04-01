Class {
	#name : #WollokParameterNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'parameter',
		'isVarArg'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokParameterNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitParameter: self
]

{ #category : #generated }
WollokParameterNode >> isVarArg [
	^ isVarArg
]

{ #category : #generated }
WollokParameterNode >> isVarArg: aSmaCCToken [
	isVarArg := aSmaCCToken
]

{ #category : #generated }
WollokParameterNode >> parameter [
	^ parameter
]

{ #category : #generated }
WollokParameterNode >> parameter: aSmaCCToken [
	parameter := aSmaCCToken
]

{ #category : #generated }
WollokParameterNode >> tokenVariables [
	^ #(#parameter #isVarArg)
]
