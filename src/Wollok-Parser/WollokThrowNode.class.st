Class {
	#name : #WollokThrowNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'throwToken',
		'exception'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokThrowNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitThrow: self
]

{ #category : #generated }
WollokThrowNode >> exception [
	^ exception
]

{ #category : #generated }
WollokThrowNode >> exception: aWollokAbstractNodeNode [
	self exception notNil
		ifTrue: [ self exception parent: nil ].
	exception := aWollokAbstractNodeNode.
	self exception notNil
		ifTrue: [ self exception parent: self ]
]

{ #category : #generated }
WollokThrowNode >> nodeVariables [
	^ #(#exception)
]

{ #category : #generated }
WollokThrowNode >> throwToken [
	^ throwToken
]

{ #category : #generated }
WollokThrowNode >> throwToken: aSmaCCToken [
	throwToken := aSmaCCToken
]

{ #category : #generated }
WollokThrowNode >> tokenVariables [
	^ #(#throwToken)
]
