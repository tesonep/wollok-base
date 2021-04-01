Class {
	#name : #WollokNamedArgumentsListNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'values',
		'commaTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokNamedArgumentsListNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitNamedArgumentsList: self
]

{ #category : #generated }
WollokNamedArgumentsListNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokNamedArgumentsListNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokNamedArgumentsListNode >> compositeNodeVariables [
	^ #(#values)
]

{ #category : #generated }
WollokNamedArgumentsListNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #'generated-initialize-release' }
WollokNamedArgumentsListNode >> initialize [
	super initialize.
	values := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokNamedArgumentsListNode >> values [
	^ values
]

{ #category : #generated }
WollokNamedArgumentsListNode >> values: anOrderedCollection [
	self setParents: self values to: nil.
	values := anOrderedCollection.
	self setParents: self values to: self
]
