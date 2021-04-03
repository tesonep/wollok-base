Class {
	#name : #WollowVMInitializationTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-3.Objects and Classes'
}

{ #category : #running }
WollowVMInitializationTest >> setUp [ 

	super setUp.
	
	interpreter addBindingOfClass: 'MyClass' fromString: '
class	MyClass {  
	var a
	var b 
	
	method initialize() {
		a = 3
	}

	method getA(){
		return a
	}

	method getB(){
		return b
	}

	method setA(aValue){
		a = aValue
	}
}
'.
]

{ #category : #tests }
WollowVMInitializationTest >> testInstanceVariableIsInitializedWithInitializeMethod [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().getA()'.
	
	self assert: anObject literalValue equals: 3
]

{ #category : #tests }
WollowVMInitializationTest >> testUninitializedVariableIsInitializedInNull [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().getB()'.
	
	self assert: (interpreter isNull: anObject)
]
