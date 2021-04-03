Class {
	#name : #WollowVMInterpreterSimpleSendingMessageTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-3.Objects and Classes'
}

{ #category : #running }
WollowVMInterpreterSimpleSendingMessageTest >> setUp [ 

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
WollowVMInterpreterSimpleSendingMessageTest >> testNewExpressionReturnsWollokObjectOfCorrectClass [

	| anObject |
	anObject := self interpretExpression: 'new MyClass()'.
	
	self assert: anObject wollokClassName equals: 'MyClass'
]

{ #category : #tests }
WollowVMInterpreterSimpleSendingMessageTest >> testSendingAMessageThatReturnsIntegerConstantReturnsConstantValue [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().answerToEverything()'.
	
	self assert: anObject literalValue equals: 42
]

{ #category : #tests }
WollowVMInterpreterSimpleSendingMessageTest >> testSendingAMessageThatReturnsIntegerConstantReturnsNumber [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().answerToEverything()'.
	
	self assert: anObject wollokClassName equals: 'wollok.lang.Number'
]
