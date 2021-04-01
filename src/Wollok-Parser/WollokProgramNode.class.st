Class {
	#name : #WollokProgramNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'programToken',
		'name',
		'leftBraceToken',
		'elements',
		'semicolonTokens',
		'rightBraceToken'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokProgramNode >> acceptVisitor: anAbstractNodeVisitor [

	^ anAbstractNodeVisitor visitProgram: self
]

{ #category : #generated }
WollokProgramNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
WollokProgramNode >> compositeTokenVariables [
	^ #(#semicolonTokens)
]

{ #category : #generated }
WollokProgramNode >> elements [
	^ elements
]

{ #category : #generated }
WollokProgramNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
WollokProgramNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
	semicolonTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokProgramNode >> leftBraceToken [
	^ leftBraceToken
]

{ #category : #generated }
WollokProgramNode >> leftBraceToken: aSmaCCToken [
	leftBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokProgramNode >> name [
	^ name
]

{ #category : #generated }
WollokProgramNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
WollokProgramNode >> programToken [
	^ programToken
]

{ #category : #generated }
WollokProgramNode >> programToken: aSmaCCToken [
	programToken := aSmaCCToken
]

{ #category : #generated }
WollokProgramNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
WollokProgramNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
WollokProgramNode >> semicolonTokens [
	^ semicolonTokens
]

{ #category : #generated }
WollokProgramNode >> semicolonTokens: anOrderedCollection [
	semicolonTokens := anOrderedCollection
]

{ #category : #generated }
WollokProgramNode >> tokenVariables [
	^ #(#programToken #name #leftBraceToken #rightBraceToken)
]
