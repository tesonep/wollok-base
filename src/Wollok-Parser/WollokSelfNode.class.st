Class {
	#name : #WollokSelfNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'selfToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokSelfNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitSelf: self
]

{ #category : #generated }
WollokSelfNode >> selfToken [
	^ selfToken
]

{ #category : #generated }
WollokSelfNode >> selfToken: aSmaCCToken [
	selfToken := aSmaCCToken
]

{ #category : #generated }
WollokSelfNode >> tokenVariables [
	^ #(#selfToken)
]
