Class {
	#name : #WollokVariableDeclarationNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'writable',
		'variable',
		'equalToken',
		'right',
		'property',
		'constToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokVariableDeclarationNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitVariableDeclaration: self
]

{ #category : #generated }
WollokVariableDeclarationNode >> constToken [
	^ constToken
]

{ #category : #generated }
WollokVariableDeclarationNode >> constToken: aSmaCCToken [
	constToken := aSmaCCToken
]

{ #category : #generated }
WollokVariableDeclarationNode >> equalToken [
	^ equalToken
]

{ #category : #generated }
WollokVariableDeclarationNode >> equalToken: aSmaCCToken [
	equalToken := aSmaCCToken
]

{ #category : #generated }
WollokVariableDeclarationNode >> nodeVariables [
	^ #(#variable #right)
]

{ #category : #generated }
WollokVariableDeclarationNode >> property [
	^ property
]

{ #category : #generated }
WollokVariableDeclarationNode >> property: aSmaCCToken [
	property := aSmaCCToken
]

{ #category : #generated }
WollokVariableDeclarationNode >> right [
	^ right
]

{ #category : #generated }
WollokVariableDeclarationNode >> right: aWollokAbstractNodeNode [
	self right notNil
		ifTrue: [ self right parent: nil ].
	right := aWollokAbstractNodeNode.
	self right notNil
		ifTrue: [ self right parent: self ]
]

{ #category : #generated }
WollokVariableDeclarationNode >> tokenVariables [
	^ #(#writable #equalToken #property #constToken)
]

{ #category : #generated }
WollokVariableDeclarationNode >> variable [
	^ variable
]

{ #category : #generated }
WollokVariableDeclarationNode >> variable: aWollokVariableNode [
	self variable notNil
		ifTrue: [ self variable parent: nil ].
	variable := aWollokVariableNode.
	self variable notNil
		ifTrue: [ self variable parent: self ]
]

{ #category : #generated }
WollokVariableDeclarationNode >> writable [
	^ writable
]

{ #category : #generated }
WollokVariableDeclarationNode >> writable: aSmaCCToken [
	writable := aSmaCCToken
]
