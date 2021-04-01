Class {
	#name : #WollokPackageNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'packageToken',
		'name',
		'leftBraceToken',
		'elements',
		'rightBraceToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokPackageNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitPackage: self
]

{ #category : #generated }
WollokPackageNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
WollokPackageNode >> elements [
	^ elements
]

{ #category : #generated }
WollokPackageNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
WollokPackageNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
]

{ #category : #generated }
WollokPackageNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokPackageNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokPackageNode >> name [
	^ name
]

{ #category : #generated }
WollokPackageNode >> name: aWollokQualifiedNameNode [
	self name notNil
		ifTrue: [ self name parent: nil ].
	name := aWollokQualifiedNameNode.
	self name notNil
		ifTrue: [ self name parent: self ]
]

{ #category : #generated }
WollokPackageNode >> nodeVariables [
	^ #(#name)
]

{ #category : #generated }
WollokPackageNode >> packageToken [
	^ packageToken
]

{ #category : #generated }
WollokPackageNode >> packageToken: aSmaCCToken [
	packageToken := aSmaCCToken
]

{ #category : #generated }
WollokPackageNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokPackageNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokPackageNode >> tokenVariables [
	^ #(#packageToken #leftBraceToken #rightBraceToken)
]
