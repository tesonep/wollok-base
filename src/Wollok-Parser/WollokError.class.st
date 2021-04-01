Class {
	#name : #WollokError,
	#superclass : #Error,
	#instVars : [
		'wollokException'
	],
	#category : #'Wollok-Parser'
}

{ #category : #accessing }
WollokError >> wollokException [
	^ wollokException
]

{ #category : #accessing }
WollokError >> wollokException: aWollokObject [ 

	wollokException := aWollokObject 
]
