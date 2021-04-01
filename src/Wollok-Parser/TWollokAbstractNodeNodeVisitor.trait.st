Trait {
	#name : #TWollokAbstractNodeNodeVisitor,
	#traits : 'TSmaCCParseNodeVisitor',
	#classTraits : 'TSmaCCParseNodeVisitor classTrait',
	#category : #'Wollok-Parser'
}

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitAbstractNode: anAbstractNode [
	^ self visitSmaCCParseNode: anAbstractNode
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitAssignment: anAssignment [
	^ self visitAbstractNode: anAssignment
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitBinaryOperation: aBinaryOperation [
	^ self visitAbstractNode: aBinaryOperation
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitBlockExpression: aBlockExpression [
	^ self visitAbstractNode: aBlockExpression
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitBooleanLiteral: aBooleanLiteral [
	^ self visitAbstractNode: aBooleanLiteral
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitCatch: aCatch [
	^ self visitAbstractNode: aCatch
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitClass: aClass [
	^ self visitAbstractNode: aClass
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitClosure: aClosure [
	^ self visitAbstractNode: aClosure
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitConstructor: aConstructor [
	^ self visitAbstractNode: aConstructor
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitConstructorCall: aConstructorCall [
	^ self visitAbstractNode: aConstructorCall
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitFile: aFile [
	^ self visitAbstractNode: aFile
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitFixture: aFixture [
	^ self visitAbstractNode: aFixture
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitIfExpression: anIfExpression [
	^ self visitAbstractNode: anIfExpression
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitImport: anImport [
	^ self visitAbstractNode: anImport
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitInitializer: anInitializer [
	^ self visitAbstractNode: anInitializer
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitListLiteral: aListLiteral [
	^ self visitAbstractNode: aListLiteral
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitMemberFeatureCall: aMemberFeatureCall [
	^ self visitAbstractNode: aMemberFeatureCall
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitMethodDeclaration: aMethodDeclaration [
	^ self visitAbstractNode: aMethodDeclaration
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitMixin: aMixin [
	^ self visitAbstractNode: aMixin
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitNamedArgumentsList: aNamedArgumentsList [
	^ self visitAbstractNode: aNamedArgumentsList
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitNamedObject: aNamedObject [
	^ self visitAbstractNode: aNamedObject
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitNullLiteral: aNullLiteral [
	^ self visitAbstractNode: aNullLiteral
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitNumberLiteral: aNumberLiteral [
	^ self visitAbstractNode: aNumberLiteral
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitObjectLiteral: anObjectLiteral [
	^ self visitAbstractNode: anObjectLiteral
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitPackage: aPackage [
	^ self visitAbstractNode: aPackage
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitParameter: aParameter [
	^ self visitAbstractNode: aParameter
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitParenthesizedExpression: aParenthesizedExpression [
	^ self visitAbstractNode: aParenthesizedExpression
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitPositionalArgumentsList: aPositionalArgumentsList [
	^ self visitAbstractNode: aPositionalArgumentsList
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitPostfixOperation: aPostfixOperation [
	^ self visitAbstractNode: aPostfixOperation
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitProgram: aProgram [
	^ self visitAbstractNode: aProgram
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitQualifiedName: aQualifiedName [
	^ self visitAbstractNode: aQualifiedName
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitQualifiedNameWithWildcard: aQualifiedNameWithWildcard [
	^ self visitAbstractNode: aQualifiedNameWithWildcard
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitReturnExpression: aReturnExpression [
	^ self visitAbstractNode: aReturnExpression
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitSelf: aSelf [
	^ self visitAbstractNode: aSelf
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitSelfDelegatingConstructorCall: aSelfDelegatingConstructorCall [
	^ self visitAbstractNode: aSelfDelegatingConstructorCall
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitSetLiteral: aSetLiteral [
	^ self visitAbstractNode: aSetLiteral
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitStringLiteral: aStringLiteral [
	^ self visitAbstractNode: aStringLiteral
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitSuite: aSuite [
	^ self visitAbstractNode: aSuite
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitSuperDelegatingConstructorCall: aSuperDelegatingConstructorCall [
	^ self visitAbstractNode: aSuperDelegatingConstructorCall
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitSuperInvocation: aSuperInvocation [
	^ self visitAbstractNode: aSuperInvocation
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitTest: aTest [
	^ self visitAbstractNode: aTest
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitThrow: aThrow [
	^ self visitAbstractNode: aThrow
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitTry: aTry [
	^ self visitAbstractNode: aTry
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitUnaryOperation: anUnaryOperation [
	^ self visitAbstractNode: anUnaryOperation
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitVariable: aVariable [
	^ self visitAbstractNode: aVariable
]

{ #category : #generated }
TWollokAbstractNodeNodeVisitor >> visitVariableDeclaration: aVariableDeclaration [
	^ self visitAbstractNode: aVariableDeclaration
]
