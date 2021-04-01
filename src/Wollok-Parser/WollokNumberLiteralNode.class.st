Class {
	#name : #WollokNumberLiteralNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'value'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokNumberLiteralNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitNumberLiteral: self
]

{ #category : #generated }
WollokNumberLiteralNode >> tokenVariables [
	^ #(#value)
]

{ #category : #generated }
WollokNumberLiteralNode >> value [
	^ value
]

{ #category : #generated }
WollokNumberLiteralNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
