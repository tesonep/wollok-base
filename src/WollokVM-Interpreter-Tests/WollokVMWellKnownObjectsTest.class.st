Class {
	#name : #WollokVMWellKnownObjectsTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-6.Well Known Objects'
}

{ #category : #'as yet unclassified' }
WollokVMWellKnownObjectsTest >> setUp [ 

	super setUp.
	
	interpreter addBindingOfClass: 'myObject' fromString: '
object myObject { 
	var a = 7
	
	method getVar(){
		return a
	}
}
'.
]

{ #category : #'as yet unclassified' }
WollokVMWellKnownObjectsTest >> testWellKnownObjectCanReceiveMessages [

	| object |

	object := self interpretExpression: 'myObject.getA()'.
	
	self assert: object literalValue equals: 7
]

{ #category : #'as yet unclassified' }
WollokVMWellKnownObjectsTest >> testWellKnownObjectHasTheCorrectClass [

	| object |

	object := self interpretExpression: 'myObject'.
	
	"This test depends of how the classes of literal objects are implemented"
	self fail.
]

{ #category : #'as yet unclassified' }
WollokVMWellKnownObjectsTest >> testliteralObjectCanReceiveMessages [

	| object |

	object := self interpretExpression: 'object {
		var a = 4
		
		method getA(){
			return a
		}
	}.getA()'.
	
	self assert: object literalValue equals: 4

]

{ #category : #'as yet unclassified' }
WollokVMWellKnownObjectsTest >> testliteralObjectHasTheCorrectClass [

	| object |

	object := self interpretExpression: 'object {
		var a = 4
		
		method getA(){
			return a
		}
	}'.
	
	"This test depends of how the classes of literal objects are implemented"
	self fail.
]
