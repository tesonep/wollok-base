Class {
	#name : #WRTestResultError,
	#superclass : #WRTestResult,
	#instVars : [
		'reason'
	],
	#category : #'Wollok-UI'
}

{ #category : #combining }
WRTestResultError >> + anotherResult [ 
	
	^ anotherResult combineWithError: self
]

{ #category : #combining }
WRTestResultError >> combineWithError: aWRTestResultError [ 
	
	^ self
]

{ #category : #accessing }
WRTestResultError >> icon [

	^ self iconNamed: #testRed
]

{ #category : #testing }
WRTestResultError >> isError [

	^ true
]

{ #category : #accessing }
WRTestResultError >> reason: aString [ 
	
	reason := aString
]
