Class {
	#name : #WollowVMInterpreterBooleanTests,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-1.Basic Types'
}

{ #category : #tests }
WollowVMInterpreterBooleanTests >> testFalseOrFalseReturnsCorrectValue [

	| returnValue |
	returnValue := self interpretExpression: 'false || false'.
	self assert: (interpreter isFalse: returnValue)
]

{ #category : #tests }
WollowVMInterpreterBooleanTests >> testLiteralFalseIsAWollokBoolean [

	| returnValue |
	
	returnValue := self interpretExpression: 'false'.
	self assert: returnValue wollokClassName equals: 'wollok.lang.Boolean'
]

{ #category : #tests }
WollowVMInterpreterBooleanTests >> testLiteralFalseReturnsCorrectValue [

	| returnValue |
	
	returnValue := self interpretExpression: 'false'.
	self assert: (interpreter isFalse: returnValue)
]

{ #category : #tests }
WollowVMInterpreterBooleanTests >> testLiteralTrueReturnsCorrectValue [

	| returnValue |
	returnValue := self interpretExpression: 'true'.
	self assert: (interpreter isTrue: returnValue)
]

{ #category : #tests }
WollowVMInterpreterBooleanTests >> testTrueAndFalseReturnsCorrectValue [

	| returnValue |
	returnValue := self interpretExpression: 'true && false'.
	self assert: (interpreter isFalse: returnValue)
]

{ #category : #tests }
WollowVMInterpreterBooleanTests >> testTrueAndTrueReturnsCorrectValue [

	| returnValue |
	returnValue := self interpretExpression: 'true && true'.
	self assert: (interpreter isTrue: returnValue)
]

{ #category : #tests }
WollowVMInterpreterBooleanTests >> testTrueOrFalseReturnsCorrectValue [

	| returnValue |
	returnValue := self interpretExpression: 'true || false'.
	self assert: (interpreter isTrue: returnValue)
]
