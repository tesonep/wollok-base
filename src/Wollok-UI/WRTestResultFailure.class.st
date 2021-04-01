Class {
	#name : #WRTestResultFailure,
	#superclass : #WRTestResult,
	#instVars : [
		'reason'
	],
	#category : #'Wollok-UI'
}

{ #category : #combining }
WRTestResultFailure >> combineWithPassed: aWRTestResultPassed [ 
	
	^ self
]

{ #category : #accessing }
WRTestResultFailure >> icon [

	^ self iconNamed: #testYellow
]

{ #category : #accessing }
WRTestResultFailure >> reason: aString [ 
	
	reason := aString
]
