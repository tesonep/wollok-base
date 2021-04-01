Class {
	#name : #AbstractWollokVMInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #'WollokVM-Interpreter-Tests-Base'
}

{ #category : #testing }
AbstractWollokVMInterpreterTest class >> isAbstract [ 

	^ self = AbstractWollokVMInterpreterTest
]

{ #category : #running }
AbstractWollokVMInterpreterTest >> interpretExpression: aString [

	^ interpreter interpretProgram: (self parse: (self wrapForREPL: aString))
]

{ #category : #parsing }
AbstractWollokVMInterpreterTest >> parse: aString [ 
	
	| anAST |
	anAST := WollokParser parse: aString.
	anAST attributeNamed: #source put: aString.

	^ anAST
]

{ #category : #running }
AbstractWollokVMInterpreterTest >> setUp [

	interpreter := WollokASTInterpreter new		

]

{ #category : #utils }
AbstractWollokVMInterpreterTest >> wrapForREPL: aString [

	^ String streamContents: [ :aStream | 
			aStream 
				nextPutAll:	'program testExpression {'; cr;
				tab; nextPutAll: aString; cr;
	 			nextPutAll: '}'
		 ]
]
