Class {
	#name : #WollokVMInstanceVariablesTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-Base'
}

{ #category : #tests }
WollokVMInstanceVariablesTest >> testConstantsAreInitializedWithCorrectValue [

	| returnObject |

	interpreter addBindingOfClass: 'MyClass' fromString: '
			class	MyClass {  
				
				const aVar = 7
				
				method doSomething(){
					return aVar
				}
			}
			'.

	returnObject := self interpretExpression: 'new MyClass().doSomething()'.
	
	self assert: returnObject literalValue equals: 7
]

{ #category : #tests }
WollokVMInstanceVariablesTest >> testConstantsCannotBeModified [

	interpreter addBindingOfClass: 'MyClass' fromString: '
			class	MyClass {  
				
				const aVar = 7
				
				method doSomething(){
					aVar = 25
				}
			}
			'.

	self should: [self interpretExpression: 'new MyClass().doSomething()'] raise: WollokError
]

{ #category : #tests }
WollokVMInstanceVariablesTest >> testVariablesAreInitializedWithCorrectValue [

	| returnObject |

	interpreter addBindingOfClass: 'MyClass' fromString: '
			class	MyClass {  
				
				var aVar = 7
				
				method doSomething(){
					return aVar
				}
			}
			'.

	returnObject := self interpretExpression: 'new MyClass().doSomething()'.
	
	self assert: returnObject literalValue equals: 7
]

{ #category : #tests }
WollokVMInstanceVariablesTest >> testVariablesCanBeInitializedWithAnExpression [

	| returnObject |
	interpreter addBindingOfClass: 'MyClass' fromString: '
			class	MyClass {  
				
				var aVar = 7 * 3
				
				method doSomething(){
					return aVar
				}
			}
			'.

	returnObject := self interpretExpression: 'new MyClass().doSomething()'.
	
	self assert: returnObject literalValue equals: 21
]

{ #category : #tests }
WollokVMInstanceVariablesTest >> testVariablesCanBeModified [

	| returnObject |
	interpreter addBindingOfClass: 'MyClass' fromString: '
			class	MyClass {  
				
				var aVar = 7
				
				method doSomething(){
					aVar = 25
					return aVar
				}
			}
			'.

	returnObject := self interpretExpression: 'new MyClass().doSomething()'.
	
	self assert: returnObject literalValue equals: 25
]
