Class {
	#name : #WollokTestFile,
	#superclass : #Object,
	#instVars : [
		'suites',
		'astNode',
		'file'
	],
	#category : #'Wollok-UI'
}

{ #category : #'instance creation' }
WollokTestFile class >> forFile: aFile [

	| instance wollokFileNode |
	instance := self new.
	instance file: aFile.
	
	wollokFileNode := WollokPlatform current wollokParserClass parseFile: aFile.
	instance astNode: wollokFileNode.
	
	wollokFileNode tests ifNotEmpty: [ | suite |
		suite := instance addDefaultSuite.
		wollokFileNode tests do: [ :aTestNode |
			suite addTestForAST: aTestNode
		] ].
	wollokFileNode suites do: [ :aSuiteNode | | suite |
		suite := instance addSuiteForAST: aSuiteNode.
		aSuiteNode tests do: [ :aTestNode |
			suite addTestForAST: aTestNode
		] ].
	^ instance
]

{ #category : #building }
WollokTestFile >> addDefaultSuite [
	
	^ self addSuiteForAST: nil
]

{ #category : #building }
WollokTestFile >> addSuiteForAST: aWollokSuiteNode [ 
	
	| suite |
	suite := WRTestSuite new
		astNode: aWollokSuiteNode;
		file: self;
		yourself.
	suites add: suite.
	^ suite
]

{ #category : #accessing }
WollokTestFile >> astNode [
	^ astNode
]

{ #category : #accessing }
WollokTestFile >> astNode: aWollokFileNode [

	astNode := aWollokFileNode 
]

{ #category : #accessing }
WollokTestFile >> children [
	
	^ suites
]

{ #category : #running }
WollokTestFile >> debug [
	
	suites do: [ :suite | suite debug ]
]

{ #category : #accessing }
WollokTestFile >> file: aFileReference [ 
	
	file := aFileReference
]

{ #category : #accessing }
WollokTestFile >> icon [
	
	(suites anySatisfy: [ :e | e isError ])
		ifTrue: [ ^ self iconNamed: #testRed ].
	^ self iconNamed: #catalog
]

{ #category : #building }
WollokTestFile >> initialize [
	super initialize.
	suites := OrderedCollection new
]

{ #category : #testing }
WollokTestFile >> isEmpty [
	
	^ suites isEmpty
]

{ #category : #accessing }
WollokTestFile >> name [
	
	^ (file relativeTo: WollokPlatform current sanityTestsRootDirectory) pathString
]

{ #category : #running }
WollokTestFile >> run [
	
	suites do: [ :suite | suite run ]
]

{ #category : #accessing }
WollokTestFile >> sourceCode [
	
	^ astNode source
]

{ #category : #accessing }
WollokTestFile >> testCases [
	
	^ suites gather: [ :suite | suite testCases ]
]

{ #category : #accessing }
WollokTestFile >> topASTNode [
	
	^ astNode topParent
]
