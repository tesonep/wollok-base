Class {
	#name : #WollowVMInterpreterNumberTests,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-2.Essential-Numbers'
}

{ #category : #'tests - constants' }
WollowVMInterpreterNumberTests >> testLiteralDecimalNumberIsAWollokNumber [

	| maybeANumber |

	maybeANumber := self interpretExpression: '1.73'.

	self assert: maybeANumber wollokClassName equals: 'wollok.lang.Number'
]

{ #category : #'tests - constants' }
WollowVMInterpreterNumberTests >> testLiteralNegativeDecimalNumberIsAWollokNumber [

	| maybeANumber |

	maybeANumber := self interpretExpression: '-1.73'.

	self assert: maybeANumber wollokClassName equals: 'wollok.lang.Number'
]

{ #category : #'tests - constants' }
WollowVMInterpreterNumberTests >> testLiteralNegativeNumberIsAWollokNumber [

	| maybeANumber |

	maybeANumber := self interpretExpression: '-2'.

	self assert: maybeANumber wollokClassName equals: 'wollok.lang.Number'
]

{ #category : #'tests - constants' }
WollowVMInterpreterNumberTests >> testLiteralNumberIsAWollokNumber [

	| maybeANumber |

	maybeANumber := self interpretExpression: '1'.

	self assert: maybeANumber wollokClassName equals: 'wollok.lang.Number'
]

{ #category : #'tests - sum' }
WollowVMInterpreterNumberTests >> testSumOfTwoNumbersHasCorrectValue [

	| maybeANumber |

	maybeANumber := self interpretExpression: '1 + 2'.

	self assert: maybeANumber literalValue equals: 3
]

{ #category : #'tests - sum' }
WollowVMInterpreterNumberTests >> testSumOfTwoNumbersIsAWollokNumber [

	| maybeANumber |

	maybeANumber := self interpretExpression: '1 + 2'.

	self assert: maybeANumber wollokClassName equals: 'wollok.lang.Number'
]

{ #category : #'tests - sum' }
WollowVMInterpreterNumberTests >> testSumOfTwoNumbersWithDecimalsHasCorrectValue [

	| maybeANumber |

	maybeANumber := self interpretExpression: '1 + 2.73'.

	self assert: maybeANumber literalValue equals: 3.73
]

{ #category : #'tests - sum' }
WollowVMInterpreterNumberTests >> testSumOfTwoNumbersWithDecimalsIsAWollokNumber [

	| maybeANumber |

	maybeANumber := self interpretExpression: '1 + 2.73'.

	self assert: maybeANumber wollokClassName equals: 'wollok.lang.Number'
]
