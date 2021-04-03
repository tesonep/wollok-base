Class {
	#name : #WollokVMCollectionsTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-5.Collections'
}

{ #category : #tests }
WollokVMCollectionsTest >> testContainsReturnsTheBoolean [

	| object |
	
	object := self interpretExpression: '[2, 3 , 4].contains(3)'.
	self assert: object literalValue equals: true
]

{ #category : #tests }
WollokVMCollectionsTest >> testLiteralListIsAWollokList [

	| object |
	
	object := self interpretExpression: '[2, 3 , 4]'.
	self assert: object wollokClassName equals: 'wollok.lang.List'
]

{ #category : #tests }
WollokVMCollectionsTest >> testSizeReturnsTheSize [

	| object |
	
	object := self interpretExpression: '[2, 3 , 4].size()'.
	self assert: object literalValue equals: 3
]
