Class {
	#name : #WollokImportNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'importToken',
		'importedNamespace'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokImportNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitImport: self
]

{ #category : #generated }
WollokImportNode >> importToken [
	^ importToken
]

{ #category : #generated }
WollokImportNode >> importToken: aSmaCCToken [
	importToken := aSmaCCToken
]

{ #category : #generated }
WollokImportNode >> importedNamespace [
	^ importedNamespace
]

{ #category : #generated }
WollokImportNode >> importedNamespace: aWollokQualifiedNameWithWildcardNode [
	self importedNamespace notNil
		ifTrue: [ self importedNamespace parent: nil ].
	importedNamespace := aWollokQualifiedNameWithWildcardNode.
	self importedNamespace notNil
		ifTrue: [ self importedNamespace parent: self ]
]

{ #category : #generated }
WollokImportNode >> nodeVariables [
	^ #(#importedNamespace)
]

{ #category : #generated }
WollokImportNode >> tokenVariables [
	^ #(#importToken)
]
