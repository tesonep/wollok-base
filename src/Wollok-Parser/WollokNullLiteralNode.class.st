Class {
	#name : #WollokNullLiteralNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'nullToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokNullLiteralNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitNullLiteral: self
]

{ #category : #generated }
WollokNullLiteralNode >> nullToken [
	^ nullToken
]

{ #category : #generated }
WollokNullLiteralNode >> nullToken: aSmaCCToken [
	nullToken := aSmaCCToken
]

{ #category : #generated }
WollokNullLiteralNode >> tokenVariables [
	^ #(#nullToken)
]
