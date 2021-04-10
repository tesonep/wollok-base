Class {
	#name : #WollokTrue,
	#superclass : #Object,
	#category : #'WollokVM-Interpreter'
}

{ #category : #'logical operations' }
WollokTrue >> & unBooleano [

	^ unBooleano
]

{ #category : #'logical operations' }
WollokTrue >> isWollokFalse [

	^ false
]

{ #category : #'logical operations' }
WollokTrue >> isWollokTrue [

	^ true
]

{ #category : #'native methods' }
WollokTrue >> | aWollokBoolean [

	^ self
]
