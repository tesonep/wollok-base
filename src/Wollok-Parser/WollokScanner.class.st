Class {
	#name : #WollokScanner,
	#superclass : #SmaCCScanner,
	#category : #'Wollok-Parser'
}

{ #category : #'generated-initialization' }
WollokScanner class >> initializeKeywordMap [
	keywordMap := Dictionary new.
	#(#(93 'and' 52) #(93 'catch' 53) #(93 'class' 54) #(93 'const' 55) #(93 'constructor' 56) #(93 'describe' 57) #(93 'else' 58) #(93 'false' 59) #(93 'fixture' 60) #(93 'if' 61) #(93 'import' 62) #(93 'inherits' 63) #(93 'method' 64) #(93 'mixin' 66) #(93 'native' 67) #(93 'new' 68) #(93 'not' 69) #(93 'null' 70) #(93 'object' 71) #(93 'only' 72) #(93 'or' 73) #(93 'override' 74) #(93 'package' 75) #(93 'program' 76) #(93 'property' 77) #(93 'return' 78) #(93 'self' 79) #(93 'super' 80) #(93 'test' 81) #(93 'throw' 83) #(93 'true' 84) #(93 'try' 85) #(93 'var' 86) #(93 'with' 87))
		do: [ :each | 
			(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
				at: (each at: 2)
				put: each last ].
	^ keywordMap
]

{ #category : #generated }
WollokScanner >> emptySymbolTokenId [
	^ 201
]

{ #category : #generated }
WollokScanner >> errorTokenId [
	^ 202
]

{ #category : #generated }
WollokScanner >> scan1 [
	[ self step.
	currentCharacter == $"
		ifTrue: [ ^ self recordAndReportMatch: #(95) ].
	currentCharacter == $\
		ifTrue: [ self step.
			currentCharacter == $u
				ifTrue: [ self step.
					(currentCharacter isDigit
						or: [ (currentCharacter between: $A and: $F)
								or: [ currentCharacter between: $a and: $f ] ])
						ifTrue: [ self step.
							(currentCharacter isDigit
								or: [ (currentCharacter between: $A and: $F)
										or: [ currentCharacter between: $a and: $f ] ])
								ifTrue: [ self step.
									(currentCharacter isDigit
										or: [ (currentCharacter between: $A and: $F)
												or: [ currentCharacter between: $a and: $f ] ])
										ifTrue: [ self step.
											(currentCharacter isDigit
												or: [ (currentCharacter between: $A and: $F)
														or: [ currentCharacter between: $a and: $f ] ])
												ifTrue: [ ^ self scan1 ] ] ] ].
					^ self reportLastMatch ].
			(('"''' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $7)
						or: [ '\bfnrt' includes: currentCharacter ] ])
				ifTrue: [ ^ self scan1 ].
			^ self reportLastMatch ].
	true ] whileTrue
]

{ #category : #generated }
WollokScanner >> scan10 [
	self recordMatch: #(94).
	self step.
	currentCharacter == $.
		ifTrue: [ ^ self scan5 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan11 [
	self step.
	('+-' includes: currentCharacter)
		ifTrue: [ self step ].
	currentCharacter isDigit
		ifTrue: [ ^ self scan12 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan12 [
	[ self recordMatch: #(94).
	self step.
	currentCharacter == $.
		ifTrue: [ ^ self scan5 ].
	('Bb' includes: currentCharacter)
		ifTrue: [ ^ self scan9 ].
	currentCharacter isDigit or: [ currentCharacter == $_ ] ] whileTrue.
	('DFLdfl' includes: currentCharacter)
		ifTrue: [ ^ self scan10 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan2 [
	[ self step.
	currentCharacter == $'
		ifTrue: [ ^ self recordAndReportMatch: #(95) ].
	currentCharacter == $\
		ifTrue: [ ^ self scan3 ].
	true ] whileTrue
]

{ #category : #generated }
WollokScanner >> scan3 [
	self step.
	currentCharacter == $u
		ifTrue: [ self step.
			(currentCharacter isDigit
				or: [ (currentCharacter between: $A and: $F)
						or: [ currentCharacter between: $a and: $f ] ])
				ifTrue: [ self step.
					(currentCharacter isDigit
						or: [ (currentCharacter between: $A and: $F)
								or: [ currentCharacter between: $a and: $f ] ])
						ifTrue: [ self step.
							(currentCharacter isDigit
								or: [ (currentCharacter between: $A and: $F)
										or: [ currentCharacter between: $a and: $f ] ])
								ifTrue: [ self step.
									(currentCharacter isDigit
										or: [ (currentCharacter between: $A and: $F)
												or: [ currentCharacter between: $a and: $f ] ])
										ifTrue: [ ^ self scan2 ] ] ] ].
			^ self reportLastMatch ].
	(('"''' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $7)
				or:
					[ '\bfnrt' includes: currentCharacter ] ])
		ifTrue: [ ^ self scan2 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan4 [
	[ self step.
	currentCharacter == $*
		ifTrue: [ [ self step.
			currentCharacter == $* ] whileTrue.
			currentCharacter == $/
				ifTrue: [ ^ self recordAndReportMatch: #(91) ].
			^ self scan4 ].
	true ] whileTrue
]

{ #category : #generated }
WollokScanner >> scan5 [
	self step.
	currentCharacter isDigit
		ifTrue: [ [ self recordMatch: #(94).
			self step.
			('Bb' includes: currentCharacter)
				ifTrue: [ ^ self scan6 ].
			('Ee' includes: currentCharacter)
				ifTrue: [ self step.
					('+-' includes: currentCharacter)
						ifTrue: [ self step ].
					currentCharacter isDigit
						ifTrue: [ ^ self scan7 ].
					^ self reportLastMatch ].
			currentCharacter isDigit or: [ currentCharacter == $_ ] ] whileTrue.
			('DFLdfl' includes: currentCharacter)
				ifTrue: [ ^ self recordAndReportMatch: #(94) ] ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan6 [
	self step.
	('DIdi' includes: currentCharacter)
		ifTrue: [ ^ self recordAndReportMatch: #(94) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan7 [
	[ self recordMatch: #(94).
	self step.
	('Bb' includes: currentCharacter)
		ifTrue: [ ^ self scan6 ].
	currentCharacter isDigit or: [ currentCharacter == $_ ] ] whileTrue.
	('DFLdfl' includes: currentCharacter)
		ifTrue: [ ^ self recordAndReportMatch: #(94) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan8 [
	[ self recordMatch: #(94).
	self step.
	currentCharacter == $.
		ifTrue: [ ^ self scan5 ].
	('Bb' includes: currentCharacter)
		ifTrue: [ ^ self scan9 ].
	('Ee' includes: currentCharacter)
		ifTrue: [ ^ self scan11 ].
	currentCharacter isDigit or: [ currentCharacter == $_ ] ] whileTrue.
	('DFLdfl' includes: currentCharacter)
		ifTrue: [ ^ self scan10 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scan9 [
	self step.
	('DIdi' includes: currentCharacter)
		ifTrue: [ ^ self scan10 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForToken [
	self step.
	currentCharacter == $!
		ifTrue:
			[ ^ self scanForTokenX15 ].
	^ self scanForTokenX25
]

{ #category : #generated }
WollokScanner >> scanForTokenX1 [
	self recordMatch: #(93).
	self step.
	currentCharacter == $i
		ifTrue:
			[ ^ self scanForTokenX1X1 ].
	((currentCharacter between: $0 and: $9)
		or: [ (currentCharacter between: $A and: $Z)
				or: [ currentCharacter == $_
						or: [ (currentCharacter between: $a and: $h)
								or: [ currentCharacter between: $j and: $z ] ] ] ])
		ifTrue: [ [ self recordMatch: #(93).
			self step.
			(currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX10 [
	self recordMatch: #(18).
	self step.
	currentCharacter == $-
		ifTrue: [ ^ self recordAndReportMatch: #(19) ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(20) ].
	currentCharacter == $>
		ifTrue: [ ^ self recordAndReportMatch: #(21) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX11 [
	self recordMatch: #(38).
	self step.
	currentCharacter == $=
		ifTrue: [ self recordMatch: #(39).
			self step.
			currentCharacter == $=
				ifTrue: [ ^ self recordAndReportMatch: #(40) ].
			^ self reportLastMatch ].
	currentCharacter == $>
		ifTrue: [ ^ self recordAndReportMatch: #(41) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX12 [
	self step.
	currentCharacter == $'
		ifTrue: [ ^ self recordAndReportMatch: #(95) ].
	currentCharacter == $<
		ifTrue: [ self recordMatch: #(8).
			self step.
			currentCharacter == $'
				ifTrue: [ ^ self recordAndReportMatch: #(95) ] ].
	currentCharacter == $\
		ifTrue: [ ^ self scan3 ].
	^ self scan2
]

{ #category : #generated }
WollokScanner >> scanForTokenX13 [
	self recordMatch: #(14).
	self step.
	currentCharacter == $+
		ifTrue: [ ^ self recordAndReportMatch: #(15) ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(16) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX14 [
	self recordMatch: #(11).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self recordAndReportMatch: #(12) ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(13) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX15 [
	self recordMatch: #(1).
	self step.
	currentCharacter == $=
		ifTrue: [ self recordMatch: #(2).
			self step.
			currentCharacter == $=
				ifTrue: [ ^ self recordAndReportMatch: #(3) ] ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX16 [
	[ self recordMatch: #(92).
	self step.
	currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX17 [
	self step.
	currentCharacter == $.
		ifTrue: [ ^ self recordAndReportMatch: #(48) ].
	currentCharacter == $:
		ifTrue: [ ^ self recordAndReportMatch: #(49) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX18 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(30) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX19 [
	self recordMatch: #(5).
	self step.
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(6) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX1X1 [
	self recordMatch: #(93).
	self step.
	currentCharacter == $x
		ifTrue: [ self recordMatch: #(93).
			self step.
			currentCharacter == $e
				ifTrue: [ self recordMatch: #(93).
					self step.
					currentCharacter == $d
						ifTrue: [ self recordMatch: #(93).
							self step.
							currentCharacter == Character space
								ifTrue: [ (self scanForString: 'with')
										ifTrue: [ ^ self recordAndReportMatch: #(65) ].
									^ self reportLastMatch ].
							((currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ])
								ifTrue: [ [ self recordMatch: #(93).
									self step.
									(currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					((currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_
										or: [ (currentCharacter between: $a and: $c)
												or: [ currentCharacter between: $e and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(93).
							self step.
							(currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			((currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_
								or: [ (currentCharacter between: $a and: $d)
										or: [ currentCharacter between: $f and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(93).
					self step.
					(currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	((currentCharacter between: $0 and: $9)
		or: [ (currentCharacter between: $A and: $Z)
				or: [ currentCharacter == $_
						or: [ (currentCharacter between: $a and: $w)
								or: [ currentCharacter between: $y and: $z ] ] ] ])
		ifTrue: [ [ self recordMatch: #(93).
			self step.
			(currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX2 [
	self recordMatch: #(93).
	self step.
	currentCharacter == $h
		ifTrue: [ self recordMatch: #(93).
			self step.
			currentCharacter == $e
				ifTrue: [ self recordMatch: #(93).
					self step.
					currentCharacter == $n
						ifTrue: [ self recordMatch: #(93).
							self step.
							currentCharacter == Character space
								ifTrue: [ (self scanForString: 'always')
										ifTrue: [ ^ self recordAndReportMatch: #(82) ].
									^ self reportLastMatch ].
							((currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ])
								ifTrue: [ [ self recordMatch: #(93).
									self step.
									(currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					((currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_
										or: [ (currentCharacter between: $a and: $m)
												or: [ currentCharacter between: $o and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(93).
							self step.
							(currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			((currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_
								or: [ (currentCharacter between: $a and: $d)
										or: [ currentCharacter between: $f and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(93).
					self step.
					(currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	((currentCharacter between: $0 and: $9)
		or: [ (currentCharacter between: $A and: $Z)
				or: [ currentCharacter == $_
						or: [ (currentCharacter between: $a and: $g)
								or: [ currentCharacter between: $i and: $z ] ] ] ])
		ifTrue: [ [ self recordMatch: #(93).
			self step.
			(currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX20 [
	self step.
	currentCharacter == $|
		ifTrue: [ ^ self recordAndReportMatch: #(89) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX21 [
	self step.
	currentCharacter == $&
		ifTrue: [ ^ self recordAndReportMatch: #(7) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX22 [
	self step.
	currentCharacter == ${
		ifTrue: [ ^ self recordAndReportMatch: #(4) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX23 [
	currentCharacter == $t
		ifTrue:
			[ ^ self scanForTokenX2 ].
	currentCharacter == ${
		ifTrue: [ ^ self recordAndReportMatch: #(88) ].
	currentCharacter == $|
		ifTrue:
			[ ^ self scanForTokenX20 ].
	currentCharacter == $}
		ifTrue: [ ^ self recordAndReportMatch: #(90) ].
	currentCharacter isDigit
		ifTrue: [ ^ self scan8 ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue:
			[ ^ self scanForTokenX16 ].
	((currentCharacter between: $A and: $Z)
		or: [ currentCharacter == $_
				or: [ (currentCharacter between: $a and: $l)
						or: [ (currentCharacter between: $n and: $s)
								or: [ currentCharacter between: $u and: $z ] ] ] ])
		ifTrue:
			[ self scanForTokenX8 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX24 [
	currentCharacter == $/
		ifTrue:
			[ ^ self scanForTokenX4 ].
	currentCharacter == $0
		ifTrue:
			[ ^ self scanForTokenX3 ].
	currentCharacter == $:
		ifTrue:
			[ ^ self scanForTokenX18 ].
	currentCharacter == $;
		ifTrue: [ ^ self recordAndReportMatch: #(31) ].
	currentCharacter == $<
		ifTrue:
			[ ^ self scanForTokenX7 ].
	currentCharacter == $=
		ifTrue:
			[ ^ self scanForTokenX11 ].
	currentCharacter == $>
		ifTrue:
			[ ^ self scanForTokenX6 ].
	currentCharacter == $?
		ifTrue:
			[ ^ self scanForTokenX17 ].
	currentCharacter == $[
		ifTrue: [ ^ self recordAndReportMatch: #(50) ].
	currentCharacter == $]
		ifTrue: [ ^ self recordAndReportMatch: #(51) ].
	currentCharacter == $^
		ifTrue:
			[ ^ self scanForTokenX5 ].
	currentCharacter == $m
		ifTrue:
			[ ^ self scanForTokenX1 ].
	^ self scanForTokenX23
]

{ #category : #generated }
WollokScanner >> scanForTokenX25 [
	currentCharacter == $"
		ifTrue: [ ^ self scan1 ].
	currentCharacter == $#
		ifTrue:
			[ ^ self scanForTokenX22 ].
	currentCharacter == $%
		ifTrue:
			[ ^ self scanForTokenX19 ].
	currentCharacter == $&
		ifTrue:
			[ ^ self scanForTokenX21 ].
	currentCharacter == $'
		ifTrue:
			[ ^ self scanForTokenX12 ].
	currentCharacter == $(
		ifTrue: [ ^ self recordAndReportMatch: #(9) ].
	currentCharacter == $)
		ifTrue: [ ^ self recordAndReportMatch: #(10) ].
	currentCharacter == $*
		ifTrue:
			[ ^ self scanForTokenX14 ].
	currentCharacter == $+
		ifTrue:
			[ ^ self scanForTokenX13 ].
	currentCharacter == $,
		ifTrue: [ ^ self recordAndReportMatch: #(17) ].
	currentCharacter == $-
		ifTrue:
			[ ^ self scanForTokenX10 ].
	currentCharacter == $.
		ifTrue:
			[ ^ self scanForTokenX9 ].
	^ self scanForTokenX24
]

{ #category : #generated }
WollokScanner >> scanForTokenX3 [
	self recordMatch: #(94).
	self step.
	currentCharacter == $.
		ifTrue: [ ^ self scan5 ].
	('Bb' includes: currentCharacter)
		ifTrue: [ ^ self scan9 ].
	('Ee' includes: currentCharacter)
		ifTrue: [ ^ self scan11 ].
	('Xx' includes: currentCharacter)
		ifTrue: [ self step.
			(currentCharacter isDigit
				or: [ (currentCharacter between: $A and: $F)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $f ] ] ])
				ifTrue: [ [ self recordMatch: #(94).
					self step.
					currentCharacter == $#
						ifTrue: [ self step.
							('Bb' includes: currentCharacter)
								ifTrue: [ self step.
									('Ii' includes: currentCharacter)
										ifTrue: [ ^ self recordAndReportMatch: #(94) ].
									^ self reportLastMatch ].
							('Ll' includes: currentCharacter)
								ifTrue: [ ^ self recordAndReportMatch: #(94) ].
							^ self reportLastMatch ].
					currentCharacter isDigit
						or: [ (currentCharacter between: $A and: $F)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $f ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(currentCharacter isDigit or: [ currentCharacter == $_ ])
		ifTrue: [ ^ self scan8 ].
	('DFLdfl' includes: currentCharacter)
		ifTrue: [ ^ self scan10 ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX4 [
	self recordMatch: #(27).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan4 ].
	currentCharacter == $/
		ifTrue: [ [ self recordMatch: #(91).
			self step.
			currentCharacter <= Character tab
				or: [ (currentCharacter between: Character pageUp and: Character newPage)
						or: [ currentCharacter >= (Character value: 14) ] ] ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(28) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX5 [
	self step.
	((currentCharacter between: $A and: $Z)
		or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ])
		ifTrue: [ [ self recordMatch: #(93).
			self step.
			(currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX6 [
	self recordMatch: #(42).
	self step.
	currentCharacter == $.
		ifTrue: [ self step.
			currentCharacter == $.
				ifTrue: [ ^ self recordAndReportMatch: #(43) ].
			^ self reportLastMatch ].
	currentCharacter == $=
		ifTrue: [ self recordMatch: #(44).
			self step.
			currentCharacter == $>
				ifTrue: [ self step.
					currentCharacter == $>
						ifTrue: [ ^ self recordAndReportMatch: #(45) ] ].
			^ self reportLastMatch ].
	currentCharacter == $>
		ifTrue: [ self step.
			currentCharacter == $=
				ifTrue: [ ^ self recordAndReportMatch: #(46) ].
			currentCharacter == $>
				ifTrue: [ self step.
					currentCharacter == $=
						ifTrue: [ ^ self recordAndReportMatch: #(47) ] ] ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX7 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $<
		ifTrue: [ self step.
			currentCharacter == $<
				ifTrue: [ ^ self recordAndReportMatch: #(33) ].
			currentCharacter == $=
				ifTrue: [ ^ self recordAndReportMatch: #(34) ].
			^ self reportLastMatch ].
	currentCharacter == $=
		ifTrue: [ self recordMatch: #(35).
			self step.
			currentCharacter == $>
				ifTrue: [ ^ self recordAndReportMatch: #(36) ].
			^ self reportLastMatch ].
	currentCharacter == $>
		ifTrue: [ ^ self recordAndReportMatch: #(37) ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> scanForTokenX8 [
	[ self recordMatch: #(93).
	self step.
	(currentCharacter between: $0 and: $9)
		or: [ (currentCharacter between: $A and: $Z)
				or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
		whileTrue
]

{ #category : #generated }
WollokScanner >> scanForTokenX9 [
	self recordMatch: #(22).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self recordAndReportMatch: #(23) ].
	currentCharacter == $.
		ifTrue: [ self recordMatch: #(24).
			self step.
			currentCharacter == $.
				ifTrue: [ ^ self recordAndReportMatch: #(25) ].
			currentCharacter == $<
				ifTrue: [ ^ self recordAndReportMatch: #(26) ] ].
	^ self reportLastMatch
]

{ #category : #generated }
WollokScanner >> tokenActions [
	^ #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #comment #whitespace)
]
