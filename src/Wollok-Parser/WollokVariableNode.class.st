Class {
	#name : #WollokVariableNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'name'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokVariableNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitVariable: self
]

{ #category : #generated }
WollokVariableNode >> name [
	^ name
]

{ #category : #generated }
WollokVariableNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
WollokVariableNode >> tokenVariables [
	^ #(#name)
]
