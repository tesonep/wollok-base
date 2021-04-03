Class {
	#name : #WollowVMInstanceVariablesTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-3.Objects and Classes'
}

{ #category : #running }
WollowVMInstanceVariablesTest >> setUp [ 

	super setUp.
	
	interpreter addBindingOfClass: 'MyClass' fromString: '
class	MyClass {  
	var a = 1 * 3
	var b 
	
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
WollowVMInstanceVariablesTest >> testInstanceVariableCanBeModified [

	| anObject |
	anObject := self interpretExpression: '
	var a = new MyClass()
	a.setB(77)
	a.getA()'.
	
	self assert: anObject literalValue equals: 77
]

{ #category : #tests }
WollowVMInstanceVariablesTest >> testInstanceVariableIsInitializedWithExpression [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().getA()'.
	
	self assert: anObject literalValue equals: 3
]

{ #category : #tests }
WollowVMInstanceVariablesTest >> testUninitializedVariableIsInitializedInNull [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().getB()'.
	
	self assert: (interpreter isNull: anObject)
]
