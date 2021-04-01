Class {
	#name : #WollokAbstractNodeNode,
	#superclass : #SmaCCParseNode,
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokAbstractNodeNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitAbstractNode: self
]

{ #category : #accessing }
WollokAbstractNodeNode >> methodNode [
	
	"I'm not a method declaration"
	^ parent methodNode
]
