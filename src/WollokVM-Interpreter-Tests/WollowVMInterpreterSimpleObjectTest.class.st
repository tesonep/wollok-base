Class {
	#name : #WollowVMInterpreterSimpleObjectTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-1.Essential-Objects'
}

{ #category : #running }
WollowVMInterpreterSimpleObjectTest >> setUp [ 

	super setUp.
	
	interpreter addBindingOfClass: 'MyClass' fromString: '
class	MyClass {  
	method answerToEverything(){
		return 42
	}
	
	method isAlwaysRight() { 
		true
	}
}
'.
]

{ #category : #tests }
WollowVMInterpreterSimpleObjectTest >> testNewExpressionReturnsWollokObjectOfCorrectClass [

	| anObject |
	anObject := self interpretExpression: 'new MyClass()'.
	
	self assert: anObject wollokClassName equals: 'MyClass'
]

{ #category : #tests }
WollowVMInterpreterSimpleObjectTest >> testSendingAMessageThatReturnsIntegerConstantReturnsConstantValue [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().answerToEverything()'.
	
	self assert: anObject literalValue equals: 42
]

{ #category : #tests }
WollowVMInterpreterSimpleObjectTest >> testSendingAMessageThatReturnsIntegerConstantReturnsNumber [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().answerToEverything()'.
	
	self assert: anObject wollokClassName equals: 'wollok.lang.Number'
]
