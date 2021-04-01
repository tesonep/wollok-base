Class {
	#name : #WollokConstructorCallNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'newToken',
		'classRef',
		'leftParenToken',
		'rightParenToken',
		'withTokens',
		'mixins',
		'argumentList'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokConstructorCallNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitConstructorCall: self
]

{ #category : #generated }
WollokConstructorCallNode >> argumentList [
	^ argumentList
]

{ #category : #generated }
WollokConstructorCallNode >> argumentList: aWollokAbstractNodeNode [
	self argumentList notNil
		ifTrue: [ self argumentList parent: nil ].
	argumentList := aWollokAbstractNodeNode.
	self argumentList notNil
		ifTrue: [ self argumentList parent: self ]
]

{ #category : #generated }
WollokConstructorCallNode >> classRef [
	^ classRef
]

{ #category : #generated }
WollokConstructorCallNode >> classRef: aWollokQualifiedNameNode [
	self classRef notNil
		ifTrue: [ self classRef parent: nil ].
	classRef := aWollokQualifiedNameNode.
	self classRef notNil
		ifTrue: [ self classRef parent: self ]
]

{ #category : #generated }
WollokConstructorCallNode >> compositeTokenVariables [
	^ #(#withTokens #mixins)
]

{ #category : #'generated-initialize-release' }
WollokConstructorCallNode >> initialize [
	super initialize.
	withTokens := OrderedCollection new: 2.
	mixins := OrderedCollection new: 2.
]

{ #category : #generated }
WollokConstructorCallNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokConstructorCallNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokConstructorCallNode >> mixins [
	^ mixins
]

{ #category : #generated }
WollokConstructorCallNode >> mixins: anOrderedCollection [
	mixins := anOrderedCollection
]

{ #category : #generated }
WollokConstructorCallNode >> newToken [
	^ newToken
]

{ #category : #generated }
WollokConstructorCallNode >> newToken: aSmaCCToken [
	newToken := aSmaCCToken
]

{ #category : #generated }
WollokConstructorCallNode >> nodeVariables [
	^ #(#classRef #argumentList)
]

{ #category : #generated }
WollokConstructorCallNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokConstructorCallNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokConstructorCallNode >> tokenVariables [
	^ #(#newToken #leftParenToken #rightParenToken)
]

{ #category : #generated }
WollokConstructorCallNode >> withTokens [
	^ withTokens
]

{ #category : #generated }
WollokConstructorCallNode >> withTokens: anOrderedCollection [
	withTokens := anOrderedCollection
]
