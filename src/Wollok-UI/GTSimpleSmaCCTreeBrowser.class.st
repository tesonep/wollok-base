Class {
	#name : #GTSimpleSmaCCTreeBrowser,
	#superclass : #GLMCompositePresentation,
	#category : #'Wollok-UI'
}

{ #category : #building }
GTSimpleSmaCCTreeBrowser >> compose [
	self title: 'Tree'.
	self tabulator with: [ :browser |
		browser
			row: #tree;
			row: #source.
		browser transmit
			to: #tree;
			andShow: [ :a | self treeIn: a ].
		browser transmit
			to: #source;
			andShow: [ :a | self sourceIn: a ].
		browser transmit
			from: #tree;
			to: #source port: #selectionInterval;
			transformed: [ :rbNode | rbNode sourceInterval ].
		browser transmit
			toOutsidePort: #selection;
			from: #tree port: #selectedNode ]
]

{ #category : #building }
GTSimpleSmaCCTreeBrowser >> sourceIn: a [
	^ a pharoMethod 
		smalltalkClass: [ :each | each parents first methodClass ]; 
		display: [ :each | each source ]
]

{ #category : #building }
GTSimpleSmaCCTreeBrowser >> treeIn: a [
	^ a tree
		rootsExpanded;
		display: [ :anObject | {anObject} ];
		children: [ :each | each children ];
		selectionPopulate: #selectedNode
			on: $o
			entitled: 'Open'
			with: [ :tree | tree selection ];
		format: [ :each | 
					String
						streamContents: [ :stream | 
							stream
								nextPutAll: each class name;
								nextPut: $(;
								nextPutAll: ((each source truncateTo: 50) copyReplaceAll: String cr with: String space);
								nextPut: $) ] ]
]
