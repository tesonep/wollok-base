Class {
	#name : #WollokSyntaxHighlighter,
	#superclass : #Object,
	#instVars : [
		'text',
		'runs',
		'attributes'
	],
	#category : #'Wollok-UI'
}

{ #category : #highlighting }
WollokSyntaxHighlighter >> highlight: anAST [ 
	
	attributes := Array new: anAST completeSource size withAll: #().
	anAST acceptVisitor: self.
	^anAST completeSource asString asText runs: (RunArray newFrom: attributes)	
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitAssignment: aWollokAssignmentNode [ 
	
	aWollokAssignmentNode variable acceptVisitor: self.
	aWollokAssignmentNode value acceptVisitor: self.
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitBinaryOperation: aWollokBinaryOperationNode [ 
	
	attributes
		from: aWollokBinaryOperationNode operation startPosition
		to: aWollokBinaryOperationNode operation stopPosition
		put: { TextColor color: Color purple muchLighter }
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitBlockExpression: aWollokBlockExpressionNode [ 
	
	aWollokBlockExpressionNode expressions do: [ :e |
		e acceptVisitor: self ]
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitClass: aWollokClassNode [ 

	self visitKeywordToken: aWollokClassNode classToken.
	self visitName: aWollokClassNode name.
	aWollokClassNode variables do: [ :e |
		e acceptVisitor: self ].
	aWollokClassNode members do: [ :e |
		e acceptVisitor: self ].
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitClosure: aWollokClosureNode [ 
	
	aWollokClosureNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitFile: aWollokFileNode [ 
	
	aWollokFileNode comments do: [ :e |
		attributes
			from: e first
			to: e last
			put: { TextColor gray } ].
	aWollokFileNode children do: [ :e |
		e acceptVisitor: self ]
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitIfExpression: aWollokIfExpressionNode [ 
	
	self visitKeywordToken: aWollokIfExpressionNode ifToken.
	self visitKeywordToken: aWollokIfExpressionNode elseToken.
	
	aWollokIfExpressionNode condition acceptVisitor: self.
	aWollokIfExpressionNode then acceptVisitor: self.
	aWollokIfExpressionNode else ifNotNil: [ :else | 
		else acceptVisitor: self ].
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitKeywordToken: aToken [
	aToken ifNil: [ ^ self ].
	attributes
		from: aToken startPosition
		to: aToken stopPosition
		put: { TextEmphasis bold . TextColor color: Color orange darker darker }
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitMemberFeatureCall: aWollokMemberFeatureCallNode [ 
	
	aWollokMemberFeatureCallNode arguments do: [ :e |
		e acceptVisitor: self ]
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitMethodDeclaration: aWollokMethodDeclarationNode [ 
	
	self visitKeywordToken: aWollokMethodDeclarationNode methodToken.
	self visitName: aWollokMethodDeclarationNode name.
	aWollokMethodDeclarationNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitName: aSmaCCToken [ 

	attributes
		from: aSmaCCToken startPosition
		to: aSmaCCToken stopPosition
		put: { TextColor color: Color paleGreen }
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitNamedObject: aWollokNamedObjectNode [ 
	
	self visitKeywordToken: aWollokNamedObjectNode objectToken.
	self visitName: aWollokNamedObjectNode name.
	aWollokNamedObjectNode variables do: [ :e |
		e acceptVisitor: self ].
	aWollokNamedObjectNode members do: [ :e |
		e acceptVisitor: self ].
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	attributes
		from: aWollokNumberLiteralNode startPosition
		to: aWollokNumberLiteralNode stopPosition
		put: { TextColor color: Color lightRed }
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitObjectLiteral: aWollokObjectLiteralNode [ 
	
	self visitKeywordToken: aWollokObjectLiteralNode objectToken.
	aWollokObjectLiteralNode members do: [ :m |
		m acceptVisitor: self ]
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitReturnExpression: aWollokReturnExpressionNode [ 

	self visitKeywordToken: aWollokReturnExpressionNode returnToken.
	aWollokReturnExpressionNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitStringLiteral: aWollokStringLiteralNode [ 
	
	attributes
		from: aWollokStringLiteralNode startPosition
		to: aWollokStringLiteralNode stopPosition
		put: { TextEmphasis bold . TextColor color: Color lightGreen }
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitSuite: aWollokSuiteNode [

	aWollokSuiteNode name acceptVisitor: self.
	aWollokSuiteNode tests do: [ :e |
		e acceptVisitor: self ]
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitTest: aWollokTestNode [ 
	
	aWollokTestNode name acceptVisitor: self.
	aWollokTestNode elements do: [ :e |
		e acceptVisitor: self ]
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitUnaryOperation: aWollokUnaryOperationNode [ 
	
	self visitKeywordToken: aWollokUnaryOperationNode operation.
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitVariable: aWollokVariableNode [ 
	
	self visitName: aWollokVariableNode name
]

{ #category : #visiting }
WollokSyntaxHighlighter >> visitVariableDeclaration: aWollokVariableDeclarationNode [ 

	self visitKeywordToken: aWollokVariableDeclarationNode writable.
	self visitKeywordToken: aWollokVariableDeclarationNode constToken
]
