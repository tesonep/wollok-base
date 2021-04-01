Class {
	#name : #WollokQualifiedNameWithWildcardNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'qualifiedName',
		'hasAsterisk'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokQualifiedNameWithWildcardNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitQualifiedNameWithWildcard: self
]

{ #category : #generated }
WollokQualifiedNameWithWildcardNode >> hasAsterisk [
	^ hasAsterisk
]

{ #category : #generated }
WollokQualifiedNameWithWildcardNode >> hasAsterisk: aSmaCCToken [
	hasAsterisk := aSmaCCToken
]

{ #category : #generated }
WollokQualifiedNameWithWildcardNode >> nodeVariables [
	^ #(#qualifiedName)
]

{ #category : #generated }
WollokQualifiedNameWithWildcardNode >> qualifiedName [
	^ qualifiedName
]

{ #category : #generated }
WollokQualifiedNameWithWildcardNode >> qualifiedName: aWollokQualifiedNameNode [
	self qualifiedName notNil
		ifTrue: [ self qualifiedName parent: nil ].
	qualifiedName := aWollokQualifiedNameNode.
	self qualifiedName notNil
		ifTrue: [ self qualifiedName parent: self ]
]

{ #category : #generated }
WollokQualifiedNameWithWildcardNode >> tokenVariables [
	^ #(#hasAsterisk)
]
