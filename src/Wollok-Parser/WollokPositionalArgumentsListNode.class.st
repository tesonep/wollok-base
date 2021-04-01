Class {
	#name : #WollokPositionalArgumentsListNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'values',
		'commaTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokPositionalArgumentsListNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitPositionalArgumentsList: self
]

{ #category : #generated }
WollokPositionalArgumentsListNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokPositionalArgumentsListNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokPositionalArgumentsListNode >> compositeNodeVariables [
	^ #(#values)
]

{ #category : #generated }
WollokPositionalArgumentsListNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #'generated-initialize-release' }
WollokPositionalArgumentsListNode >> initialize [
	super initialize.
	values := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokPositionalArgumentsListNode >> values [
	^ values
]

{ #category : #generated }
WollokPositionalArgumentsListNode >> values: anOrderedCollection [
	self setParents: self values to: nil.
	values := anOrderedCollection.
	self setParents: self values to: self
]
