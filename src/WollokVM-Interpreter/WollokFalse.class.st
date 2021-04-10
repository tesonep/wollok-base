Class {
	#name : #WollokFalse,
	#superclass : #Object,
	#instVars : [
		'interpreter'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #accessing }
WollokFalse >> interpreter [
	^ interpreter
]

{ #category : #accessing }
WollokFalse >> interpreter: anObject [
	interpreter := anObject
]

{ #category : #'logical operations' }
WollokFalse >> isWollokFalse [

	^ true
]

{ #category : #'logical operations' }
WollokFalse >> isWollokTrue [

	^ false
]

{ #category : #operators }
WollokFalse >> wollokIdenticalTo: anotherWollokObject [

	^ interpreter asWollokBoolean: anotherWollokObject isWollokFalse
]

{ #category : #'logical operations' }
WollokFalse >> | unBooleano [

	^ unBooleano
]
