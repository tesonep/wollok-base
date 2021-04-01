Class {
	#name : #WollokTestRunner,
	#superclass : #SpPresenter,
	#instVars : [
		'testTree',
		'buttons',
		'runButton',
		'testFiles',
		'progressBar',
		'code'
	],
	#category : #'Wollok-UI'
}

{ #category : #specs }
WollokTestRunner class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal 
			add: #testTree;
			add: #code;
			yourself);
		add: #progressBar withConstraints: [ :constraints | constraints height: 10 ];
		add: #buttons height: 50;
		yourself
]

{ #category : #initialization }
WollokTestRunner >> allTestsCases [

	^ testFiles gather: [ :file | file testCases ]
]

{ #category : #initialization }
WollokTestRunner >> debugTests: tests [

	[
		tests doWithIndex: [ :e :i |
			e debug.
			self defer: [ 
				progressBar adapter widget submorphs first value: (i / tests size) asFloat ] ].
		self defer: [ self updateTree ].
	] forkAt: 39.
]

{ #category : #highlighting }
WollokTestRunner >> highlight: anAST [

	^ WollokSyntaxHighlighter new highlight: anAST
]

{ #category : #TOREMOVE }
WollokTestRunner >> initialExtent [

	^ 800@600
]

{ #category : #initialization }
WollokTestRunner >> initializePresenter [

	self updateTree.
	
	testTree whenSelectionChangedDo: [ :selection |
		self select: selection selectedItem ]. 
	
	progressBar fixedPercentage: 0.
	runButton action: [ self runAllTests ]
]

{ #category : #initialization }
WollokTestRunner >> initializeWidgets [

	testTree := self newTreeTable.
	testTree
		addColumn: (SpCompositeTableColumn new
			title: 'Test'; 
			addColumn: ((SpImageTableColumn evaluated: [ :each | each icon ]) width: 20);
			addColumn: (SpStringTableColumn evaluated: [ :each | each name ]));
		children: [ :node | node children ];
		contextMenu: [ self newMenu
			addItem: [ :anItem | 
				anItem
					name: 'Run';
					action: [ self runTests: testTree selectedItem testCases ] ];
			addItem: [ :anItem | 
				anItem
					name: 'Debug';
					action: [ self debugTests: testTree selectedItem testCases ] ];
			yourself ].

	code := self newText.
	
	progressBar := self newProgressBar.
	
	buttons := self newButtonBar.
	buttons add: (runButton := self newButton).
	runButton label: 'Run tests'
]

{ #category : #initialization }
WollokTestRunner >> runAllTests [

	self runTests: self allTestsCases
]

{ #category : #initialization }
WollokTestRunner >> runTests: tests [

	[
		tests doWithIndex: [ :e :i |
			e run.
			self defer: [ 
				progressBar adapter widget submorphs first value: (i / tests size) asFloat ] ].
		self defer: [ self updateTree ].
	] forkAt: 39.
]

{ #category : #events }
WollokTestRunner >> select: aWollokTestElement [ 
	
	aWollokTestElement ifNil: [ 
		code text: ''.
		^ self ].

	code text: (self highlight: aWollokTestElement topASTNode)
]

{ #category : #initialization }
WollokTestRunner >> testFiles [

	| directory |
	
	testFiles ifNotNil: [ ^ testFiles ].
	
	directory := WollokPlatform current essentialTestsRootDirectory.
	testFiles := OrderedCollection new.
	directory allChildren 
		select: [ :e | #( 'wtest') includes: e extension ]
		thenDo: [ :e | | testFile |
			testFile := WollokTestFile forFile: e.
			testFile isEmpty ifFalse: [ testFiles add: testFile ] ].
	^ testFiles
]

{ #category : #initialization }
WollokTestRunner >> updateTree [

	testTree roots: self testFiles.
]
