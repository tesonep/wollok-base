Class {
	#name : #WRTestResultPassed,
	#superclass : #WRTestResult,
	#category : #'Wollok-UI'
}

{ #category : #combining }
WRTestResultPassed >> + anotherResult [ 
	
	^ anotherResult combineWithPassed: self
]

{ #category : #combining }
WRTestResultPassed >> combineWithPassed: aWRTestResultPassed [ 
	
	^ self
]

{ #category : #accessing }
WRTestResultPassed >> icon [

	^ self iconNamed: #testGreen
]
