Class {
	#name : #WollokPlatform,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#category : #'Wollok-Parser'
}

{ #category : #accessing }
WollokPlatform class >> beCurrent [

	^ Current := self new
]

{ #category : #accessing }
WollokPlatform class >> current [

	^ Current ifNil: [ Current := self subclasses first new ]
]

{ #category : #'as yet unclassified' }
WollokPlatform >> essentialTestsRootDirectory [

	^ self wollokRepositoryDirectory / 'test' / 'essential'
]

{ #category : #'as yet unclassified' }
WollokPlatform >> newInterpreterWithRootFileNode: aFileNode [

	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
WollokPlatform >> sanityTestsRootDirectory [

	^ self wollokRepositoryDirectory / 'test'
]

{ #category : #'as yet unclassified' }
WollokPlatform >> wollokParserClass [

	^ WollokParser
]

{ #category : #'as yet unclassified' }
WollokPlatform >> wollokRepositoryDirectory [

	^ self subclassResponsibility 
]
