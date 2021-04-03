Class {
	#name : #WollowVMInterpreterControlFlowTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-2.ControlFlow'
}

{ #category : #tests }
WollowVMInterpreterControlFlowTest >> testIfUsedAsAnExpression [

	| returnValue |
	returnValue := self interpretExpression: 'if(3 > 2) 42 else 20'.
	self assert: returnValue literalValue equals: 42
]

{ #category : #tests }
WollowVMInterpreterControlFlowTest >> testIfUsedAsAnExpressionReturnsFalseValueIfFalse [

	| returnValue |
	returnValue := self interpretExpression: 'if(3 < 2) 42 else 20'.
	self assert: returnValue literalValue equals: 20
]

{ #category : #tests }
WollowVMInterpreterControlFlowTest >> testIfUsedAsControlFlow [

	| returnValue |

	interpreter addBindingOfClass: 'MyClass' fromString: '
class	MyClass {  
	method answerToEverything(){
		var a = 1
		
		if(3 > 2)
			a = 42
		else { a = 26 }			
		
		return a
	}
}
'.

	returnValue := self interpretExpression: 'new MyClass().answerToEverything()'.
	self assert: returnValue literalValue equals: 42
]

{ #category : #tests }
WollowVMInterpreterControlFlowTest >> testIfUsedToEarlyReturn [

	| returnValue |

	interpreter addBindingOfClass: 'MyClass' fromString: '
class	MyClass {  
	method answerToEverything(){
		var a = 1
		
		if(3 > 2)
			return 42		
		
		a = 26
		return a
	}
}
'.

	returnValue := self interpretExpression: 'new MyClass().answerToEverything()'.
	self assert: returnValue literalValue equals: 42
]
