Class {
	#name : #WollowVMInheritanceTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-3.Objects and Classes'
}

{ #category : #running }
WollowVMInheritanceTest >> setUp [ 

	super setUp.

	interpreter addBindingOfClass: 'MySuperclass' fromString: '
	class MySuperclass { 
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
	
	interpreter addBindingOfClass: 'MyClass' fromString: '
class	MyClass inherits MySuperclass {  
	override method setA(aValue){
		super(aValue + 1)
	}
}
'.
]

{ #category : #running }
WollowVMInheritanceTest >> testInstanceVariableCanBeModified [

	| anObject |
	anObject := self interpretExpression: '
	var a = new MyClass()
	a.setB(77)
	a.getA()'.
	
	self assert: anObject literalValue equals: 78
]

{ #category : #running }
WollowVMInheritanceTest >> testInstanceVariableIsInitializedWithInitializeMethod [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().getA()'.
	
	self assert: anObject literalValue equals: 3
]

{ #category : #running }
WollowVMInheritanceTest >> testUninitializedVariableIsInitializedInNull [

	| anObject |
	anObject := self interpretExpression: 'new MyClass().getB()'.
	
	self assert: (interpreter isNull: anObject)
]
