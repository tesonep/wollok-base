Class {
	#name : #WollowVMInterpreterStringTests,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-1.Basic Types'
}

{ #category : #tests }
WollowVMInterpreterStringTests >> testConcatenationOfStringsHasCorrectValue [

	| object |
	
	object := self interpretExpression: '"abc" + "123"'.
	self assert: object literalValue equals: 'abc123'
]

{ #category : #tests }
WollowVMInterpreterStringTests >> testConcatenationOfStringsIsAWollokString [

	| object |
	
	object := self interpretExpression: '"abc" + "123"'.
	self assert: object wollokClassName equals: 'wollok.lang.String'
]

{ #category : #tests }
WollowVMInterpreterStringTests >> testConstantStringHasCorrectValue [

	| object |
	
	object := self interpretExpression: '"abc"'.
	self assert: object literalValue equals: 'abc'
]

{ #category : #tests }
WollowVMInterpreterStringTests >> testConstantStringIsAWollokString [

	| object |
	
	object := self interpretExpression: '"abc"'.
	self assert: object wollokClassName equals: 'wollok.lang.String'
]
