Class {
	#name : #WollokFileNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'imports',
		'elements',
		'main',
		'tests',
		'suites'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokFileNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitFile: self
]

{ #category : #generated }
WollokFileNode >> compositeNodeVariables [
	^ #(#imports #elements #tests #suites)
]

{ #category : #generated }
WollokFileNode >> elements [
	^ elements
]

{ #category : #generated }
WollokFileNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #generated }
WollokFileNode >> imports [
	^ imports
]

{ #category : #generated }
WollokFileNode >> imports: anOrderedCollection [
	self setParents: self imports to: nil.
	imports := anOrderedCollection.
	self setParents: self imports to: self
]

{ #category : #'generated-initialize-release' }
WollokFileNode >> initialize [
	super initialize.
	imports := OrderedCollection new: 2.
	elements := OrderedCollection new: 2.
	tests := OrderedCollection new: 2.
	suites := OrderedCollection new: 2.
]

{ #category : #testing }
WollokFileNode >> isProgram [
	
	^ main isNotNil
]

{ #category : #generated }
WollokFileNode >> main [
	^ main
]

{ #category : #generated }
WollokFileNode >> main: aWollokProgramNode [
	self main notNil
		ifTrue: [ self main parent: nil ].
	main := aWollokProgramNode.
	self main notNil
		ifTrue: [ self main parent: self ]
]

{ #category : #generated }
WollokFileNode >> nodeVariables [
	^ #(#main)
]

{ #category : #generated }
WollokFileNode >> suites [
	^ suites
]

{ #category : #generated }
WollokFileNode >> suites: anOrderedCollection [
	self setParents: self suites to: nil.
	suites := anOrderedCollection.
	self setParents: self suites to: self
]

{ #category : #generated }
WollokFileNode >> tests [
	^ tests
]

{ #category : #generated }
WollokFileNode >> tests: anOrderedCollection [
	self setParents: self tests to: nil.
	tests := anOrderedCollection.
	self setParents: self tests to: self
]
