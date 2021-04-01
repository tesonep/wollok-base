Class {
	#name : #WRTestResult,
	#superclass : #Object,
	#category : #'Wollok-UI'
}

{ #category : #combining }
WRTestResult >> combineWithPassed: aWRTestResultPassed [ 
	
	self subclassResponsibility
]

{ #category : #testing }
WRTestResult >> isError [

	^ false
]
