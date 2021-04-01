Class {
	#name : #WollokMemberFeatureCallNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'receiver',
		'periodToken',
		'feature',
		'leftParenToken',
		'rightParenToken',
		'nullSafe',
		'arguments',
		'commaTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokMemberFeatureCallNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitMemberFeatureCall: self
]

{ #category : #generated }
WollokMemberFeatureCallNode >> arguments [
	^ arguments
]

{ #category : #generated }
WollokMemberFeatureCallNode >> arguments: anOrderedCollection [
	self setParents: self arguments to: nil.
	arguments := anOrderedCollection.
	self setParents: self arguments to: self
]

{ #category : #generated }
WollokMemberFeatureCallNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokMemberFeatureCallNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokMemberFeatureCallNode >> compositeNodeVariables [
	^ #(#arguments)
]

{ #category : #generated }
WollokMemberFeatureCallNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
WollokMemberFeatureCallNode >> feature [
	^ feature
]

{ #category : #generated }
WollokMemberFeatureCallNode >> feature: aSmaCCToken [
	feature := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
WollokMemberFeatureCallNode >> initialize [
	super initialize.
	arguments := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokMemberFeatureCallNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokMemberFeatureCallNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
WollokMemberFeatureCallNode >> nodeVariables [
	^ #(#receiver)
]

{ #category : #generated }
WollokMemberFeatureCallNode >> nullSafe [
	^ nullSafe
]

{ #category : #generated }
WollokMemberFeatureCallNode >> nullSafe: aSmaCCToken [
	nullSafe := aSmaCCToken
]

{ #category : #generated }
WollokMemberFeatureCallNode >> periodToken [
	^ periodToken
]

{ #category : #generated }
WollokMemberFeatureCallNode >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
]

{ #category : #generated }
WollokMemberFeatureCallNode >> receiver [
	^ receiver
]

{ #category : #generated }
WollokMemberFeatureCallNode >> receiver: aWollokAbstractNodeNode [
	self receiver notNil
		ifTrue: [ self receiver parent: nil ].
	receiver := aWollokAbstractNodeNode.
	self receiver notNil
		ifTrue: [ self receiver parent: self ]
]

{ #category : #generated }
WollokMemberFeatureCallNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokMemberFeatureCallNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokMemberFeatureCallNode >> tokenVariables [
	^ #(#periodToken #feature #leftParenToken #rightParenToken #nullSafe)
]
