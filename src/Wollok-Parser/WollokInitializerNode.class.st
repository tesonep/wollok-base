Class {
	#name : #WollokInitializerNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'name',
		'colonEqualToken',
		'value'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokInitializerNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitInitializer: self
]

{ #category : #generated }
WollokInitializerNode >> colonEqualToken [
	^ colonEqualToken
]

{ #category : #generated }
WollokInitializerNode >> colonEqualToken: aSmaCCToken [
	colonEqualToken := aSmaCCToken
]

{ #category : #generated }
WollokInitializerNode >> name [
	^ name
]

{ #category : #generated }
WollokInitializerNode >> name: aWollokVariableNode [
	self name notNil
		ifTrue: [ self name parent: nil ].
	name := aWollokVariableNode.
	self name notNil
		ifTrue: [ self name parent: self ]
]

{ #category : #generated }
WollokInitializerNode >> nodeVariables [
	^ #(#name #value)
]

{ #category : #generated }
WollokInitializerNode >> tokenVariables [
	^ #(#colonEqualToken)
]

{ #category : #generated }
WollokInitializerNode >> value [
	^ value
]

{ #category : #generated }
WollokInitializerNode >> value: aWollokAbstractNodeNode [
	self value notNil
		ifTrue: [ self value parent: nil ].
	value := aWollokAbstractNodeNode.
	self value notNil
		ifTrue: [ self value parent: self ]
]
