Class {
	#name : #BaselineOfWollokVM,
	#superclass : #BaselineOf,
	#category : #BaselineOfWollokVM
}

{ #category : #baselines }
BaselineOfWollokVM >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			
			spec
				baseline: 'SmaCC' 
				with: [
					spec
						loads: 'Runtime';
						repository: 'github://j-brant/Smacc:7aafca9' ].
			
			spec
				package: 'Wollok-Parser' with: [ spec requires: 'SmaCC' ];
				package: 'WollokVM-Interpreter' 
					with: [ spec requires: #('Wollok-Parser') ];
				package: 'WollokVM-Interpreter-Tests' 
					with: [ spec requires: #('WollokVM-Interpreter') ];
				package: 'Wollok-UI' 
					with: [ spec requires: #('WollokVM-Interpreter') ]
			]
]
