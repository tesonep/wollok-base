Class {
	#name : #WRTestCase,
	#superclass : #Object,
	#instVars : [
		'astNode',
		'result',
		'suite'
	],
	#category : #'Wollok-UI'
}

{ #category : #accessing }
WRTestCase >> astNode [
	^ astNode
]

{ #category : #accessing }
WRTestCase >> astNode: aWollokTestNode [ 
	astNode := aWollokTestNode
]

{ #category : #accessing }
WRTestCase >> children [
	
	^ #()
]

{ #category : #running }
WRTestCase >> debug [

	self runOnErrorDo: [ :e | e pass ]
]

{ #category : #accessing }
WRTestCase >> fileNode [
	
	^ self suite fileNode
]

{ #category : #accessing }
WRTestCase >> icon [
	
	^ result icon
]

{ #category : #accessing }
WRTestCase >> initialize [

	super initialize.
	result := WRTestResultNotRun new
]

{ #category : #testing }
WRTestCase >> isError [
	
	^ result isError
]

{ #category : #accessing }
WRTestCase >> name [
	
	^ astNode name value value allButFirst allButLast
]

{ #category : #results }
WRTestCase >> recordError: aString [ 

	result := WRTestResultError new.
	result reason: aString
]

{ #category : #results }
WRTestCase >> recordFailure: aString [ 

	result := WRTestResultFailure new.
	result reason: aString
]

{ #category : #results }
WRTestCase >> recordSuccess [
	
	result := WRTestResultPassed new
]

{ #category : #accessing }
WRTestCase >> result [
	^ result
]

{ #category : #accessing }
WRTestCase >> result: anObject [
	result := anObject
]

{ #category : #running }
WRTestCase >> run [

	self runOnErrorDo: [ :e | self recordError: e ]
]

{ #category : #running }
WRTestCase >> runOnErrorDo: errorBlock [

	| interpreter wollokSuite wollokTestCase |
	
	interpreter := WollokPlatform current newInterpreterWithRootFileNode: self fileNode.
	
	wollokSuite := interpreter rootPackage suites
		detect: [ :e | e ast = self suite astNode ]
		ifNone: [ interpreter rootPackage defaultSuite ].
	wollokTestCase := wollokSuite tests detect: [ :e | 
		e ast = astNode ].
	
	interpreter rootPackage resolveBindingsUsing: interpreter.

	[[ 
		interpreter rootPackage initializeStateUsing: interpreter.
		"Clean the interpreter state so far"
		interpreter initialize.

		interpreter
			activateMethod: wollokTestCase
			withReceiver: (wollokSuite instantiateUsing: interpreter)
			withArguments: #().
 		self recordSuccess ] on: WollokError do: [ :e |
			(e wollokException wollokClass = (interpreter resolve: 'wollok.lib.AssertionException'))
				ifTrue: [ self recordFailure: e wollokException unbox unbox ]
				ifFalse: [ e pass ] ]]
			on: Error do: [ :e | errorBlock value: e ].

]

{ #category : #accessing }
WRTestCase >> sourceCode [
	
	^ astNode source
]

{ #category : #accessing }
WRTestCase >> suite [
	
	^ suite
]

{ #category : #accessing }
WRTestCase >> suite: anObject [
	suite := anObject
]

{ #category : #accessing }
WRTestCase >> testCases [
	
	^ { self }
]

{ #category : #accessin }
WRTestCase >> topASTNode [

	^ astNode topParent
]
