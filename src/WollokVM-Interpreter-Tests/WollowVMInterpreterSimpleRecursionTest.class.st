Class {
	#name : #WollowVMInterpreterSimpleRecursionTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-4.Stack'
}

{ #category : #running }
WollowVMInterpreterSimpleRecursionTest >> setUp [ 

	super setUp.
	
	interpreter addBindingOfClass: 'MyClass' fromString: '
class	MyClass {  
	method doSomething(){
		return recursiveCall(0)
	}
	
	method recursiveCall(aValue) { 
		if(aValue = 42)
			return aValue
		else
			return self.recursiveCall(aValue + 1)
	}
}
'.
]

{ #category : #tests }
WollowVMInterpreterSimpleRecursionTest >> testSendingRecursiveCallReturnsCorrectValue [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().doSomething()'.
	
	self assert: anObject literalValue equals: '42'
]
