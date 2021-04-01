Class {
	#name : #WRTestResultNotRun,
	#superclass : #WRTestResult,
	#category : #'Wollok-UI'
}

{ #category : #combining }
WRTestResultNotRun >> + aTestResult [
	
	^ aTestResult
]

{ #category : #combining }
WRTestResultNotRun >> combineWithPassed: aWRTestResultPassed [ 
	
	^ aWRTestResultPassed
]

{ #category : #accessing }
WRTestResultNotRun >> icon [

	^ self iconNamed: #testNotRun
]
