Class {
	#name : #WollokParser,
	#superclass : #SmaCCParser,
	#category : #'Wollok-Parser'
}

{ #category : #'generated-accessing' }
WollokParser class >> cacheId [
	^'2020-12-27T23:44:20.396115+01:00'
]

{ #category : #generated }
WollokParser class >> definitionComment [
"%root AbstractNode;
%prefix Wollok;
%suffix Node;
%annotate_tokens;

# Root node, the file

File:
	Import 'import'*
	LibraryElement 'element' * 
	(Program 'main' | (Test 'test'  | Suite 'suite')+ )? {{}} 
;

#Imports
Import
	: ""import"" QualifiedNameWithWildcard 'importedNamespace' {{}};
	
QualifiedName:  
		<ID> 'identifier' {{}} 
	|  	QualifiedName "".""  <ID> 'identifier'{{}}
	;

QualifiedNameWithWildcard
	:  QualifiedName 'qualifiedName' ("".*"" 'hasAsterisk')? {{}};

LibraryElement
	: Package 
	| Class 
	| NamedObject 
	| Mixin 
	| VariableDeclaration
	;

Program:
		""program"" <ID> 'name' ""{""
			(ExpressionOrVarDeclaration 'element' "";""?)*
		""}"" {{}}
	;

Test:
		(""only"" 'only')? ""test"" StringLiteral 'name' ""{""
			(ExpressionOrVarDeclaration 'element' "";""?)*		
		""}"" {{}}
	;

Suite:
	""describe"" StringLiteral 'name' 
		""{""
			(VariableDeclaration 'member' "";""?)*
			(Fixture 'fixture')?
			(MethodDeclaration 'member' "";""?)*
			(Test 'test')*
		""}"" {{}}
	;

Fixture:
		""fixture"" ""{""
			(Expression 'element' "";""?)*
		""}""	{{}}
	;


Package
	:  ""package"" QualifiedName 'name' ""{""
		PackageElement  'element' *
	""}"" {{}}
	;

PackageElement
	: Class
	| NamedObject
	;

Class:
	""class"" <ID> 'name'
		(""inherits"" QualifiedName 'superclass')? 
		(""mixed with"" QualifiedName 'mixin' ((""and""|"","")  QualifiedName 'mixin')*)? 
	""{""
		(VariableDeclaration 'variable' "";""?)*
		(Constructor 'constructor')*
		(MethodDeclaration 'member' "";""?)*
	""}"" {{}}
	;

Mixin:
	""mixin"" <ID> 'name' ""{""
		(VariableDeclaration 'member' "";""?)*
		(MethodDeclaration 'member' "";""?)*
	""}"" {{}}
;

MethodDeclaration:
		(""override"" 'override')? ""method""
			MethodName 'name' ""("" (Parameter  'parameter' ("","" Parameter 'parameter')* )?"")"" 
			(""native"" 'native')? 	
			(BlockExpression 'expression' | (""="" 'expressionReturns' ExpressionWithoutAssignement 'expression'))? {{}}
	;

MethodName:
		<ID> | ""+"" | ""-"" | ""*"" | ""/"" | ""%"" | ""=="" | ""!="" | ""==="" | ""!=="" | OpOther | "">"" | ""<"" | "">="" | ""<="" | ""and"" | ""&&"" | ""or"" | ""||"" | ""**""
	;

Constructor:
		""constructor"" ""("" (Parameter 'parameter' ("","" Parameter 'parameter')*)? "")""
			(""="" DelegatingConstructorCall 'delegatingConstructorCall')?
			(BlockExpression 'expression')? {{}}
	;

DelegatingConstructorCall:
		SelfDelegatingConstructorCall 
	|	SuperDelegatingConstructorCall
	;

SelfDelegatingConstructorCall:
		""self"" ""("" (PositionalArgumentsList 'argumentList')?"")"" {{}}
	;

SuperDelegatingConstructorCall:
		""super"" ""("" (PositionalArgumentsList 'argumentList')?"")"" {{}}
	;

BlockExpression: 
		""{""
			(ExpressionOrVarDeclaration 'expression' "";""?)*
		""}"" {{}}
	;

NamedObject:
	""object"" <ID> 'name' 
		(""inherits"" QualifiedName 'superclass' 
			(""("" ArgumentList 'parentParameters' "")"")?
		)?
		(""mixed with"" QualifiedName 'mixin' ((""and""|"","")  QualifiedName 'mixin')*)? 
	""{""
		(VariableDeclaration 'variable' "";""?)*
		(MethodDeclaration 'member' "";""?)*
	""}"" {{}}
	;

ArgumentList:  
		NamedArgumentsList 
	| 	PositionalArgumentsList
	;

NamedArgumentsList:
		Initializer 'value' ("","" Initializer 'value')* {{}}
	;

PositionalArgumentsList:
		 Expression 'value' ("",""  Expression 'value')* {{}}
	;
	
Initializer:
		Variable 'name' "":="" Expression 'value' {{}}
	;

VariableDeclaration:
		(""var"" 'writable' |""const"") (""property"" 'property')? Variable 'variable' (""="" Expression 'right')? {{}}
	;

# Expressions

%left ""||"" ""or"";
%left ""&&"" ""and"";
%left ""=="" ""!="" ""==="" ""!=="";
%left "">=""  ""<=""  "">"" ""'<"";
%left ""=""  ""+=""  ""-=""  ""*=""  ""/=""  ""%="" ""<<="" "">>="" 	"">>>="";
%left ""+"" ""-"";
%left ""*"" ""/"" ""%"";
%left ""**"";
%right ""!"";

Expression:
		Assignment
	|	IfExpression
	|	Try
	|	ReturnExpression
	|	Throw
	;
	
ExpressionWithoutAssignement:
		OrExpression
	|	IfExpression
	|	Try
	|	ReturnExpression
	|	Throw
	;
		
Assignment:
		Variable 'variable'  ""="" 'operation' Expression 'value' {{}}
	|	Variable 'variable' OpMultiAssign 'operation' Expression 'value' {{}}
	|	OrExpression
	;

OpMultiAssign:
	""+="" | ""-="" | ""*="" | ""/="" | ""%="" | 
	""<<="" | 
	"">>="" |
	"">>>="";

OrExpression:
		AndExpression
	|	OrExpression 'leftOperand' ""||"" 'operation' AndExpression 'rightOperand' {{BinaryOperation}}
	|	OrExpression 'leftOperand' ""or"" 'operation' AndExpression 'rightOperand' {{BinaryOperation}}
	;

AndExpression:
		EqualityExpression
	|	AndExpression 'leftOperand' ""&&"" 'operation' EqualityExpression 'rightOperand' {{BinaryOperation}}
	|	AndExpression 'leftOperand' ""and"" 'operation' EqualityExpression 'rightOperand' {{BinaryOperation}}
	;
EqualityExpression:
		RelationalExpression
	|	EqualityExpression 'leftOperand' ""=="" 'operation' RelationalExpression 'rightOperand' {{BinaryOperation}}
	|	EqualityExpression 'leftOperand' ""!="" 'operation' RelationalExpression 'rightOperand' {{BinaryOperation}}
	|	EqualityExpression 'leftOperand' ""==="" 'operation' RelationalExpression 'rightOperand' {{BinaryOperation}}
	|	EqualityExpression 'leftOperand' ""!=="" 'operation' RelationalExpression 'rightOperand' {{BinaryOperation}}
	;

RelationalExpression:
		OtherOperatorExpression
	|	RelationalExpression 'leftOperand' "">="" 'operation' OtherOperatorExpression 'rightOperand' {{BinaryOperation}}
	|	RelationalExpression 'leftOperand' ""<="" 'operation' OtherOperatorExpression 'rightOperand' {{BinaryOperation}}
	|	RelationalExpression 'leftOperand' "">"" 'operation' OtherOperatorExpression 'rightOperand' {{BinaryOperation}}
	|	RelationalExpression 'leftOperand' ""<"" 'operation' OtherOperatorExpression 'rightOperand' {{BinaryOperation}}
	;
	
OtherOperatorExpression:
		AdditiveExpression
	|	OtherOperatorExpression 'leftOperand' OpOther	 'operation' AdditiveExpression 'rightOperand' {{BinaryOperation}}
	;

OpOther:
	  ""..<""
	| "">..""
	| ""..""
	| ""->""
	| "">=>>"" 
	| ""<<<""
	| ""<=>""
	| ""<>""
	| ""?:"";

AdditiveExpression:
		MultiplicativeExpression
	|	AdditiveExpression 'leftOperand' ""+""  'operation' MultiplicativeExpression 'rightOperand' {{BinaryOperation}}
	|	AdditiveExpression 'leftOperand' ""-""  'operation' MultiplicativeExpression 'rightOperand' {{BinaryOperation}}
	;

MultiplicativeExpression:
		ExponentiativeExpression
	|	MultiplicativeExpression 'leftOperand' ""*""  'operation' ExponentiativeExpression 'rightOperand' {{BinaryOperation}}
	|	MultiplicativeExpression 'leftOperand' ""/""  'operation' ExponentiativeExpression 'rightOperand' {{BinaryOperation}}
	|	MultiplicativeExpression 'leftOperand' ""%""  'operation' ExponentiativeExpression 'rightOperand' {{BinaryOperation}}
	;

ExponentiativeExpression:
		UnaryOperation
	|	ExponentiativeExpression 'leftOperand' ""**""  'operation' UnaryOperation 'rightOperand' {{BinaryOperation}}
	;

UnaryOperation:
		PostfixOperation
	|	 ""not""  'operation' UnaryOperation 'rightOperand' {{UnaryOperation}}
	|	 ""!""  'operation' UnaryOperation 'rightOperand' {{UnaryOperation}}
	|	 ""-""  'operation' UnaryOperation 'rightOperand' {{UnaryOperation}}
	|	 ""+""  'operation' UnaryOperation 'rightOperand' {{UnaryOperation}}
	;

PostfixOperation:
		MemberFeatureCall
	|	MemberFeatureCall 'operand' ""++"" 'operation' {{PostfixOperation}}
	|	MemberFeatureCall 'operand' ""--"" 'operation' {{PostfixOperation}}
	;

MemberFeatureCall:
		PrimaryExpression
	|	MemberFeatureCall 'receiver' ("".""| ""?."" 'nullSafe') <ID> 'feature' ""("" "")"" {{MemberFeatureCall}}
	|	MemberFeatureCall 'receiver' ("".""| ""?."" 'nullSafe') <ID> 'feature' ""("" Expression 'argument' ("","" Expression 'argument')* "")"" {{MemberFeatureCall}}
	|	MemberFeatureCall 'receiver' ("".""| ""?."" 'nullSafe') <ID> 'feature' Closure 'argument' {{MemberFeatureCall}}
	;

PrimaryExpression:
		Variable
	|	Literal
	|	ConstructorCall
	| 	""("" Expression 'expression' "")""	{{ParenthesizedExpression}}
	| 	SuperInvocation
	;

%left ""catch"";
%left ""then always"";

Try:
		""try""
			Expression 'expression'
		(Catch 'catchBlock')*
		(""then always"" Expression 'alwaysExpression')? {{}}
	;

Catch:
		""catch"" Variable 'exceptionVarName' ("":"" QualifiedName 'exceptionType')?
			Expression 'expression' {{}}
	;

ReturnExpression:
		""return"" Expression	'expression' {{}}
	;

Throw:
		""throw"" Expression 'exception' {{}}
	;


%left ""else"";

IfExpression:
		""if"" ""("" Expression 'condition' "")""  Expression 'then'  (""else"" Expression 'else')? {{}}
	;
	

ConstructorCall:
		""new"" QualifiedName 'classRef' ""("" (ArgumentList 'argumentList')? "")"" (""with"" <ID> 'mixin')+ {{}}
	|	""new"" QualifiedName 'classRef' ""("" (ArgumentList 'argumentList')? "")"" {{}}
	;

SuperInvocation: 
		""super""
		""("" 
			(Expression 'argument' ("","" Expression 'argument')*)? 
		"")""	{{}}
	;

#
# Literals
#

Literal:
		Closure
	|	BooleanLiteral
	|	NumberLiteral
	|	NullLiteral
	|	StringLiteral
	|	ObjectLiteral
	|	Self
	|	CollectionLiteral		
	;

ObjectLiteral:
		""object""
			(""inherits"" QualifiedName 'superclass' (""("" ArgumentList 'superclassParameters' "")"")?)?
			(""mixed with"" QualifiedName 'mixin' ((""and""|"","")  QualifiedName 'mixin')*)?
		""{""
			(VariableDeclaration 'member' "";""?)*
			(MethodDeclaration 'member' "";""?)*
		""}"" {{}}
	;

BooleanLiteral:
		""false"" 'value' {{}}
	|	""true"" 'value' {{}}
	;

NullLiteral:
		""null"" {{}}
	;

StringLiteral:
	<STRING_LITERAL> 'value' {{}};

NumberLiteral:
	<NUMBER_LITERAL> 'value' {{}};

Self :
	""self"" {{}}
	;

CollectionLiteral: ListLiteral | SetLiteral;

ListLiteral:
		""["" ""]"" {{}}
	|	""["" Expression 'element' ("","" Expression 'element')* ""]"" {{}}
	;

SetLiteral:
		""#{"" ""}"" {{}}
	|  	""#{"" Expression 'element' ("","" Expression'element'  )* ""}"" {{}}
	;

# CLOSURES

Closure:
		""{""  Parameter 'parameter' ("","" Parameter 'parameter')*	 ""=>""  BlockInClosure  'expression' ""}"" {{Closure}}
	|	""{""  ""=>""  BlockInClosure  'expression' ""}"" {{Closure}}
	|	""{""  BlockInClosure  'expression' ""}"" {{Closure}}
	;

BlockInClosure: 
		{{BlockExpression}}
	|	ExpressionOrVarDeclaration 'expression' "";""? (ExpressionOrVarDeclaration 'expression' "";""?)* 	{{BlockExpression}}
	;

# Methods 

Parameter:
		<ID> 'parameter' (""..."" 'isVarArg')? {{Parameter}}
	;
	
ExpressionOrVarDeclaration: VariableDeclaration | Expression;
				
Variable:
	<ID> 'name' {{}} 
;


# Tokens
<comment>: 
		\/\/ [^\r\n]* 
	|	 /\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/
 	;
<newline> : ( \r | \n | \r\n | \x2028 ) <whitespace> ? ;	
<whitespace> : \s+;

<ID>  :  \^?  [a-zA-Z_]  (\w)*;

<NUMBER_LITERAL>:
		<HEX>  
	| 	(<INT> | <DECIMAL>) (\. (<INT> | <DECIMAL>))?
	;

<HEX>:
	0(x|X) ([0-9a-fA-F]|_)+ (\# ((b|B)(i|I) | (l|L)))?
	;
	
<INT>:
	[0-9] ([0-9]|_)*; 

<DECIMAL>:
	<INT> ((e|E) (+|-)? <INT>)?  ((b|B)(i|I|d|D) | (l|L|d|D|f|F))?;


<ESCAPE_SEQUENCE>
	: \\ ([btnfr\""\'\\] | ([0-3] [0-7]{0,2} | [4-7][0-7]?) | (u [0-9a-fA-F]{4,4}))	
	;

<STRING_LITERAL>:
		 \"" ([^\\\""] | <ESCAPE_SEQUENCE> )* \""	
	|	 \' ([^\\\'] | <ESCAPE_SEQUENCE> )* \'	
	;"
]

{ #category : #generated }
WollokParser class >> reduceTable [
^#(
	#(98 0 #reduceActionForImport__import__1: 103425 false ) 
	#(99 0 #reduceActionForImport__import__1: 121857 false ) 
	#(97 2 #reduceActionForFile1: 96257 false ) 
	#(98 2 #reduceActionForImport__import__2: 103426 false ) 
	#(103 1 #reduceActionForQualifiedName1: 299009 false ) 
	#(104 1 #reduceActionForQualifiedNameWithWildcard1: 394241 false ) 
	#(102 2 #reduceActionForImport1: 224257 false ) 
	#(101 1 #reduceActionFor_Test__test_____Suite__suite___1: 169985 false ) 
	#(97 3 #reduceActionForFile3: 96259 false ) 
	#(99 2 #reduceActionForImport__import__2: 121858 false ) 
	#(97 3 #reduceActionForFile2: 96258 false ) 
	#(100 1 #reduceActionFor_Test__test_____Suite__suite__1: 169985 false ) 
	#(100 1 #reduceActionFor_Test__test_____Suite__suite__2: 169986 false ) 
	#(105 1 #liftFirstValue: 485377 false ) 
	#(105 1 #liftFirstValue: 485378 false ) 
	#(105 1 #liftFirstValue: 485380 false ) 
	#(105 1 #liftFirstValue: 485379 false ) 
	#(105 1 #liftFirstValue: 485381 false ) 
	#(104 2 #reduceActionForQualifiedNameWithWildcard2: 394242 false ) 
	#(200 1 #reduceActionForVariable1: 10132481 false ) 
	#(151 2 #reduceActionForVariableDeclaration5: 3272709 false ) 
	#(186 1 #reduceActionForStringLiteral1: 9191425 false ) 
	#(151 2 #reduceActionForVariableDeclaration1: 3272705 false ) 
	#(101 2 #reduceActionFor_Test__test_____Suite__suite___2: 169986 false ) 
	#(103 3 #reduceActionForQualifiedName2: 299010 false ) 
	#(127 0 #reduceActionFor_VariableDeclaration__variable________1: 1364993 false ) 
	#(151 3 #reduceActionForVariableDeclaration7: 3272711 false ) 
	#(112 0 #reduceActionFor_VariableDeclaration__variable________1: 856065 false ) 
	#(121 0 #reduceActionForImport__import__1: 1116161 false ) 
	#(108 0 #reduceActionFor_VariableDeclaration__variable________1: 618497 false ) 
	#(151 3 #reduceActionForVariableDeclaration3: 3272707 false ) 
	#(125 0 #reduceActionFor___and________QualifiedName__mixin___1: 1315841 false ) 
	#(129 0 #reduceActionForImport__import__1: 1406977 false ) 
	#(184 1 #reduceActionForBooleanLiteral1: 9092097 false ) 
	#(185 1 #reduceActionForNullLiteral1: 9159681 false ) 
	#(188 1 #reduceActionForSelf1: 9289729 false ) 
	#(184 1 #reduceActionForBooleanLiteral1: 9092098 false ) 
	#(197 0 #reduceActionForBlockInClosure1: 9817089 false ) 
	#(187 1 #reduceActionForNumberLiteral1: 9240577 false ) 
	#(151 4 #reduceActionForVariableDeclaration6: 3272710 false ) 
	#(152 1 #liftFirstValue: 3639297 false ) 
	#(154 1 #liftFirstValue: 3828739 false ) 
	#(156 1 #liftFirstValue: 4083713 false ) 
	#(157 1 #liftFirstValue: 4315137 false ) 
	#(158 1 #liftFirstValue: 4564993 false ) 
	#(159 1 #liftFirstValue: 5061633 false ) 
	#(160 1 #liftFirstValue: 5580801 false ) 
	#(162 1 #liftFirstValue: 5842945 false ) 
	#(163 1 #liftFirstValue: 6126593 false ) 
	#(164 1 #liftFirstValue: 6550529 false ) 
	#(165 1 #liftFirstValue: 6711297 false ) 
	#(166 1 #liftFirstValue: 7040001 false ) 
	#(167 1 #liftFirstValue: 7224321 false ) 
	#(152 1 #liftFirstValue: 3639299 false ) 
	#(152 1 #liftFirstValue: 3639300 false ) 
	#(152 1 #liftFirstValue: 3639301 false ) 
	#(152 1 #liftFirstValue: 3639298 false ) 
	#(170 1 #liftFirstValue: 7639043 false ) 
	#(170 1 #liftFirstValue: 7639045 false ) 
	#(170 1 #liftFirstValue: 7639042 false ) 
	#(182 1 #liftFirstValue: 8648710 false ) 
	#(182 1 #liftFirstValue: 8648706 false ) 
	#(182 1 #liftFirstValue: 8648708 false ) 
	#(182 1 #liftFirstValue: 8648709 false ) 
	#(182 1 #liftFirstValue: 8648707 false ) 
	#(182 1 #liftFirstValue: 8648711 false ) 
	#(182 1 #liftFirstValue: 8648712 false ) 
	#(189 1 #liftFirstValue: 9314305 false ) 
	#(189 1 #liftFirstValue: 9314306 false ) 
	#(182 1 #liftFirstValue: 8648705 false ) 
	#(170 1 #liftFirstValue: 7639041 false ) 
	#(114 0 #reduceActionFor_VariableDeclaration__variable________1: 921601 false ) 
	#(151 4 #reduceActionForVariableDeclaration2: 3272706 false ) 
	#(127 2 #reduceActionFor_Test__test_____Suite__suite___2: 1364994 false ) 
	#(126 1 #reduceActionFor_Test__test_____Suite__suite__1: 1364993 false ) 
	#(151 5 #reduceActionForVariableDeclaration8: 3272712 false ) 
	#(165 2 #reduceActionForUnaryOperation3: 6711299 false ) 
	#(193 2 #reduceActionForSetLiteral1: 9460737 false ) 
	#(195 0 #reduceActionFor_VariableDeclaration__variable________1: 9521153 false ) 
	#(165 2 #reduceActionForUnaryOperation3: 6711301 false ) 
	#(165 2 #reduceActionForUnaryOperation3: 6711300 false ) 
	#(190 2 #reduceActionForListLiteral1: 9361409 false ) 
	#(192 0 #reduceActionFor_VariableDeclaration__variable________1: 9418753 false ) 
	#(165 2 #reduceActionForUnaryOperation3: 6711298 false ) 
	#(175 2 #reduceActionForReturnExpression1: 8074241 false ) 
	#(176 2 #reduceActionForThrow1: 8137729 false ) 
	#(173 0 #reduceActionForImport__import__1: 7871489 false ) 
	#(198 1 #reduceActionForParameter1: 9993217 false ) 
	#(199 1 #liftFirstValue: 10063873 false ) 
	#(199 1 #liftFirstValue: 10063874 false ) 
	#(133 0 #reduceActionFor_VariableDeclaration__variable________1: 1719297 false ) 
	#(141 0 #reduceActionFor_VariableDeclaration__variable________1: 2592769 false ) 
	#(161 1 #liftFirstValue: 5750788 false ) 
	#(161 1 #liftFirstValue: 5750787 false ) 
	#(161 1 #liftFirstValue: 5750785 false ) 
	#(161 1 #liftFirstValue: 5750790 false ) 
	#(161 1 #liftFirstValue: 5750791 false ) 
	#(161 1 #liftFirstValue: 5750792 false ) 
	#(161 1 #liftFirstValue: 5750786 false ) 
	#(161 1 #liftFirstValue: 5750789 false ) 
	#(161 1 #liftFirstValue: 5750793 false ) 
	#(166 2 #reduceActionForPostfixOperation2: 7040002 false ) 
	#(166 2 #reduceActionForPostfixOperation2: 7040003 false ) 
	#(155 1 #liftFirstValue: 4000773 false ) 
	#(155 1 #liftFirstValue: 4000771 false ) 
	#(155 1 #liftFirstValue: 4000769 false ) 
	#(155 1 #liftFirstValue: 4000770 false ) 
	#(155 1 #liftFirstValue: 4000772 false ) 
	#(155 1 #liftFirstValue: 4000774 false ) 
	#(155 1 #liftFirstValue: 4000775 false ) 
	#(155 1 #liftFirstValue: 4000776 false ) 
	#(112 2 #reduceActionFor_Test__test_____Suite__suite___2: 856066 false ) 
	#(116 0 #reduceActionForImport__import__1: 960513 false ) 
	#(111 1 #reduceActionFor_Test__test_____Suite__suite__1: 856065 false ) 
	#(120 5 #reduceActionForPackage1: 1065985 false ) 
	#(121 2 #reduceActionForImport__import__2: 1116162 false ) 
	#(122 1 #liftFirstValue: 1159169 false ) 
	#(122 1 #liftFirstValue: 1159170 false ) 
	#(106 5 #reduceActionForProgram1: 577537 false ) 
	#(108 2 #reduceActionFor_Test__test_____Suite__suite___2: 618498 false ) 
	#(107 1 #reduceActionFor_Test__test_____Suite__suite__1: 618497 false ) 
	#(109 5 #reduceActionForTest1: 679937 false ) 
	#(151 5 #reduceActionForVariableDeclaration4: 3272708 false ) 
	#(125 2 #reduceActionFor___and________QualifiedName__mixin___2: 1315842 false ) 
	#(129 2 #reduceActionForImport__import__2: 1406978 false ) 
	#(128 1 #liftFirstValue: 1406977 false ) 
	#(126 2 #reduceActionFor_VariableDeclaration__variable_______2: 1364994 false ) 
	#(170 3 #reduceActionForPrimaryExpression4: 7639044 false ) 
	#(181 3 #reduceActionForSuperInvocation1: 8521729 false ) 
	#(169 0 #reduceActionFor_VariableDeclaration__variable________1: 7464961 false ) 
	#(171 3 #reduceActionForTry1: 7828481 false ) 
	#(198 2 #reduceActionForParameter2: 9993218 false ) 
	#(196 3 #reduceActionForClosure3: 9576451 false ) 
	#(197 2 #reduceActionForBlockInClosure2: 9817090 false ) 
	#(156 3 #reduceActionForOrExpression3: 4083715 false ) 
	#(156 3 #reduceActionForOrExpression3: 4083714 false ) 
	#(157 3 #reduceActionForOrExpression3: 4315138 false ) 
	#(157 3 #reduceActionForOrExpression3: 4315139 false ) 
	#(158 3 #reduceActionForOrExpression3: 4564995 false ) 
	#(158 3 #reduceActionForOrExpression3: 4564997 false ) 
	#(158 3 #reduceActionForOrExpression3: 4564994 false ) 
	#(158 3 #reduceActionForOrExpression3: 4564996 false ) 
	#(159 3 #reduceActionForOrExpression3: 5061637 false ) 
	#(159 3 #reduceActionForOrExpression3: 5061635 false ) 
	#(159 3 #reduceActionForOrExpression3: 5061636 false ) 
	#(159 3 #reduceActionForOrExpression3: 5061634 false ) 
	#(160 3 #reduceActionForOrExpression3: 5580802 false ) 
	#(162 3 #reduceActionForOrExpression3: 5842946 false ) 
	#(162 3 #reduceActionForOrExpression3: 5842947 false ) 
	#(163 3 #reduceActionForOrExpression3: 6126596 false ) 
	#(163 3 #reduceActionForOrExpression3: 6126594 false ) 
	#(163 3 #reduceActionForOrExpression3: 6126595 false ) 
	#(164 3 #reduceActionForOrExpression3: 6550530 false ) 
	#(154 3 #reduceActionForAssignment1: 3828737 false ) 
	#(154 3 #reduceActionForAssignment1: 3828738 false ) 
	#(119 0 #reduceActionFor_VariableDeclaration__variable________1: 1019905 false ) 
	#(114 2 #reduceActionFor_Test__test_____Suite__suite___2: 921602 false ) 
	#(113 1 #reduceActionFor_Test__test_____Suite__suite__1: 921601 false ) 
	#(111 2 #reduceActionFor_VariableDeclaration__variable_______2: 856066 false ) 
	#(130 6 #reduceActionForMixin1: 1488897 false ) 
	#(143 1 #liftFirstValue: 2969601 false ) 
	#(143 1 #liftFirstValue: 2969602 false ) 
	#(146 0 #reduceActionFor_VariableDeclaration__variable________1: 3084289 false ) 
	#(149 0 #reduceActionFor_VariableDeclaration__variable________1: 3169281 false ) 
	#(142 6 #reduceActionForNamedObject1: 2657281 false ) 
	#(109 6 #reduceActionForTest2: 679938 false ) 
	#(107 2 #reduceActionFor_VariableDeclaration__variable_______2: 618498 false ) 
	#(124 2 #reduceActionFor___and________QualifiedName__mixin__2: 1315842 false ) 
	#(124 2 #reduceActionFor___and________QualifiedName__mixin__1: 1315841 false ) 
	#(123 7 #reduceActionForClass1: 1203201 false ) 
	#(193 4 #reduceActionForSetLiteral2: 9460738 false ) 
	#(195 2 #reduceActionFor_Test__test_____Suite__suite___2: 9521154 false ) 
	#(190 4 #reduceActionForListLiteral2: 9361410 false ) 
	#(192 2 #reduceActionFor_Test__test_____Suite__suite___2: 9418754 false ) 
	#(178 4 #reduceActionForConstructorCall3: 8317955 false ) 
	#(173 2 #reduceActionForImport__import__2: 7871490 false ) 
	#(172 1 #liftFirstValue: 7871489 false ) 
	#(196 4 #reduceActionForClosure2: 9576450 false ) 
	#(133 2 #reduceActionFor_Test__test_____Suite__suite___2: 1719298 false ) 
	#(197 3 #reduceActionForBlockInClosure3: 9817091 false ) 
	#(141 2 #reduceActionFor_Test__test_____Suite__suite___2: 2592770 false ) 
	#(140 1 #reduceActionFor_Test__test_____Suite__suite__1: 2592769 false ) 
	#(167 4 #reduceActionForMemberFeatureCall6: 7224326 false ) 
	#(167 4 #reduceActionForMemberFeatureCall7: 7224327 false ) 
	#(134 1 #liftFirstValue: 1899528 false ) 
	#(134 1 #liftFirstValue: 1899530 false ) 
	#(134 1 #liftFirstValue: 1899526 false ) 
	#(134 1 #liftFirstValue: 1899537 false ) 
	#(134 1 #liftFirstValue: 1899524 false ) 
	#(134 1 #liftFirstValue: 1899540 false ) 
	#(134 1 #liftFirstValue: 1899522 false ) 
	#(134 1 #liftFirstValue: 1899523 false ) 
	#(134 1 #liftFirstValue: 1899525 false ) 
	#(134 1 #liftFirstValue: 1899533 false ) 
	#(134 1 #liftFirstValue: 1899535 false ) 
	#(134 1 #liftFirstValue: 1899527 false ) 
	#(134 1 #liftFirstValue: 1899529 false ) 
	#(134 1 #liftFirstValue: 1899532 false ) 
	#(134 1 #liftFirstValue: 1899534 false ) 
	#(134 1 #liftFirstValue: 1899536 false ) 
	#(134 1 #liftFirstValue: 1899538 false ) 
	#(134 1 #liftFirstValue: 1899539 false ) 
	#(134 1 #liftFirstValue: 1899521 false ) 
	#(134 1 #liftFirstValue: 1899531 false ) 
	#(110 7 #reduceActionForSuite1: 804865 false ) 
	#(115 1 #liftFirstValue: 960513 false ) 
	#(116 2 #reduceActionForImport__import__2: 960514 false ) 
	#(113 2 #reduceActionFor_VariableDeclaration__variable_______2: 921602 false ) 
	#(144 2 #reduceActionForNamedArgumentsList1: 3041281 false ) 
	#(147 2 #reduceActionForPositionalArgumentsList1: 3121153 false ) 
	#(135 3 #reduceActionForConstructor1: 2058241 false ) 
	#(194 2 #reduceActionFor_VariableDeclaration__variable_______2: 9521153 false ) 
	#(191 2 #reduceActionFor_VariableDeclaration__variable_______2: 9418753 false ) 
	#(177 5 #reduceActionForIfExpression1: 8204289 false ) 
	#(180 1 #reduceActionFor_Test__test_____Suite__suite___1: 8409089 false ) 
	#(178 5 #reduceActionForConstructorCall1: 8317953 false ) 
	#(178 5 #reduceActionForConstructorCall4: 8317956 false ) 
	#(183 5 #reduceActionForObjectLiteral1: 8790017 false ) 
	#(181 5 #reduceActionForSuperInvocation2: 8521730 false ) 
	#(169 2 #reduceActionFor_Test__test_____Suite__suite___2: 7464962 false ) 
	#(171 5 #reduceActionForTry2: 7828482 false ) 
	#(132 2 #reduceActionFor_VariableDeclaration__variable_______2: 1719297 false ) 
	#(140 2 #reduceActionFor_VariableDeclaration__variable_______2: 2592770 false ) 
	#(167 5 #reduceActionForMemberFeatureCall2: 7224322 false ) 
	#(167 5 #reduceActionForMemberFeatureCall3: 7224323 false ) 
	#(117 4 #reduceActionForFixture1: 991233 false ) 
	#(119 2 #reduceActionFor_Test__test_____Suite__suite___2: 1019906 false ) 
	#(118 1 #reduceActionFor_Test__test_____Suite__suite__1: 1019905 false ) 
	#(110 8 #reduceActionForSuite2: 804866 false ) 
	#(146 2 #reduceActionFor_Test__test_____Suite__suite___2: 3084290 false ) 
	#(149 2 #reduceActionFor_Test__test_____Suite__suite___2: 3169282 false ) 
	#(150 3 #reduceActionForInitializer1: 3207169 false ) 
	#(142 8 #reduceActionForNamedObject3: 2657283 false ) 
	#(123 9 #reduceActionForClass3: 1203203 false ) 
	#(135 4 #reduceActionForConstructor2: 2058242 false ) 
	#(179 2 #reduceActionFor_VariableDeclaration__variable_______2: 8409089 false ) 
	#(180 2 #reduceActionFor_Test__test_____Suite__suite___2: 8409090 false ) 
	#(178 6 #reduceActionForConstructorCall2: 8317954 false ) 
	#(168 2 #reduceActionFor_VariableDeclaration__variable_______2: 7464961 false ) 
	#(174 3 #reduceActionForCatch1: 7953409 false ) 
	#(196 6 #reduceActionForClosure1: 9576449 false ) 
	#(118 2 #reduceActionFor_VariableDeclaration__variable_______2: 1019906 false ) 
	#(131 4 #reduceActionForMethodDeclaration1: 1612801 false ) 
	#(145 2 #reduceActionFor_VariableDeclaration__variable_______2: 3084289 false ) 
	#(148 2 #reduceActionFor_VariableDeclaration__variable_______2: 3169281 false ) 
	#(142 9 #reduceActionForNamedObject2: 2657282 false ) 
	#(123 10 #reduceActionForClass2: 1203202 false ) 
	#(135 5 #reduceActionForConstructor3: 2058243 false ) 
	#(136 1 #liftFirstValue: 2262017 false ) 
	#(136 1 #liftFirstValue: 2262018 false ) 
	#(135 5 #reduceActionForConstructor5: 2058245 false ) 
	#(177 7 #reduceActionForIfExpression2: 8204290 false ) 
	#(183 7 #reduceActionForObjectLiteral3: 8790019 false ) 
	#(167 7 #reduceActionForMemberFeatureCall4: 7224324 false ) 
	#(167 7 #reduceActionForMemberFeatureCall5: 7224325 false ) 
	#(131 5 #reduceActionForMethodDeclaration4: 1612804 false ) 
	#(131 5 #reduceActionForMethodDeclaration2: 1612802 false ) 
	#(131 5 #reduceActionForMethodDeclaration13: 1612813 false ) 
	#(135 6 #reduceActionForConstructor4: 2058244 false ) 
	#(139 3 #reduceActionForBlockExpression1: 2565121 false ) 
	#(135 6 #reduceActionForConstructor6: 2058246 false ) 
	#(183 8 #reduceActionForObjectLiteral2: 8790018 false ) 
	#(174 5 #reduceActionForCatch2: 7953410 false ) 
	#(131 6 #reduceActionForMethodDeclaration3: 1612803 false ) 
	#(153 1 #liftFirstValue: 3723265 false ) 
	#(153 1 #liftFirstValue: 3723267 false ) 
	#(153 1 #liftFirstValue: 3723268 false ) 
	#(153 1 #liftFirstValue: 3723269 false ) 
	#(153 1 #liftFirstValue: 3723266 false ) 
	#(131 6 #reduceActionForMethodDeclaration5: 1612805 false ) 
	#(131 6 #reduceActionForMethodDeclaration7: 1612807 false ) 
	#(131 6 #reduceActionForMethodDeclaration16: 1612816 false ) 
	#(131 6 #reduceActionForMethodDeclaration14: 1612814 false ) 
	#(142 11 #reduceActionForNamedObject5: 2657285 false ) 
	#(142 11 #reduceActionForNamedObject4: 2657284 false ) 
	#(123 12 #reduceActionForClass4: 1203204 false ) 
	#(137 3 #reduceActionForSelfDelegatingConstructorCall1: 2362369 false ) 
	#(138 3 #reduceActionForSuperDelegatingConstructorCall1: 2462721 false ) 
	#(135 7 #reduceActionForConstructor7: 2058247 false ) 
	#(131 7 #reduceActionForMethodDeclaration6: 1612806 false ) 
	#(131 7 #reduceActionForMethodDeclaration10: 1612810 false ) 
	#(131 7 #reduceActionForMethodDeclaration8: 1612808 false ) 
	#(131 7 #reduceActionForMethodDeclaration15: 1612815 false ) 
	#(131 7 #reduceActionForMethodDeclaration17: 1612817 false ) 
	#(131 7 #reduceActionForMethodDeclaration19: 1612819 false ) 
	#(137 4 #reduceActionForSelfDelegatingConstructorCall2: 2362370 false ) 
	#(138 4 #reduceActionForSuperDelegatingConstructorCall2: 2462722 false ) 
	#(135 8 #reduceActionForConstructor8: 2058248 false ) 
	#(183 10 #reduceActionForObjectLiteral5: 8790021 false ) 
	#(183 10 #reduceActionForObjectLiteral4: 8790020 false ) 
	#(131 8 #reduceActionForMethodDeclaration9: 1612809 false ) 
	#(131 8 #reduceActionForMethodDeclaration11: 1612811 false ) 
	#(131 8 #reduceActionForMethodDeclaration18: 1612818 false ) 
	#(131 8 #reduceActionForMethodDeclaration22: 1612822 false ) 
	#(131 8 #reduceActionForMethodDeclaration20: 1612820 false ) 
	#(131 9 #reduceActionForMethodDeclaration12: 1612812 false ) 
	#(131 9 #reduceActionForMethodDeclaration21: 1612821 false ) 
	#(131 9 #reduceActionForMethodDeclaration23: 1612823 false ) 
	#(142 14 #reduceActionForNamedObject6: 2657286 false ) 
	#(131 10 #reduceActionForMethodDeclaration24: 1612824 false ) 
	#(183 13 #reduceActionForObjectLiteral6: 8790022 false )
	).
]

{ #category : #'generated-accessing' }
WollokParser class >> scannerClass [
	^WollokScanner
]

{ #category : #generated }
WollokParser class >> startingStateForFile [
	^ 1
]

{ #category : #generated }
WollokParser class >> symbolNames [
	^ #('"!"' '"!="' '"!=="' '"#{"' '"%"' '"%="' '"&&"' '"''<"' '"("' '")"' '"*"' '"**"' '"*="' '"+"' '"++"' '"+="' '","' '"-"' '"--"' '"-="' '"->"' '"."' '".*"' '".."' '"..."' '"..<"' '"/"' '"/="' '":"' '":="' '";"' '"<"' '"<<<"' '"<<="' '"<="' '"<=>"' '"<>"' '"="' '"=="' '"==="' '"=>"' '">"' '">.."' '">="' '">=>>"' '">>="' '">>>="' '"?."' '"?:"' '"["' '"]"' '"and"' '"catch"' '"class"' '"const"' '"constructor"' '"describe"' '"else"' '"false"' '"fixture"' '"if"' '"import"' '"inherits"' '"method"' '"mixed with"' '"mixin"' '"native"' '"new"' '"not"' '"null"' '"object"' '"only"' '"or"' '"override"' '"package"' '"program"' '"property"' '"return"' '"self"' '"super"' '"test"' '"then always"' '"throw"' '"true"' '"try"' '"var"' '"with"' '"{"' '"||"' '"}"' '<comment>' '<whitespace>' '<ID>' '<NUMBER_LITERAL>' '<STRING_LITERAL>' 'B e g i n' 'File' 'Import ''import''*' 'LibraryElement ''element'' *' '(Test ''test''  | Suite ''suite'')' '(Test ''test''  | Suite ''suite'')+' 'Import' 'QualifiedName' 'QualifiedNameWithWildcard' 'LibraryElement' 'Program' '(ExpressionOrVarDeclaration ''element'' ";"?)' '(ExpressionOrVarDeclaration ''element'' ";"?)*' 'Test' 'Suite' '(VariableDeclaration ''member'' ";"?)' '(VariableDeclaration ''member'' ";"?)*' '(MethodDeclaration ''member'' ";"?)' '(MethodDeclaration ''member'' ";"?)*' '(Test ''test'')' '(Test ''test'')*' 'Fixture' '(Expression ''element'' ";"?)' '(Expression ''element'' ";"?)*' 'Package' 'PackageElement  ''element'' *' 'PackageElement' 'Class' '(("and"|",")  QualifiedName ''mixin'')' '(("and"|",")  QualifiedName ''mixin'')*' '(VariableDeclaration ''variable'' ";"?)' '(VariableDeclaration ''variable'' ";"?)*' '(Constructor ''constructor'')' '(Constructor ''constructor'')*' 'Mixin' 'MethodDeclaration' '("," Parameter ''parameter'')' '("," Parameter ''parameter'')*' 'MethodName' 'Constructor' 'DelegatingConstructorCall' 'SelfDelegatingConstructorCall' 'SuperDelegatingConstructorCall' 'BlockExpression' '(ExpressionOrVarDeclaration ''expression'' ";"?)' '(ExpressionOrVarDeclaration ''expression'' ";"?)*' 'NamedObject' 'ArgumentList' 'NamedArgumentsList' '("," Initializer ''value'')' '("," Initializer ''value'')*' 'PositionalArgumentsList' '(","  Expression ''value'')' '(","  Expression ''value'')*' 'Initializer' 'VariableDeclaration' 'Expression' 'ExpressionWithoutAssignement' 'Assignment' 'OpMultiAssign' 'OrExpression' 'AndExpression' 'EqualityExpression' 'RelationalExpression' 'OtherOperatorExpression' 'OpOther' 'AdditiveExpression' 'MultiplicativeExpression' 'ExponentiativeExpression' 'UnaryOperation' 'PostfixOperation' 'MemberFeatureCall' '("," Expression ''argument'')' '("," Expression ''argument'')*' 'PrimaryExpression' 'Try' '(Catch ''catchBlock'')' '(Catch ''catchBlock'')*' 'Catch' 'ReturnExpression' 'Throw' 'IfExpression' 'ConstructorCall' '("with" <ID> ''mixin'')' '("with" <ID> ''mixin'')+' 'SuperInvocation' 'Literal' 'ObjectLiteral' 'BooleanLiteral' 'NullLiteral' 'StringLiteral' 'NumberLiteral' 'Self' 'CollectionLiteral' 'ListLiteral' '("," Expression ''element'')' '("," Expression ''element'')*' 'SetLiteral' '("," Expression''element''  )' '("," Expression''element''  )*' 'Closure' 'BlockInClosure' 'Parameter' 'ExpressionOrVarDeclaration' 'Variable' 'E O F' 'error')
]

{ #category : #generated }
WollokParser class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #WollokFileNode #WollokFileNode #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #WollokImportNode #WollokQualifiedNameNode #WollokQualifiedNameWithWildcardNode #WollokAbstractNodeNode #WollokProgramNode #OrderedCollection #OrderedCollection #WollokTestNode #WollokSuiteNode #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #WollokTestNode #OrderedCollection #WollokFixtureNode #OrderedCollection #OrderedCollection #WollokPackageNode #OrderedCollection #WollokAbstractNodeNode #WollokClassNode #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #WollokConstructorNode #OrderedCollection #WollokMixinNode #WollokMethodDeclarationNode #OrderedCollection #OrderedCollection #SmaCCToken #WollokConstructorNode #WollokAbstractNodeNode #WollokSelfDelegatingConstructorCallNode #WollokSuperDelegatingConstructorCallNode #WollokBlockExpressionNode #OrderedCollection #OrderedCollection #WollokNamedObjectNode #WollokAbstractNodeNode #WollokNamedArgumentsListNode #OrderedCollection #OrderedCollection #WollokPositionalArgumentsListNode #OrderedCollection #OrderedCollection #WollokInitializerNode #WollokVariableDeclarationNode #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #SmaCCToken #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #SmaCCToken #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #WollokAbstractNodeNode #OrderedCollection #OrderedCollection #WollokAbstractNodeNode #WollokTryNode #WollokCatchNode #OrderedCollection #WollokCatchNode #WollokReturnExpressionNode #WollokThrowNode #WollokIfExpressionNode #WollokConstructorCallNode #OrderedCollection #OrderedCollection #WollokSuperInvocationNode #WollokAbstractNodeNode #WollokObjectLiteralNode #WollokBooleanLiteralNode #WollokNullLiteralNode #WollokStringLiteralNode #WollokNumberLiteralNode #WollokSelfNode #WollokAbstractNodeNode #WollokListLiteralNode #OrderedCollection #OrderedCollection #WollokSetLiteralNode #OrderedCollection #OrderedCollection #WollokClosureNode #WollokBlockExpressionNode #WollokParameterNode #WollokAbstractNodeNode #WollokVariableNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
WollokParser class >> transitionTable [
^#(
#[1 0 6 0 54 0 6 0 55 0 6 0 57 0 6 0 62 0 6 0 66 0 6 0 71 0 6 0 72 0 6 0 75 0 6 0 76 0 6 0 81 0 6 0 86 0 9 0 97 0 13 0 98 0 6 0 201] 
#[0 0 0 0 201] 
#[1 0 10 0 54 0 10 0 55 0 10 0 57 0 17 0 62 0 10 0 66 0 10 0 71 0 10 0 72 0 10 0 75 0 10 0 76 0 10 0 81 0 10 0 86 0 21 0 99 0 25 0 102 0 10 0 201] 
#[1 0 29 0 93 0 33 0 103 0 37 0 104] 
#[1 0 41 0 54 0 45 0 55 0 49 0 57 0 53 0 66 0 57 0 71 0 61 0 72 0 65 0 75 0 69 0 76 0 73 0 81 0 77 0 86 0 81 0 100 0 85 0 101 0 89 0 105 0 93 0 106 0 97 0 109 0 101 0 110 0 89 0 120 0 89 0 123 0 89 0 130 0 89 0 142 0 89 0 151 0 14 0 201] 
#[0 0 18 0 54 0 55 0 57 0 62 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 22 0 1 0 4 0 9 0 14 0 17 0 18 0 22 0 23 0 50 0 52 0 54 0 55 0 57 0 59 0 61 0 62 0 65 0 66 0 68 0 69 0 70 0 71 0 72 0 75 0 76 0 78 0 79 0 80 0 81 0 83 0 84 0 85 0 86 0 88 0 93 0 94 0 95 0 201] 
#[1 0 125 0 22 0 129 0 23 0 26 0 54 0 26 0 55 0 26 0 57 0 26 0 62 0 26 0 66 0 26 0 71 0 26 0 72 0 26 0 75 0 26 0 76 0 26 0 81 0 26 0 86 0 26 0 201] 
#[0 0 30 0 54 0 55 0 57 0 62 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 133 0 93] 
#[1 0 137 0 77 0 141 0 93 0 145 0 200] 
#[1 0 149 0 95 0 153 0 186] 
#[0 0 157 0 93] 
#[0 0 161 0 93] 
#[0 0 165 0 81] 
#[1 0 29 0 93 0 169 0 103] 
#[0 0 173 0 93] 
#[1 0 149 0 95 0 177 0 186] 
#[1 0 181 0 77 0 141 0 93 0 185 0 200] 
#[0 0 34 0 57 0 72 0 81 0 201] 
#[1 0 49 0 57 0 61 0 72 0 73 0 81 0 189 0 100 0 97 0 109 0 101 0 110 0 38 0 201] 
#[0 0 42 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 46 0 201] 
#[0 0 50 0 57 0 72 0 81 0 201] 
#[0 0 54 0 57 0 72 0 81 0 201] 
#[0 0 58 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 62 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 66 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 70 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 74 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 0 193 0 93] 
#[0 0 78 0 54 0 55 0 57 0 62 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[1 0 197 0 63 0 201 0 65 0 205 0 88] 
#[1 0 141 0 93 0 209 0 200] 
#[0 0 82 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 24 0 26 0 27 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 0 86 0 1 0 86 0 4 0 86 0 9 0 86 0 14 0 86 0 18 0 86 0 31 0 213 0 38 0 86 0 50 0 86 0 54 0 86 0 55 0 86 0 56 0 86 0 57 0 86 0 59 0 86 0 60 0 86 0 61 0 86 0 64 0 86 0 66 0 86 0 68 0 86 0 69 0 86 0 70 0 86 0 71 0 86 0 72 0 86 0 74 0 86 0 75 0 86 0 76 0 86 0 78 0 86 0 79 0 86 0 80 0 86 0 81 0 86 0 83 0 86 0 84 0 86 0 85 0 86 0 86 0 86 0 88 0 86 0 90 0 86 0 93 0 86 0 94 0 86 0 95 0 86 0 201] 
#[0 0 90 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 217 0 88] 
#[0 0 221 0 88] 
#[1 0 225 0 63 0 229 0 65 0 233 0 88] 
#[1 0 149 0 95 0 237 0 186] 
#[1 0 125 0 22 0 241 0 88] 
#[0 0 245 0 88] 
#[0 0 249 0 88] 
#[1 0 141 0 93 0 253 0 200] 
#[1 0 94 0 1 0 94 0 4 0 94 0 9 0 94 0 14 0 94 0 18 0 94 0 31 1 1 0 38 0 94 0 50 0 94 0 54 0 94 0 55 0 94 0 56 0 94 0 57 0 94 0 59 0 94 0 60 0 94 0 61 0 94 0 64 0 94 0 66 0 94 0 68 0 94 0 69 0 94 0 70 0 94 0 71 0 94 0 72 0 94 0 74 0 94 0 75 0 94 0 76 0 94 0 78 0 94 0 79 0 94 0 80 0 94 0 81 0 94 0 83 0 94 0 84 0 94 0 85 0 94 0 86 0 94 0 88 0 94 0 90 0 94 0 93 0 94 0 94 0 94 0 95 0 94 0 201] 
#[0 0 98 0 57 0 72 0 81 0 201] 
#[0 0 102 0 1 0 4 0 9 0 14 0 17 0 18 0 22 0 23 0 50 0 52 0 54 0 55 0 57 0 59 0 61 0 62 0 65 0 66 0 68 0 69 0 70 0 71 0 72 0 75 0 76 0 78 0 79 0 80 0 81 0 83 0 84 0 85 0 86 0 88 0 93 0 94 0 95 0 201] 
#[1 0 29 0 93 1 5 0 103] 
#[1 0 29 0 93 1 9 0 103] 
#[1 0 106 0 55 0 106 0 56 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 1 13 0 127] 
#[1 0 110 0 1 0 110 0 4 0 110 0 9 0 110 0 14 0 110 0 18 0 110 0 31 1 17 0 38 0 110 0 50 0 110 0 54 0 110 0 55 0 110 0 56 0 110 0 57 0 110 0 59 0 110 0 60 0 110 0 61 0 110 0 64 0 110 0 66 0 110 0 68 0 110 0 69 0 110 0 70 0 110 0 71 0 110 0 72 0 110 0 74 0 110 0 75 0 110 0 76 0 110 0 78 0 110 0 79 0 110 0 80 0 110 0 81 0 110 0 83 0 110 0 84 0 110 0 85 0 110 0 86 0 110 0 88 0 110 0 90 0 110 0 93 0 110 0 94 0 110 0 95 0 110 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 1 101 0 152 1 101 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 101 0 171 1 101 0 175 1 101 0 176 1 101 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 0 114 0 55 0 114 0 60 0 114 0 64 0 114 0 72 0 114 0 74 0 114 0 81 0 114 0 86 0 114 0 90 1 229 0 112] 
#[1 0 114 0 55 0 114 0 64 0 114 0 74 0 114 0 86 0 114 0 90 1 233 0 112] 
#[1 0 29 0 93 1 237 0 103] 
#[1 0 29 0 93 1 241 0 103] 
#[1 0 106 0 55 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 1 245 0 127] 
#[0 1 249 0 88] 
#[1 0 118 0 54 0 118 0 71 0 118 0 90 1 253 0 121] 
#[1 0 122 0 1 0 122 0 4 0 122 0 9 0 122 0 14 0 122 0 18 0 122 0 50 0 122 0 55 0 122 0 59 0 122 0 61 0 122 0 68 0 122 0 69 0 122 0 70 0 122 0 71 0 122 0 78 0 122 0 79 0 122 0 80 0 122 0 83 0 122 0 84 0 122 0 85 0 122 0 86 0 122 0 88 0 122 0 90 0 122 0 93 0 122 0 94 0 122 0 95 2 1 0 108] 
#[1 0 122 0 1 0 122 0 4 0 122 0 9 0 122 0 14 0 122 0 18 0 122 0 50 0 122 0 55 0 122 0 59 0 122 0 61 0 122 0 68 0 122 0 69 0 122 0 70 0 122 0 71 0 122 0 78 0 122 0 79 0 122 0 80 0 122 0 83 0 122 0 84 0 122 0 85 0 122 0 86 0 122 0 88 0 122 0 90 0 122 0 93 0 122 0 94 0 122 0 95 2 5 0 108] 
#[1 0 126 0 1 0 126 0 4 0 126 0 9 0 126 0 14 0 126 0 18 0 126 0 31 2 9 0 38 0 126 0 50 0 126 0 54 0 126 0 55 0 126 0 56 0 126 0 57 0 126 0 59 0 126 0 60 0 126 0 61 0 126 0 64 0 126 0 66 0 126 0 68 0 126 0 69 0 126 0 70 0 126 0 71 0 126 0 72 0 126 0 74 0 126 0 75 0 126 0 76 0 126 0 78 0 126 0 79 0 126 0 80 0 126 0 81 0 126 0 83 0 126 0 84 0 126 0 85 0 126 0 86 0 126 0 88 0 126 0 90 0 126 0 93 0 126 0 94 0 126 0 95 0 126 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 13 0 152 2 13 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 13 0 171 2 13 0 175 2 13 0 176 2 13 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 0 125 0 22 2 17 0 65 2 21 0 88] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 2 25 0 125] 
#[1 0 45 0 55 0 134 0 56 0 134 0 64 0 134 0 74 0 77 0 86 0 134 0 90 2 29 0 126 2 33 0 129 2 37 0 151] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 41 0 152 2 41 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 41 0 171 2 41 0 175 2 41 0 176 2 41 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 45 0 165 2 45 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 2 53 0 90 0 141 0 93 1 97 0 94 0 149 0 95 2 57 0 152 2 57 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 57 0 171 2 57 0 175 2 57 0 176 2 57 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 61 0 152 2 61 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 61 0 171 2 61 0 175 2 61 0 176 2 61 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 65 0 165 2 65 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 69 0 165 2 69 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 2 73 0 51 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 77 0 152 2 77 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 77 0 171 2 77 0 175 2 77 0 176 2 77 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 0 138 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 2 81 0 9] 
#[1 0 29 0 93 2 85 0 103] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 89 0 165 2 89 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[0 0 142 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 2 93 0 63 2 97 0 65 2 101 0 88] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 105 0 152 2 105 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 105 0 171 2 105 0 175 2 105 0 176 2 105 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 0 146 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 2 109 0 9] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 113 0 152 2 113 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 113 0 171 2 113 0 175 2 113 0 176 2 113 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 0 150 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 2 117 0 152 2 117 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 117 0 171 2 117 0 175 2 117 0 176 2 117 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 2 121 0 41 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 0 154 0 90 2 125 0 93 1 97 0 94 0 149 0 95 2 145 0 151 2 145 0 152 2 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 145 0 171 2 145 0 175 2 145 0 176 2 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 2 137 0 197 2 141 0 198 2 145 0 199 1 225 0 200] 
#[0 0 158 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 162 0 1 0 4 0 9 0 14 0 18 0 31 0 50 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 0 166 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[1 0 170 0 1 0 170 0 4 0 170 0 9 0 170 0 10 0 170 0 14 0 170 0 17 0 170 0 18 0 170 0 31 0 170 0 50 0 170 0 51 0 170 0 53 0 170 0 54 0 170 0 55 0 170 0 56 0 170 0 57 0 170 0 58 0 170 0 59 0 170 0 60 0 170 0 61 0 170 0 64 0 170 0 66 0 170 0 68 0 170 0 69 0 170 0 70 0 170 0 71 0 170 0 72 2 149 0 73 0 170 0 74 0 170 0 75 0 170 0 76 0 170 0 78 0 170 0 79 0 170 0 80 0 170 0 81 0 170 0 82 0 170 0 83 0 170 0 84 0 170 0 85 0 170 0 86 0 170 0 88 2 153 0 89 0 170 0 90 0 170 0 93 0 170 0 94 0 170 0 95 0 170 0 201] 
#[1 0 174 0 1 0 174 0 4 2 157 0 7 0 174 0 9 0 174 0 10 0 174 0 14 0 174 0 17 0 174 0 18 0 174 0 31 0 174 0 50 0 174 0 51 2 161 0 52 0 174 0 53 0 174 0 54 0 174 0 55 0 174 0 56 0 174 0 57 0 174 0 58 0 174 0 59 0 174 0 60 0 174 0 61 0 174 0 64 0 174 0 66 0 174 0 68 0 174 0 69 0 174 0 70 0 174 0 71 0 174 0 72 0 174 0 73 0 174 0 74 0 174 0 75 0 174 0 76 0 174 0 78 0 174 0 79 0 174 0 80 0 174 0 81 0 174 0 82 0 174 0 83 0 174 0 84 0 174 0 85 0 174 0 86 0 174 0 88 0 174 0 89 0 174 0 90 0 174 0 93 0 174 0 94 0 174 0 95 0 174 0 201] 
#[1 0 178 0 1 2 165 0 2 2 169 0 3 0 178 0 4 0 178 0 7 0 178 0 9 0 178 0 10 0 178 0 14 0 178 0 17 0 178 0 18 0 178 0 31 2 173 0 39 2 177 0 40 0 178 0 50 0 178 0 51 0 178 0 52 0 178 0 53 0 178 0 54 0 178 0 55 0 178 0 56 0 178 0 57 0 178 0 58 0 178 0 59 0 178 0 60 0 178 0 61 0 178 0 64 0 178 0 66 0 178 0 68 0 178 0 69 0 178 0 70 0 178 0 71 0 178 0 72 0 178 0 73 0 178 0 74 0 178 0 75 0 178 0 76 0 178 0 78 0 178 0 79 0 178 0 80 0 178 0 81 0 178 0 82 0 178 0 83 0 178 0 84 0 178 0 85 0 178 0 86 0 178 0 88 0 178 0 89 0 178 0 90 0 178 0 93 0 178 0 94 0 178 0 95 0 178 0 201] 
#[1 0 182 0 1 0 182 0 2 0 182 0 3 0 182 0 4 0 182 0 7 0 182 0 9 0 182 0 10 0 182 0 14 0 182 0 17 0 182 0 18 0 182 0 31 2 181 0 32 2 185 0 35 0 182 0 39 0 182 0 40 2 189 0 42 2 193 0 44 0 182 0 50 0 182 0 51 0 182 0 52 0 182 0 53 0 182 0 54 0 182 0 55 0 182 0 56 0 182 0 57 0 182 0 58 0 182 0 59 0 182 0 60 0 182 0 61 0 182 0 64 0 182 0 66 0 182 0 68 0 182 0 69 0 182 0 70 0 182 0 71 0 182 0 72 0 182 0 73 0 182 0 74 0 182 0 75 0 182 0 76 0 182 0 78 0 182 0 79 0 182 0 80 0 182 0 81 0 182 0 82 0 182 0 83 0 182 0 84 0 182 0 85 0 182 0 86 0 182 0 88 0 182 0 89 0 182 0 90 0 182 0 93 0 182 0 94 0 182 0 95 0 182 0 201] 
#[1 0 186 0 1 0 186 0 2 0 186 0 3 0 186 0 4 0 186 0 7 0 186 0 9 0 186 0 10 0 186 0 14 0 186 0 17 0 186 0 18 2 233 0 21 2 233 0 24 2 233 0 26 0 186 0 31 0 186 0 32 2 233 0 33 0 186 0 35 2 233 0 36 2 233 0 37 0 186 0 39 0 186 0 40 0 186 0 42 2 233 0 43 0 186 0 44 2 233 0 45 2 233 0 49 0 186 0 50 0 186 0 51 0 186 0 52 0 186 0 53 0 186 0 54 0 186 0 55 0 186 0 56 0 186 0 57 0 186 0 58 0 186 0 59 0 186 0 60 0 186 0 61 0 186 0 64 0 186 0 66 0 186 0 68 0 186 0 69 0 186 0 70 0 186 0 71 0 186 0 72 0 186 0 73 0 186 0 74 0 186 0 75 0 186 0 76 0 186 0 78 0 186 0 79 0 186 0 80 0 186 0 81 0 186 0 82 0 186 0 83 0 186 0 84 0 186 0 85 0 186 0 86 0 186 0 88 0 186 0 89 0 186 0 90 0 186 0 93 0 186 0 94 0 186 0 95 2 233 0 161 0 186 0 201] 
#[1 0 190 0 1 0 190 0 2 0 190 0 3 0 190 0 4 0 190 0 7 0 190 0 9 0 190 0 10 2 237 0 14 0 190 0 17 2 241 0 18 0 190 0 21 0 190 0 24 0 190 0 26 0 190 0 31 0 190 0 32 0 190 0 33 0 190 0 35 0 190 0 36 0 190 0 37 0 190 0 39 0 190 0 40 0 190 0 42 0 190 0 43 0 190 0 44 0 190 0 45 0 190 0 49 0 190 0 50 0 190 0 51 0 190 0 52 0 190 0 53 0 190 0 54 0 190 0 55 0 190 0 56 0 190 0 57 0 190 0 58 0 190 0 59 0 190 0 60 0 190 0 61 0 190 0 64 0 190 0 66 0 190 0 68 0 190 0 69 0 190 0 70 0 190 0 71 0 190 0 72 0 190 0 73 0 190 0 74 0 190 0 75 0 190 0 76 0 190 0 78 0 190 0 79 0 190 0 80 0 190 0 81 0 190 0 82 0 190 0 83 0 190 0 84 0 190 0 85 0 190 0 86 0 190 0 88 0 190 0 89 0 190 0 90 0 190 0 93 0 190 0 94 0 190 0 95 0 190 0 201] 
#[1 0 194 0 1 0 194 0 2 0 194 0 3 0 194 0 4 2 245 0 5 0 194 0 7 0 194 0 9 0 194 0 10 2 249 0 11 0 194 0 14 0 194 0 17 0 194 0 18 0 194 0 21 0 194 0 24 0 194 0 26 2 253 0 27 0 194 0 31 0 194 0 32 0 194 0 33 0 194 0 35 0 194 0 36 0 194 0 37 0 194 0 39 0 194 0 40 0 194 0 42 0 194 0 43 0 194 0 44 0 194 0 45 0 194 0 49 0 194 0 50 0 194 0 51 0 194 0 52 0 194 0 53 0 194 0 54 0 194 0 55 0 194 0 56 0 194 0 57 0 194 0 58 0 194 0 59 0 194 0 60 0 194 0 61 0 194 0 64 0 194 0 66 0 194 0 68 0 194 0 69 0 194 0 70 0 194 0 71 0 194 0 72 0 194 0 73 0 194 0 74 0 194 0 75 0 194 0 76 0 194 0 78 0 194 0 79 0 194 0 80 0 194 0 81 0 194 0 82 0 194 0 83 0 194 0 84 0 194 0 85 0 194 0 86 0 194 0 88 0 194 0 89 0 194 0 90 0 194 0 93 0 194 0 94 0 194 0 95 0 194 0 201] 
#[1 0 198 0 1 0 198 0 2 0 198 0 3 0 198 0 4 0 198 0 5 0 198 0 7 0 198 0 9 0 198 0 10 0 198 0 11 3 1 0 12 0 198 0 14 0 198 0 17 0 198 0 18 0 198 0 21 0 198 0 24 0 198 0 26 0 198 0 27 0 198 0 31 0 198 0 32 0 198 0 33 0 198 0 35 0 198 0 36 0 198 0 37 0 198 0 39 0 198 0 40 0 198 0 42 0 198 0 43 0 198 0 44 0 198 0 45 0 198 0 49 0 198 0 50 0 198 0 51 0 198 0 52 0 198 0 53 0 198 0 54 0 198 0 55 0 198 0 56 0 198 0 57 0 198 0 58 0 198 0 59 0 198 0 60 0 198 0 61 0 198 0 64 0 198 0 66 0 198 0 68 0 198 0 69 0 198 0 70 0 198 0 71 0 198 0 72 0 198 0 73 0 198 0 74 0 198 0 75 0 198 0 76 0 198 0 78 0 198 0 79 0 198 0 80 0 198 0 81 0 198 0 82 0 198 0 83 0 198 0 84 0 198 0 85 0 198 0 86 0 198 0 88 0 198 0 89 0 198 0 90 0 198 0 93 0 198 0 94 0 198 0 95 0 198 0 201] 
#[0 0 202 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 206 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 0 210 0 1 0 210 0 2 0 210 0 3 0 210 0 4 0 210 0 5 0 210 0 7 0 210 0 9 0 210 0 10 0 210 0 11 0 210 0 12 0 210 0 14 3 5 0 15 0 210 0 17 0 210 0 18 3 9 0 19 0 210 0 21 3 13 0 22 0 210 0 24 0 210 0 26 0 210 0 27 0 210 0 31 0 210 0 32 0 210 0 33 0 210 0 35 0 210 0 36 0 210 0 37 0 210 0 39 0 210 0 40 0 210 0 42 0 210 0 43 0 210 0 44 0 210 0 45 3 17 0 48 0 210 0 49 0 210 0 50 0 210 0 51 0 210 0 52 0 210 0 53 0 210 0 54 0 210 0 55 0 210 0 56 0 210 0 57 0 210 0 58 0 210 0 59 0 210 0 60 0 210 0 61 0 210 0 64 0 210 0 66 0 210 0 68 0 210 0 69 0 210 0 70 0 210 0 71 0 210 0 72 0 210 0 73 0 210 0 74 0 210 0 75 0 210 0 76 0 210 0 78 0 210 0 79 0 210 0 80 0 210 0 81 0 210 0 82 0 210 0 83 0 210 0 84 0 210 0 85 0 210 0 86 0 210 0 88 0 210 0 89 0 210 0 90 0 210 0 93 0 210 0 94 0 210 0 95 0 210 0 201] 
#[0 0 214 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 218 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 0 222 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 0 226 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 0 230 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 0 234 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 238 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 242 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 246 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 250 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 0 254 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 2 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 10 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 14 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 18 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 22 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 26 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 30 0 1 1 30 0 2 1 30 0 3 1 30 0 4 1 30 0 5 3 57 0 6 1 30 0 7 1 30 0 9 1 30 0 10 1 30 0 11 1 30 0 12 3 57 0 13 1 30 0 14 1 30 0 15 3 57 0 16 1 30 0 17 1 30 0 18 1 30 0 19 3 57 0 20 1 30 0 21 1 30 0 22 1 30 0 24 1 30 0 26 1 30 0 27 3 57 0 28 1 30 0 31 1 30 0 32 1 30 0 33 3 57 0 34 1 30 0 35 1 30 0 36 1 30 0 37 3 45 0 38 1 30 0 39 1 30 0 40 1 30 0 42 1 30 0 43 1 30 0 44 1 30 0 45 3 57 0 46 3 57 0 47 1 30 0 48 1 30 0 49 1 30 0 50 1 30 0 51 1 30 0 52 1 30 0 53 1 30 0 54 1 30 0 55 1 30 0 56 1 30 0 57 1 30 0 58 1 30 0 59 1 30 0 60 1 30 0 61 1 30 0 64 1 30 0 66 1 30 0 68 1 30 0 69 1 30 0 70 1 30 0 71 1 30 0 72 1 30 0 73 1 30 0 74 1 30 0 75 1 30 0 76 1 30 0 78 1 30 0 79 1 30 0 80 1 30 0 81 1 30 0 82 1 30 0 83 1 30 0 84 1 30 0 85 1 30 0 86 1 30 0 88 1 30 0 89 1 30 0 90 1 30 0 93 1 30 0 94 1 30 0 95 3 57 0 155 1 30 0 201] 
#[1 0 45 0 55 3 61 0 60 1 34 0 64 1 34 0 72 1 34 0 74 1 34 0 81 0 77 0 86 1 34 0 90 3 65 0 111 3 69 0 114 3 73 0 117 3 77 0 151] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 65 0 111 3 81 0 114 3 77 0 151] 
#[1 3 85 0 9 0 125 0 22 3 89 0 65 3 93 0 88] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 3 97 0 125] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 101 0 114 2 29 0 126 2 37 0 151] 
#[1 0 122 0 1 0 122 0 4 0 122 0 9 0 122 0 14 0 122 0 18 0 122 0 50 0 122 0 55 0 122 0 59 0 122 0 61 0 122 0 68 0 122 0 69 0 122 0 70 0 122 0 71 0 122 0 78 0 122 0 79 0 122 0 80 0 122 0 83 0 122 0 84 0 122 0 85 0 122 0 86 0 122 0 88 0 122 0 90 0 122 0 93 0 122 0 94 0 122 0 95 3 105 0 108] 
#[1 0 41 0 54 0 57 0 71 3 109 0 90 3 113 0 122 3 113 0 123 3 113 0 142] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 3 125 0 90 0 141 0 93 1 97 0 94 0 149 0 95 3 129 0 107 3 133 0 151 3 133 0 152 3 133 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 3 133 0 171 3 133 0 175 3 133 0 176 3 133 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 3 133 0 199 1 225 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 3 137 0 90 0 141 0 93 1 97 0 94 0 149 0 95 3 129 0 107 3 133 0 151 3 133 0 152 3 133 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 3 133 0 171 3 133 0 175 3 133 0 176 3 133 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 3 133 0 199 1 225 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 3 141 0 152 3 141 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 3 141 0 171 3 141 0 175 3 141 0 176 3 141 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 1 38 0 1 0 4 0 9 0 14 0 18 0 31 0 50 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[1 0 29 0 93 3 145 0 103] 
#[1 0 106 0 55 0 106 0 56 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 3 149 0 127] 
#[1 3 153 0 17 3 157 0 52 3 161 0 88 3 165 0 124] 
#[0 1 42 0 55 0 56 0 64 0 74 0 86 0 90] 
#[1 3 169 0 56 1 34 0 64 1 34 0 74 1 34 0 90 3 173 0 114 3 177 0 128 3 177 0 135] 
#[1 3 185 0 31 1 46 0 55 1 46 0 56 1 46 0 64 1 46 0 74 1 46 0 86 1 46 0 90] 
#[0 1 50 0 1 0 4 0 9 0 14 0 18 0 31 0 50 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 1 54 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 30 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 58 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 62 0 17 1 62 0 90 3 189 0 195] 
#[0 3 193 0 10] 
#[0 1 66 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 70 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 74 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 78 0 17 1 78 0 51 3 197 0 192] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 3 201 0 152 3 201 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 3 201 0 171 3 201 0 175 3 201 0 176 3 201 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 3 205 0 9 0 125 0 22] 
#[0 1 82 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 0 29 0 93 3 209 0 103] 
#[1 0 29 0 93 3 213 0 103] 
#[1 0 114 0 55 0 114 0 64 0 114 0 74 0 114 0 86 0 114 0 90 3 217 0 112] 
#[0 1 86 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 3 221 0 10 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 3 225 0 152 3 225 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 3 225 0 171 3 225 0 175 3 225 0 176 3 225 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 1 90 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[1 1 94 0 1 1 94 0 4 1 94 0 9 1 94 0 10 1 94 0 14 1 94 0 17 1 94 0 18 1 94 0 31 1 94 0 50 1 94 0 51 1 94 0 53 1 94 0 54 1 94 0 55 1 94 0 56 1 94 0 57 1 94 0 58 1 94 0 59 1 94 0 60 1 94 0 61 1 94 0 64 1 94 0 66 1 94 0 68 1 94 0 69 1 94 0 70 1 94 0 71 1 94 0 72 1 94 0 74 1 94 0 75 1 94 0 76 1 94 0 78 1 94 0 79 1 94 0 80 1 94 0 81 1 94 0 82 1 94 0 83 1 94 0 84 1 94 0 85 1 94 0 86 1 94 0 88 1 94 0 90 1 94 0 93 1 94 0 94 1 94 0 95 3 229 0 173 1 94 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 0 154 0 90 0 141 0 93 1 97 0 94 0 149 0 95 2 145 0 151 2 145 0 152 2 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 145 0 171 2 145 0 175 2 145 0 176 2 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 3 233 0 197 2 145 0 199 1 225 0 200] 
#[1 0 82 0 1 0 82 0 2 0 82 0 3 0 82 0 4 0 82 0 5 0 82 0 6 0 82 0 7 0 82 0 9 0 82 0 11 0 82 0 12 0 82 0 13 0 82 0 14 0 82 0 15 0 82 0 16 1 98 0 17 0 82 0 18 0 82 0 19 0 82 0 20 0 82 0 21 0 82 0 22 0 82 0 24 3 237 0 25 0 82 0 26 0 82 0 27 0 82 0 28 0 82 0 31 0 82 0 32 0 82 0 33 0 82 0 34 0 82 0 35 0 82 0 36 0 82 0 37 0 82 0 38 0 82 0 39 0 82 0 40 1 98 0 41 0 82 0 42 0 82 0 43 0 82 0 44 0 82 0 45 0 82 0 46 0 82 0 47 0 82 0 48 0 82 0 49 0 82 0 50 0 82 0 52 0 82 0 55 0 82 0 59 0 82 0 61 0 82 0 68 0 82 0 69 0 82 0 70 0 82 0 71 0 82 0 73 0 82 0 78 0 82 0 79 0 82 0 80 0 82 0 83 0 82 0 84 0 82 0 85 0 82 0 86 0 82 0 88 0 82 0 89 0 82 0 90 0 82 0 93 0 82 0 94 0 82 0 95] 
#[0 1 102 0 1 0 4 0 9 0 14 0 18 0 31 0 50 0 55 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95] 
#[0 1 106 0 1 0 4 0 9 0 14 0 18 0 31 0 50 0 55 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95] 
#[0 3 241 0 90] 
#[1 1 110 0 17 1 110 0 41 3 245 0 133] 
#[1 1 114 0 1 1 114 0 4 1 114 0 9 1 114 0 14 1 114 0 18 3 249 0 31 1 114 0 50 1 114 0 55 1 114 0 59 1 114 0 61 1 114 0 68 1 114 0 69 1 114 0 70 1 114 0 71 1 114 0 78 1 114 0 79 1 114 0 80 1 114 0 83 1 114 0 84 1 114 0 85 1 114 0 86 1 114 0 88 1 114 0 90 1 114 0 93 1 114 0 94 1 114 0 95 3 253 0 141] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 1 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 5 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 9 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 13 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 17 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 21 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 25 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 29 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 33 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 37 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 41 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 45 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[0 1 118 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 122 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 126 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 130 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 134 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 138 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 142 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 146 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[0 1 150 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 68 0 69 0 70 0 71 0 79 0 80 0 84 0 88 0 93 0 94 0 95] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 49 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 53 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 57 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 61 0 164 4 61 0 165 4 61 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 65 0 164 4 65 0 165 4 65 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 69 0 164 4 69 0 165 4 69 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 73 0 79 1 77 0 80 1 85 0 84 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 73 0 165 4 73 0 166 1 149 0 167 1 149 0 170 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[0 1 154 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 1 158 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 4 77 0 93] 
#[0 4 81 0 93] 
#[0 1 162 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[0 1 166 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[0 1 170 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[0 1 174 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[0 1 178 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[0 1 182 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 85 0 152 4 85 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 4 85 0 171 4 85 0 175 4 85 0 176 4 85 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 1 186 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[0 1 190 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 93 0 94 0 95] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 89 0 152 4 89 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 4 89 0 171 4 89 0 175 4 89 0 176 4 89 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 4 93 0 88] 
#[0 1 194 0 55 0 60 0 64 0 72 0 74 0 81 0 86 0 90] 
#[1 4 97 0 64 1 198 0 72 4 101 0 74 1 198 0 81 1 198 0 90 4 105 0 113 4 109 0 116 4 113 0 131] 
#[1 1 34 0 64 1 34 0 72 1 34 0 74 1 34 0 81 1 34 0 90 4 117 0 114] 
#[1 4 121 0 31 1 202 0 55 1 202 0 60 1 202 0 64 1 202 0 72 1 202 0 74 1 202 0 81 1 202 0 86 1 202 0 90] 
#[1 4 97 0 64 4 101 0 74 4 125 0 90 4 105 0 113 4 113 0 131] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 129 0 143 4 129 0 144 4 129 0 147 4 141 0 150 4 145 0 152 4 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 4 145 0 171 4 145 0 175 4 145 0 176 4 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 4 149 0 200] 
#[1 0 29 0 93 4 153 0 103] 
#[1 0 106 0 55 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 4 157 0 127] 
#[1 3 153 0 17 3 157 0 52 4 161 0 88 3 165 0 124] 
#[1 4 97 0 64 4 101 0 74 4 165 0 90 4 105 0 113 4 113 0 131] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 4 169 0 90 0 141 0 93 1 97 0 94 0 149 0 95 3 129 0 107 3 133 0 151 3 133 0 152 3 133 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 3 133 0 171 3 133 0 175 3 133 0 176 3 133 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 3 133 0 199 1 225 0 200] 
#[0 1 206 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 1 210 0 54 0 71 0 90] 
#[0 1 214 0 54 0 71 0 90] 
#[0 1 218 0 54 0 71 0 90] 
#[0 1 222 0 201] 
#[0 1 226 0 1 0 4 0 9 0 14 0 18 0 50 0 55 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95] 
#[1 1 230 0 1 1 230 0 4 1 230 0 9 1 230 0 14 1 230 0 18 4 173 0 31 1 230 0 50 1 230 0 55 1 230 0 59 1 230 0 61 1 230 0 68 1 230 0 69 1 230 0 70 1 230 0 71 1 230 0 78 1 230 0 79 1 230 0 80 1 230 0 83 1 230 0 84 1 230 0 85 1 230 0 86 1 230 0 88 1 230 0 90 1 230 0 93 1 230 0 94 1 230 0 95] 
#[0 1 234 0 57 0 72 0 81 0 90 0 201] 
#[0 1 238 0 1 0 4 0 9 0 14 0 18 0 31 0 50 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 4 177 0 125] 
#[1 0 45 0 55 0 134 0 56 0 134 0 64 0 134 0 74 0 77 0 86 0 134 0 90 2 29 0 126 4 181 0 129 2 37 0 151] 
#[1 0 29 0 93 4 185 0 103] 
#[1 0 29 0 93 4 189 0 103] 
#[1 0 106 0 55 0 106 0 56 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 4 193 0 127] 
#[0 1 242 0 17 0 52 0 88] 
#[0 4 197 0 9] 
#[1 4 97 0 64 4 101 0 74 4 201 0 90 4 105 0 113 4 113 0 131] 
#[0 1 246 0 56 0 64 0 74 0 90] 
#[0 1 250 0 56 0 64 0 74 0 90] 
#[0 1 254 0 55 0 56 0 64 0 74 0 86 0 90] 
#[1 4 205 0 17 4 209 0 90 4 213 0 194] 
#[0 2 2 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 4 217 0 17 4 221 0 51 4 225 0 191] 
#[0 4 229 0 10] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 4 233 0 10 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 4 237 0 143 4 237 0 144 4 237 0 147 4 141 0 150 4 145 0 152 4 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 4 145 0 171 4 145 0 175 4 145 0 176 4 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 4 149 0 200] 
#[1 4 241 0 9 0 125 0 22 4 245 0 65 4 249 0 88] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 4 253 0 125] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 65 0 111 5 1 0 114 3 77 0 151] 
#[0 2 6 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 2 10 0 10 2 10 0 17 5 5 0 169] 
#[1 2 14 0 1 2 14 0 4 2 14 0 9 2 14 0 10 2 14 0 14 2 14 0 17 2 14 0 18 2 14 0 31 2 14 0 50 2 14 0 51 5 9 0 53 2 14 0 54 2 14 0 55 2 14 0 56 2 14 0 57 2 14 0 58 2 14 0 59 2 14 0 60 2 14 0 61 2 14 0 64 2 14 0 66 2 14 0 68 2 14 0 69 2 14 0 70 2 14 0 71 2 14 0 72 2 14 0 74 2 14 0 75 2 14 0 76 2 14 0 78 2 14 0 79 2 14 0 80 2 14 0 81 5 13 0 82 2 14 0 83 2 14 0 84 2 14 0 85 2 14 0 86 2 14 0 88 2 14 0 90 2 14 0 93 2 14 0 94 2 14 0 95 5 17 0 172 5 17 0 174 2 14 0 201] 
#[0 5 25 0 90] 
#[0 2 18 0 10 0 17 0 41] 
#[0 2 22 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 5 29 0 17 5 33 0 41 5 37 0 132] 
#[1 1 114 0 1 1 114 0 4 1 114 0 9 1 114 0 14 1 114 0 18 1 114 0 50 1 114 0 55 1 114 0 59 1 114 0 61 1 114 0 68 1 114 0 69 1 114 0 70 1 114 0 71 1 114 0 78 1 114 0 79 1 114 0 80 1 114 0 83 1 114 0 84 1 114 0 85 1 114 0 86 1 114 0 88 1 114 0 90 1 114 0 93 1 114 0 94 1 114 0 95 5 41 0 141] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 2 26 0 90 0 141 0 93 1 97 0 94 0 149 0 95 5 45 0 140 5 49 0 151 5 49 0 152 5 49 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 5 49 0 171 5 49 0 175 5 49 0 176 5 49 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 5 49 0 199 1 225 0 200] 
#[1 2 30 0 1 2 30 0 4 2 157 0 7 2 30 0 9 2 30 0 10 2 30 0 14 2 30 0 17 2 30 0 18 2 30 0 31 2 30 0 50 2 30 0 51 2 161 0 52 2 30 0 53 2 30 0 54 2 30 0 55 2 30 0 56 2 30 0 57 2 30 0 58 2 30 0 59 2 30 0 60 2 30 0 61 2 30 0 64 2 30 0 66 2 30 0 68 2 30 0 69 2 30 0 70 2 30 0 71 2 30 0 72 2 30 0 73 2 30 0 74 2 30 0 75 2 30 0 76 2 30 0 78 2 30 0 79 2 30 0 80 2 30 0 81 2 30 0 82 2 30 0 83 2 30 0 84 2 30 0 85 2 30 0 86 2 30 0 88 2 30 0 89 2 30 0 90 2 30 0 93 2 30 0 94 2 30 0 95 2 30 0 201] 
#[1 2 34 0 1 2 34 0 4 2 157 0 7 2 34 0 9 2 34 0 10 2 34 0 14 2 34 0 17 2 34 0 18 2 34 0 31 2 34 0 50 2 34 0 51 2 161 0 52 2 34 0 53 2 34 0 54 2 34 0 55 2 34 0 56 2 34 0 57 2 34 0 58 2 34 0 59 2 34 0 60 2 34 0 61 2 34 0 64 2 34 0 66 2 34 0 68 2 34 0 69 2 34 0 70 2 34 0 71 2 34 0 72 2 34 0 73 2 34 0 74 2 34 0 75 2 34 0 76 2 34 0 78 2 34 0 79 2 34 0 80 2 34 0 81 2 34 0 82 2 34 0 83 2 34 0 84 2 34 0 85 2 34 0 86 2 34 0 88 2 34 0 89 2 34 0 90 2 34 0 93 2 34 0 94 2 34 0 95 2 34 0 201] 
#[1 2 38 0 1 2 165 0 2 2 169 0 3 2 38 0 4 2 38 0 7 2 38 0 9 2 38 0 10 2 38 0 14 2 38 0 17 2 38 0 18 2 38 0 31 2 173 0 39 2 177 0 40 2 38 0 50 2 38 0 51 2 38 0 52 2 38 0 53 2 38 0 54 2 38 0 55 2 38 0 56 2 38 0 57 2 38 0 58 2 38 0 59 2 38 0 60 2 38 0 61 2 38 0 64 2 38 0 66 2 38 0 68 2 38 0 69 2 38 0 70 2 38 0 71 2 38 0 72 2 38 0 73 2 38 0 74 2 38 0 75 2 38 0 76 2 38 0 78 2 38 0 79 2 38 0 80 2 38 0 81 2 38 0 82 2 38 0 83 2 38 0 84 2 38 0 85 2 38 0 86 2 38 0 88 2 38 0 89 2 38 0 90 2 38 0 93 2 38 0 94 2 38 0 95 2 38 0 201] 
#[1 2 42 0 1 2 165 0 2 2 169 0 3 2 42 0 4 2 42 0 7 2 42 0 9 2 42 0 10 2 42 0 14 2 42 0 17 2 42 0 18 2 42 0 31 2 173 0 39 2 177 0 40 2 42 0 50 2 42 0 51 2 42 0 52 2 42 0 53 2 42 0 54 2 42 0 55 2 42 0 56 2 42 0 57 2 42 0 58 2 42 0 59 2 42 0 60 2 42 0 61 2 42 0 64 2 42 0 66 2 42 0 68 2 42 0 69 2 42 0 70 2 42 0 71 2 42 0 72 2 42 0 73 2 42 0 74 2 42 0 75 2 42 0 76 2 42 0 78 2 42 0 79 2 42 0 80 2 42 0 81 2 42 0 82 2 42 0 83 2 42 0 84 2 42 0 85 2 42 0 86 2 42 0 88 2 42 0 89 2 42 0 90 2 42 0 93 2 42 0 94 2 42 0 95 2 42 0 201] 
#[1 2 46 0 1 2 46 0 2 2 46 0 3 2 46 0 4 2 46 0 7 2 46 0 9 2 46 0 10 2 46 0 14 2 46 0 17 2 46 0 18 2 46 0 31 2 181 0 32 2 185 0 35 2 46 0 39 2 46 0 40 2 189 0 42 2 193 0 44 2 46 0 50 2 46 0 51 2 46 0 52 2 46 0 53 2 46 0 54 2 46 0 55 2 46 0 56 2 46 0 57 2 46 0 58 2 46 0 59 2 46 0 60 2 46 0 61 2 46 0 64 2 46 0 66 2 46 0 68 2 46 0 69 2 46 0 70 2 46 0 71 2 46 0 72 2 46 0 73 2 46 0 74 2 46 0 75 2 46 0 76 2 46 0 78 2 46 0 79 2 46 0 80 2 46 0 81 2 46 0 82 2 46 0 83 2 46 0 84 2 46 0 85 2 46 0 86 2 46 0 88 2 46 0 89 2 46 0 90 2 46 0 93 2 46 0 94 2 46 0 95 2 46 0 201] 
#[1 2 50 0 1 2 50 0 2 2 50 0 3 2 50 0 4 2 50 0 7 2 50 0 9 2 50 0 10 2 50 0 14 2 50 0 17 2 50 0 18 2 50 0 31 2 181 0 32 2 185 0 35 2 50 0 39 2 50 0 40 2 189 0 42 2 193 0 44 2 50 0 50 2 50 0 51 2 50 0 52 2 50 0 53 2 50 0 54 2 50 0 55 2 50 0 56 2 50 0 57 2 50 0 58 2 50 0 59 2 50 0 60 2 50 0 61 2 50 0 64 2 50 0 66 2 50 0 68 2 50 0 69 2 50 0 70 2 50 0 71 2 50 0 72 2 50 0 73 2 50 0 74 2 50 0 75 2 50 0 76 2 50 0 78 2 50 0 79 2 50 0 80 2 50 0 81 2 50 0 82 2 50 0 83 2 50 0 84 2 50 0 85 2 50 0 86 2 50 0 88 2 50 0 89 2 50 0 90 2 50 0 93 2 50 0 94 2 50 0 95 2 50 0 201] 
#[1 2 54 0 1 2 54 0 2 2 54 0 3 2 54 0 4 2 54 0 7 2 54 0 9 2 54 0 10 2 54 0 14 2 54 0 17 2 54 0 18 2 54 0 31 2 181 0 32 2 185 0 35 2 54 0 39 2 54 0 40 2 189 0 42 2 193 0 44 2 54 0 50 2 54 0 51 2 54 0 52 2 54 0 53 2 54 0 54 2 54 0 55 2 54 0 56 2 54 0 57 2 54 0 58 2 54 0 59 2 54 0 60 2 54 0 61 2 54 0 64 2 54 0 66 2 54 0 68 2 54 0 69 2 54 0 70 2 54 0 71 2 54 0 72 2 54 0 73 2 54 0 74 2 54 0 75 2 54 0 76 2 54 0 78 2 54 0 79 2 54 0 80 2 54 0 81 2 54 0 82 2 54 0 83 2 54 0 84 2 54 0 85 2 54 0 86 2 54 0 88 2 54 0 89 2 54 0 90 2 54 0 93 2 54 0 94 2 54 0 95 2 54 0 201] 
#[1 2 58 0 1 2 58 0 2 2 58 0 3 2 58 0 4 2 58 0 7 2 58 0 9 2 58 0 10 2 58 0 14 2 58 0 17 2 58 0 18 2 58 0 31 2 181 0 32 2 185 0 35 2 58 0 39 2 58 0 40 2 189 0 42 2 193 0 44 2 58 0 50 2 58 0 51 2 58 0 52 2 58 0 53 2 58 0 54 2 58 0 55 2 58 0 56 2 58 0 57 2 58 0 58 2 58 0 59 2 58 0 60 2 58 0 61 2 58 0 64 2 58 0 66 2 58 0 68 2 58 0 69 2 58 0 70 2 58 0 71 2 58 0 72 2 58 0 73 2 58 0 74 2 58 0 75 2 58 0 76 2 58 0 78 2 58 0 79 2 58 0 80 2 58 0 81 2 58 0 82 2 58 0 83 2 58 0 84 2 58 0 85 2 58 0 86 2 58 0 88 2 58 0 89 2 58 0 90 2 58 0 93 2 58 0 94 2 58 0 95 2 58 0 201] 
#[1 2 62 0 1 2 62 0 2 2 62 0 3 2 62 0 4 2 62 0 7 2 62 0 9 2 62 0 10 2 62 0 14 2 62 0 17 2 62 0 18 2 233 0 21 2 233 0 24 2 233 0 26 2 62 0 31 2 62 0 32 2 233 0 33 2 62 0 35 2 233 0 36 2 233 0 37 2 62 0 39 2 62 0 40 2 62 0 42 2 233 0 43 2 62 0 44 2 233 0 45 2 233 0 49 2 62 0 50 2 62 0 51 2 62 0 52 2 62 0 53 2 62 0 54 2 62 0 55 2 62 0 56 2 62 0 57 2 62 0 58 2 62 0 59 2 62 0 60 2 62 0 61 2 62 0 64 2 62 0 66 2 62 0 68 2 62 0 69 2 62 0 70 2 62 0 71 2 62 0 72 2 62 0 73 2 62 0 74 2 62 0 75 2 62 0 76 2 62 0 78 2 62 0 79 2 62 0 80 2 62 0 81 2 62 0 82 2 62 0 83 2 62 0 84 2 62 0 85 2 62 0 86 2 62 0 88 2 62 0 89 2 62 0 90 2 62 0 93 2 62 0 94 2 62 0 95 2 233 0 161 2 62 0 201] 
#[1 2 66 0 1 2 66 0 2 2 66 0 3 2 66 0 4 2 66 0 7 2 66 0 9 2 66 0 10 2 66 0 14 2 66 0 17 2 66 0 18 2 233 0 21 2 233 0 24 2 233 0 26 2 66 0 31 2 66 0 32 2 233 0 33 2 66 0 35 2 233 0 36 2 233 0 37 2 66 0 39 2 66 0 40 2 66 0 42 2 233 0 43 2 66 0 44 2 233 0 45 2 233 0 49 2 66 0 50 2 66 0 51 2 66 0 52 2 66 0 53 2 66 0 54 2 66 0 55 2 66 0 56 2 66 0 57 2 66 0 58 2 66 0 59 2 66 0 60 2 66 0 61 2 66 0 64 2 66 0 66 2 66 0 68 2 66 0 69 2 66 0 70 2 66 0 71 2 66 0 72 2 66 0 73 2 66 0 74 2 66 0 75 2 66 0 76 2 66 0 78 2 66 0 79 2 66 0 80 2 66 0 81 2 66 0 82 2 66 0 83 2 66 0 84 2 66 0 85 2 66 0 86 2 66 0 88 2 66 0 89 2 66 0 90 2 66 0 93 2 66 0 94 2 66 0 95 2 233 0 161 2 66 0 201] 
#[1 2 70 0 1 2 70 0 2 2 70 0 3 2 70 0 4 2 70 0 7 2 70 0 9 2 70 0 10 2 70 0 14 2 70 0 17 2 70 0 18 2 233 0 21 2 233 0 24 2 233 0 26 2 70 0 31 2 70 0 32 2 233 0 33 2 70 0 35 2 233 0 36 2 233 0 37 2 70 0 39 2 70 0 40 2 70 0 42 2 233 0 43 2 70 0 44 2 233 0 45 2 233 0 49 2 70 0 50 2 70 0 51 2 70 0 52 2 70 0 53 2 70 0 54 2 70 0 55 2 70 0 56 2 70 0 57 2 70 0 58 2 70 0 59 2 70 0 60 2 70 0 61 2 70 0 64 2 70 0 66 2 70 0 68 2 70 0 69 2 70 0 70 2 70 0 71 2 70 0 72 2 70 0 73 2 70 0 74 2 70 0 75 2 70 0 76 2 70 0 78 2 70 0 79 2 70 0 80 2 70 0 81 2 70 0 82 2 70 0 83 2 70 0 84 2 70 0 85 2 70 0 86 2 70 0 88 2 70 0 89 2 70 0 90 2 70 0 93 2 70 0 94 2 70 0 95 2 233 0 161 2 70 0 201] 
#[1 2 74 0 1 2 74 0 2 2 74 0 3 2 74 0 4 2 74 0 7 2 74 0 9 2 74 0 10 2 74 0 14 2 74 0 17 2 74 0 18 2 233 0 21 2 233 0 24 2 233 0 26 2 74 0 31 2 74 0 32 2 233 0 33 2 74 0 35 2 233 0 36 2 233 0 37 2 74 0 39 2 74 0 40 2 74 0 42 2 233 0 43 2 74 0 44 2 233 0 45 2 233 0 49 2 74 0 50 2 74 0 51 2 74 0 52 2 74 0 53 2 74 0 54 2 74 0 55 2 74 0 56 2 74 0 57 2 74 0 58 2 74 0 59 2 74 0 60 2 74 0 61 2 74 0 64 2 74 0 66 2 74 0 68 2 74 0 69 2 74 0 70 2 74 0 71 2 74 0 72 2 74 0 73 2 74 0 74 2 74 0 75 2 74 0 76 2 74 0 78 2 74 0 79 2 74 0 80 2 74 0 81 2 74 0 82 2 74 0 83 2 74 0 84 2 74 0 85 2 74 0 86 2 74 0 88 2 74 0 89 2 74 0 90 2 74 0 93 2 74 0 94 2 74 0 95 2 233 0 161 2 74 0 201] 
#[1 2 78 0 1 2 78 0 2 2 78 0 3 2 78 0 4 2 78 0 7 2 78 0 9 2 78 0 10 2 237 0 14 2 78 0 17 2 241 0 18 2 78 0 21 2 78 0 24 2 78 0 26 2 78 0 31 2 78 0 32 2 78 0 33 2 78 0 35 2 78 0 36 2 78 0 37 2 78 0 39 2 78 0 40 2 78 0 42 2 78 0 43 2 78 0 44 2 78 0 45 2 78 0 49 2 78 0 50 2 78 0 51 2 78 0 52 2 78 0 53 2 78 0 54 2 78 0 55 2 78 0 56 2 78 0 57 2 78 0 58 2 78 0 59 2 78 0 60 2 78 0 61 2 78 0 64 2 78 0 66 2 78 0 68 2 78 0 69 2 78 0 70 2 78 0 71 2 78 0 72 2 78 0 73 2 78 0 74 2 78 0 75 2 78 0 76 2 78 0 78 2 78 0 79 2 78 0 80 2 78 0 81 2 78 0 82 2 78 0 83 2 78 0 84 2 78 0 85 2 78 0 86 2 78 0 88 2 78 0 89 2 78 0 90 2 78 0 93 2 78 0 94 2 78 0 95 2 78 0 201] 
#[1 2 82 0 1 2 82 0 2 2 82 0 3 2 82 0 4 2 245 0 5 2 82 0 7 2 82 0 9 2 82 0 10 2 249 0 11 2 82 0 14 2 82 0 17 2 82 0 18 2 82 0 21 2 82 0 24 2 82 0 26 2 253 0 27 2 82 0 31 2 82 0 32 2 82 0 33 2 82 0 35 2 82 0 36 2 82 0 37 2 82 0 39 2 82 0 40 2 82 0 42 2 82 0 43 2 82 0 44 2 82 0 45 2 82 0 49 2 82 0 50 2 82 0 51 2 82 0 52 2 82 0 53 2 82 0 54 2 82 0 55 2 82 0 56 2 82 0 57 2 82 0 58 2 82 0 59 2 82 0 60 2 82 0 61 2 82 0 64 2 82 0 66 2 82 0 68 2 82 0 69 2 82 0 70 2 82 0 71 2 82 0 72 2 82 0 73 2 82 0 74 2 82 0 75 2 82 0 76 2 82 0 78 2 82 0 79 2 82 0 80 2 82 0 81 2 82 0 82 2 82 0 83 2 82 0 84 2 82 0 85 2 82 0 86 2 82 0 88 2 82 0 89 2 82 0 90 2 82 0 93 2 82 0 94 2 82 0 95 2 82 0 201] 
#[1 2 86 0 1 2 86 0 2 2 86 0 3 2 86 0 4 2 245 0 5 2 86 0 7 2 86 0 9 2 86 0 10 2 249 0 11 2 86 0 14 2 86 0 17 2 86 0 18 2 86 0 21 2 86 0 24 2 86 0 26 2 253 0 27 2 86 0 31 2 86 0 32 2 86 0 33 2 86 0 35 2 86 0 36 2 86 0 37 2 86 0 39 2 86 0 40 2 86 0 42 2 86 0 43 2 86 0 44 2 86 0 45 2 86 0 49 2 86 0 50 2 86 0 51 2 86 0 52 2 86 0 53 2 86 0 54 2 86 0 55 2 86 0 56 2 86 0 57 2 86 0 58 2 86 0 59 2 86 0 60 2 86 0 61 2 86 0 64 2 86 0 66 2 86 0 68 2 86 0 69 2 86 0 70 2 86 0 71 2 86 0 72 2 86 0 73 2 86 0 74 2 86 0 75 2 86 0 76 2 86 0 78 2 86 0 79 2 86 0 80 2 86 0 81 2 86 0 82 2 86 0 83 2 86 0 84 2 86 0 85 2 86 0 86 2 86 0 88 2 86 0 89 2 86 0 90 2 86 0 93 2 86 0 94 2 86 0 95 2 86 0 201] 
#[1 2 90 0 1 2 90 0 2 2 90 0 3 2 90 0 4 2 90 0 5 2 90 0 7 2 90 0 9 2 90 0 10 2 90 0 11 3 1 0 12 2 90 0 14 2 90 0 17 2 90 0 18 2 90 0 21 2 90 0 24 2 90 0 26 2 90 0 27 2 90 0 31 2 90 0 32 2 90 0 33 2 90 0 35 2 90 0 36 2 90 0 37 2 90 0 39 2 90 0 40 2 90 0 42 2 90 0 43 2 90 0 44 2 90 0 45 2 90 0 49 2 90 0 50 2 90 0 51 2 90 0 52 2 90 0 53 2 90 0 54 2 90 0 55 2 90 0 56 2 90 0 57 2 90 0 58 2 90 0 59 2 90 0 60 2 90 0 61 2 90 0 64 2 90 0 66 2 90 0 68 2 90 0 69 2 90 0 70 2 90 0 71 2 90 0 72 2 90 0 73 2 90 0 74 2 90 0 75 2 90 0 76 2 90 0 78 2 90 0 79 2 90 0 80 2 90 0 81 2 90 0 82 2 90 0 83 2 90 0 84 2 90 0 85 2 90 0 86 2 90 0 88 2 90 0 89 2 90 0 90 2 90 0 93 2 90 0 94 2 90 0 95 2 90 0 201] 
#[1 2 94 0 1 2 94 0 2 2 94 0 3 2 94 0 4 2 94 0 5 2 94 0 7 2 94 0 9 2 94 0 10 2 94 0 11 3 1 0 12 2 94 0 14 2 94 0 17 2 94 0 18 2 94 0 21 2 94 0 24 2 94 0 26 2 94 0 27 2 94 0 31 2 94 0 32 2 94 0 33 2 94 0 35 2 94 0 36 2 94 0 37 2 94 0 39 2 94 0 40 2 94 0 42 2 94 0 43 2 94 0 44 2 94 0 45 2 94 0 49 2 94 0 50 2 94 0 51 2 94 0 52 2 94 0 53 2 94 0 54 2 94 0 55 2 94 0 56 2 94 0 57 2 94 0 58 2 94 0 59 2 94 0 60 2 94 0 61 2 94 0 64 2 94 0 66 2 94 0 68 2 94 0 69 2 94 0 70 2 94 0 71 2 94 0 72 2 94 0 73 2 94 0 74 2 94 0 75 2 94 0 76 2 94 0 78 2 94 0 79 2 94 0 80 2 94 0 81 2 94 0 82 2 94 0 83 2 94 0 84 2 94 0 85 2 94 0 86 2 94 0 88 2 94 0 89 2 94 0 90 2 94 0 93 2 94 0 94 2 94 0 95 2 94 0 201] 
#[1 2 98 0 1 2 98 0 2 2 98 0 3 2 98 0 4 2 98 0 5 2 98 0 7 2 98 0 9 2 98 0 10 2 98 0 11 3 1 0 12 2 98 0 14 2 98 0 17 2 98 0 18 2 98 0 21 2 98 0 24 2 98 0 26 2 98 0 27 2 98 0 31 2 98 0 32 2 98 0 33 2 98 0 35 2 98 0 36 2 98 0 37 2 98 0 39 2 98 0 40 2 98 0 42 2 98 0 43 2 98 0 44 2 98 0 45 2 98 0 49 2 98 0 50 2 98 0 51 2 98 0 52 2 98 0 53 2 98 0 54 2 98 0 55 2 98 0 56 2 98 0 57 2 98 0 58 2 98 0 59 2 98 0 60 2 98 0 61 2 98 0 64 2 98 0 66 2 98 0 68 2 98 0 69 2 98 0 70 2 98 0 71 2 98 0 72 2 98 0 73 2 98 0 74 2 98 0 75 2 98 0 76 2 98 0 78 2 98 0 79 2 98 0 80 2 98 0 81 2 98 0 82 2 98 0 83 2 98 0 84 2 98 0 85 2 98 0 86 2 98 0 88 2 98 0 89 2 98 0 90 2 98 0 93 2 98 0 94 2 98 0 95 2 98 0 201] 
#[0 2 102 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 17 0 18 0 21 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 5 53 0 9 1 93 0 88 5 57 0 196] 
#[1 5 61 0 9 1 93 0 88 5 65 0 196] 
#[0 2 106 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 2 110 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[1 2 114 0 1 2 114 0 4 2 114 0 9 2 114 0 14 2 114 0 18 2 114 0 50 2 114 0 59 2 114 0 61 2 114 0 68 2 114 0 69 2 114 0 70 2 114 0 71 2 114 0 78 2 114 0 79 2 114 0 80 2 114 0 83 2 114 0 84 2 114 0 85 2 114 0 88 2 114 0 90 2 114 0 93 2 114 0 94 2 114 0 95 5 69 0 119] 
#[0 5 149 0 2 0 3 0 5 0 7 0 11 0 12 0 14 0 18 0 21 0 24 0 26 0 27 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 52 0 73 0 89 0 93 0 134 0 161] 
#[0 5 157 0 64] 
#[0 2 118 0 64 0 72 0 74 0 81 0 90] 
#[1 0 61 0 72 0 73 0 81 5 161 0 90 5 169 0 109 5 169 0 115] 
#[1 5 173 0 31 2 122 0 64 2 122 0 72 2 122 0 74 2 122 0 81 2 122 0 90] 
#[1 4 97 0 64 1 198 0 72 4 101 0 74 1 198 0 81 1 198 0 90 4 105 0 113 5 177 0 116 4 113 0 131] 
#[0 2 126 0 55 0 60 0 64 0 72 0 74 0 81 0 86 0 90] 
#[0 2 130 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 201] 
#[0 5 181 0 10] 
#[0 2 134 0 10] 
#[0 2 138 0 10] 
#[1 2 142 0 10 2 142 0 17 5 185 0 146] 
#[1 2 146 0 10 2 146 0 17 5 189 0 149] 
#[1 1 30 0 2 1 30 0 3 1 30 0 5 3 57 0 6 1 30 0 7 1 30 0 10 1 30 0 11 1 30 0 12 3 57 0 13 1 30 0 14 1 30 0 15 3 57 0 16 1 30 0 17 1 30 0 18 1 30 0 19 3 57 0 20 1 30 0 21 1 30 0 22 1 30 0 24 1 30 0 26 1 30 0 27 3 57 0 28 5 193 0 30 1 30 0 32 1 30 0 33 3 57 0 34 1 30 0 35 1 30 0 36 1 30 0 37 3 45 0 38 1 30 0 39 1 30 0 40 1 30 0 42 1 30 0 43 1 30 0 44 1 30 0 45 3 57 0 46 3 57 0 47 1 30 0 48 1 30 0 49 1 30 0 52 1 30 0 73 1 30 0 89 3 57 0 155] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 5 197 0 125] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 5 201 0 114 2 29 0 126 2 37 0 151] 
#[1 0 106 0 55 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 5 205 0 127] 
#[0 2 150 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[0 2 154 0 57 0 72 0 81 0 90 0 201] 
#[0 2 158 0 1 0 4 0 9 0 14 0 18 0 50 0 55 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95] 
#[1 3 153 0 17 3 157 0 52 5 209 0 88 3 165 0 124] 
#[1 3 169 0 56 1 34 0 64 1 34 0 74 1 34 0 90 5 213 0 114 3 177 0 128 3 177 0 135] 
#[1 2 162 0 17 0 125 0 22 2 162 0 52 2 162 0 88] 
#[1 2 166 0 17 0 125 0 22 2 166 0 52 2 166 0 88] 
#[1 0 45 0 55 0 134 0 56 0 134 0 64 0 134 0 74 0 77 0 86 0 134 0 90 2 29 0 126 5 217 0 129 2 37 0 151] 
#[1 5 221 0 10 5 225 0 93 5 229 0 198] 
#[0 2 170 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 5 233 0 152 5 233 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 5 233 0 171 5 233 0 175 5 233 0 176 5 233 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 2 174 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 2 178 0 17 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 5 237 0 152 5 237 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 5 237 0 171 5 237 0 175 5 237 0 176 5 237 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 2 182 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 2 186 0 17 0 51] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 5 241 0 152 5 241 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 5 241 0 171 5 241 0 175 5 241 0 176 5 241 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 2 190 0 1 2 190 0 2 2 190 0 3 2 190 0 4 2 190 0 5 2 190 0 7 2 190 0 9 2 190 0 10 2 190 0 11 2 190 0 12 2 190 0 14 2 190 0 15 2 190 0 17 2 190 0 18 2 190 0 19 2 190 0 21 2 190 0 22 2 190 0 24 2 190 0 26 2 190 0 27 2 190 0 31 2 190 0 32 2 190 0 33 2 190 0 35 2 190 0 36 2 190 0 37 2 190 0 39 2 190 0 40 2 190 0 42 2 190 0 43 2 190 0 44 2 190 0 45 2 190 0 48 2 190 0 49 2 190 0 50 2 190 0 51 2 190 0 52 2 190 0 53 2 190 0 54 2 190 0 55 2 190 0 56 2 190 0 57 2 190 0 58 2 190 0 59 2 190 0 60 2 190 0 61 2 190 0 64 2 190 0 66 2 190 0 68 2 190 0 69 2 190 0 70 2 190 0 71 2 190 0 72 2 190 0 73 2 190 0 74 2 190 0 75 2 190 0 76 2 190 0 78 2 190 0 79 2 190 0 80 2 190 0 81 2 190 0 82 2 190 0 83 2 190 0 84 2 190 0 85 2 190 0 86 5 245 0 87 2 190 0 88 2 190 0 89 2 190 0 90 2 190 0 93 2 190 0 94 2 190 0 95 5 249 0 179 5 253 0 180 2 190 0 201] 
#[0 6 1 0 10] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 5 0 143 6 5 0 144 6 5 0 147 4 141 0 150 4 145 0 152 4 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 4 145 0 171 4 145 0 175 4 145 0 176 4 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 4 149 0 200] 
#[1 0 29 0 93 6 9 0 103] 
#[1 0 114 0 55 0 114 0 64 0 114 0 74 0 114 0 86 0 114 0 90 6 13 0 112] 
#[1 3 153 0 17 3 157 0 52 6 17 0 88 3 165 0 124] 
#[1 4 97 0 64 4 101 0 74 6 21 0 90 4 105 0 113 4 113 0 131] 
#[1 6 25 0 10 6 29 0 17 6 33 0 168] 
#[1 0 141 0 93 6 37 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 41 0 152 6 41 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 41 0 171 6 41 0 175 6 41 0 176 6 41 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 2 194 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 2 198 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 2 202 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 5 225 0 93 6 45 0 198] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 0 154 0 90 0 141 0 93 1 97 0 94 0 149 0 95 2 145 0 151 2 145 0 152 2 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 2 145 0 171 2 145 0 175 2 145 0 176 2 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 6 49 0 197 2 145 0 199 1 225 0 200] 
#[0 2 206 0 10 0 17 0 41] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 2 210 0 90 0 141 0 93 1 97 0 94 0 149 0 95 5 45 0 140 5 49 0 151 5 49 0 152 5 49 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 5 49 0 171 5 49 0 175 5 49 0 176 5 49 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 5 49 0 199 1 225 0 200] 
#[0 2 214 0 1 0 4 0 9 0 14 0 18 0 50 0 55 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95] 
#[1 2 218 0 1 2 218 0 4 2 218 0 9 2 218 0 14 2 218 0 18 6 53 0 31 2 218 0 50 2 218 0 55 2 218 0 59 2 218 0 61 2 218 0 68 2 218 0 69 2 218 0 70 2 218 0 71 2 218 0 78 2 218 0 79 2 218 0 80 2 218 0 83 2 218 0 84 2 218 0 85 2 218 0 86 2 218 0 88 2 218 0 90 2 218 0 93 2 218 0 94 2 218 0 95] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 6 57 0 10 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 61 0 152 6 61 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 61 0 171 6 61 0 175 6 61 0 176 6 61 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 2 222 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 6 65 0 10 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 69 0 152 6 69 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 69 0 171 6 69 0 175 6 69 0 176 6 69 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 2 226 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 6 73 0 90 0 141 0 93 1 97 0 94 0 149 0 95 6 77 0 118 6 81 0 152 6 81 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 81 0 171 6 81 0 175 6 81 0 176 6 81 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 2 230 0 9] 
#[0 2 234 0 9] 
#[0 2 238 0 9] 
#[0 2 242 0 9] 
#[0 2 246 0 9] 
#[0 2 250 0 9] 
#[0 2 254 0 9] 
#[0 3 2 0 9] 
#[0 3 6 0 9] 
#[0 3 10 0 9] 
#[0 3 14 0 9] 
#[0 3 18 0 9] 
#[0 3 22 0 9] 
#[0 3 26 0 9] 
#[0 3 30 0 9] 
#[0 3 34 0 9] 
#[0 3 38 0 9] 
#[0 3 42 0 9] 
#[0 3 46 0 9] 
#[0 6 85 0 9] 
#[0 3 50 0 9] 
#[0 6 89 0 2 0 3 0 5 0 7 0 11 0 12 0 14 0 18 0 21 0 24 0 26 0 27 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 49 0 52 0 73 0 89 0 93 0 134 0 161] 
#[0 3 54 0 57 0 72 0 81 0 201] 
#[0 3 58 0 72 0 81 0 90] 
#[0 3 62 0 72 0 81 0 90] 
#[0 3 66 0 64 0 72 0 74 0 81 0 90] 
#[1 0 61 0 72 0 73 0 81 6 93 0 90 5 169 0 109 5 169 0 115] 
#[1 6 97 0 65 6 101 0 88] 
#[1 3 70 0 10 6 105 0 17 6 109 0 145] 
#[1 3 74 0 10 6 113 0 17 6 117 0 148] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 121 0 152 6 121 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 121 0 171 6 121 0 175 6 121 0 176 6 121 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 3 153 0 17 3 157 0 52 6 125 0 88 3 165 0 124] 
#[1 4 97 0 64 4 101 0 74 6 129 0 90 4 105 0 113 4 113 0 131] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 6 133 0 114 2 29 0 126 2 37 0 151] 
#[1 0 106 0 55 0 106 0 56 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 6 137 0 127] 
#[1 4 97 0 64 4 101 0 74 6 141 0 90 4 105 0 113 4 113 0 131] 
#[1 3 169 0 56 1 34 0 64 1 34 0 74 1 34 0 90 6 145 0 114 3 177 0 128 3 177 0 135] 
#[1 6 149 0 38 3 78 0 56 3 78 0 64 3 78 0 74 6 153 0 88 3 78 0 90 6 157 0 139] 
#[1 1 98 0 10 1 98 0 17 3 237 0 25 1 98 0 41] 
#[1 1 110 0 10 1 110 0 17 6 161 0 133] 
#[0 3 82 0 17 0 90] 
#[0 3 86 0 17 0 51] 
#[1 3 90 0 1 3 90 0 4 3 90 0 9 3 90 0 10 3 90 0 14 3 90 0 17 3 90 0 18 3 90 0 31 3 90 0 50 3 90 0 51 3 90 0 53 3 90 0 54 3 90 0 55 3 90 0 56 3 90 0 57 6 165 0 58 3 90 0 59 3 90 0 60 3 90 0 61 3 90 0 64 3 90 0 66 3 90 0 68 3 90 0 69 3 90 0 70 3 90 0 71 3 90 0 72 3 90 0 74 3 90 0 75 3 90 0 76 3 90 0 78 3 90 0 79 3 90 0 80 3 90 0 81 3 90 0 82 3 90 0 83 3 90 0 84 3 90 0 85 3 90 0 86 3 90 0 88 3 90 0 90 3 90 0 93 3 90 0 94 3 90 0 95 3 90 0 201] 
#[0 6 169 0 93] 
#[0 3 94 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 87 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 3 98 0 1 3 98 0 2 3 98 0 3 3 98 0 4 3 98 0 5 3 98 0 7 3 98 0 9 3 98 0 10 3 98 0 11 3 98 0 12 3 98 0 14 3 98 0 15 3 98 0 17 3 98 0 18 3 98 0 19 3 98 0 21 3 98 0 22 3 98 0 24 3 98 0 26 3 98 0 27 3 98 0 31 3 98 0 32 3 98 0 33 3 98 0 35 3 98 0 36 3 98 0 37 3 98 0 39 3 98 0 40 3 98 0 42 3 98 0 43 3 98 0 44 3 98 0 45 3 98 0 48 3 98 0 49 3 98 0 50 3 98 0 51 3 98 0 52 3 98 0 53 3 98 0 54 3 98 0 55 3 98 0 56 3 98 0 57 3 98 0 58 3 98 0 59 3 98 0 60 3 98 0 61 3 98 0 64 3 98 0 66 3 98 0 68 3 98 0 69 3 98 0 70 3 98 0 71 3 98 0 72 3 98 0 73 3 98 0 74 3 98 0 75 3 98 0 76 3 98 0 78 3 98 0 79 3 98 0 80 3 98 0 81 3 98 0 82 3 98 0 83 3 98 0 84 3 98 0 85 3 98 0 86 5 245 0 87 3 98 0 88 3 98 0 89 3 98 0 90 3 98 0 93 3 98 0 94 3 98 0 95 6 173 0 179 3 98 0 201] 
#[1 3 102 0 1 3 102 0 2 3 102 0 3 3 102 0 4 3 102 0 5 3 102 0 7 3 102 0 9 3 102 0 10 3 102 0 11 3 102 0 12 3 102 0 14 3 102 0 15 3 102 0 17 3 102 0 18 3 102 0 19 3 102 0 21 3 102 0 22 3 102 0 24 3 102 0 26 3 102 0 27 3 102 0 31 3 102 0 32 3 102 0 33 3 102 0 35 3 102 0 36 3 102 0 37 3 102 0 39 3 102 0 40 3 102 0 42 3 102 0 43 3 102 0 44 3 102 0 45 3 102 0 48 3 102 0 49 3 102 0 50 3 102 0 51 3 102 0 52 3 102 0 53 3 102 0 54 3 102 0 55 3 102 0 56 3 102 0 57 3 102 0 58 3 102 0 59 3 102 0 60 3 102 0 61 3 102 0 64 3 102 0 66 3 102 0 68 3 102 0 69 3 102 0 70 3 102 0 71 3 102 0 72 3 102 0 73 3 102 0 74 3 102 0 75 3 102 0 76 3 102 0 78 3 102 0 79 3 102 0 80 3 102 0 81 3 102 0 82 3 102 0 83 3 102 0 84 3 102 0 85 3 102 0 86 5 245 0 87 3 102 0 88 3 102 0 89 3 102 0 90 3 102 0 93 3 102 0 94 3 102 0 95 5 249 0 179 6 177 0 180 3 102 0 201] 
#[0 6 181 0 10] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 6 185 0 125] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 65 0 111 6 189 0 114 3 77 0 151] 
#[1 0 114 0 55 0 114 0 64 0 114 0 74 0 114 0 86 0 114 0 90 6 193 0 112] 
#[0 3 106 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 3 110 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 197 0 152 6 197 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 197 0 171 6 197 0 175 6 197 0 176 6 197 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 3 114 0 10 0 17] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 6 201 0 29 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 205 0 152 6 205 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 205 0 171 6 205 0 175 6 205 0 176 6 205 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 3 118 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 3 122 0 10 0 17 0 41] 
#[0 6 209 0 90] 
#[0 3 126 0 1 0 4 0 9 0 14 0 18 0 50 0 55 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95] 
#[0 3 130 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 2 10 0 10 2 10 0 17 6 213 0 169] 
#[0 3 134 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 2 10 0 10 2 10 0 17 6 217 0 169] 
#[0 3 138 0 64 0 72 0 74 0 81 0 90] 
#[0 3 142 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 90 0 93 0 94 0 95] 
#[1 3 146 0 1 3 146 0 4 3 146 0 9 3 146 0 14 3 146 0 18 6 221 0 31 3 146 0 50 3 146 0 59 3 146 0 61 3 146 0 68 3 146 0 69 3 146 0 70 3 146 0 71 3 146 0 78 3 146 0 79 3 146 0 80 3 146 0 83 3 146 0 84 3 146 0 85 3 146 0 88 3 146 0 90 3 146 0 93 3 146 0 94 3 146 0 95] 
#[1 6 225 0 10 5 225 0 93 6 229 0 198] 
#[0 6 233 0 9] 
#[0 3 150 0 57 0 72 0 81 0 201] 
#[1 0 29 0 93 6 237 0 103] 
#[1 0 106 0 55 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 6 241 0 127] 
#[1 0 141 0 93 6 245 0 150 6 249 0 200] 
#[0 3 154 0 10 0 17] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 6 253 0 152 6 253 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 6 253 0 171 6 253 0 175 6 253 0 176 6 253 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 3 158 0 10 0 17] 
#[0 3 162 0 10 0 17] 
#[1 0 106 0 55 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 7 1 0 127] 
#[0 3 166 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[1 4 97 0 64 4 101 0 74 7 5 0 90 4 105 0 113 4 113 0 131] 
#[1 0 45 0 55 0 134 0 56 0 134 0 64 0 134 0 74 0 77 0 86 0 134 0 90 2 29 0 126 7 9 0 129 2 37 0 151] 
#[0 3 170 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[1 4 97 0 64 4 101 0 74 7 13 0 90 4 105 0 113 4 113 0 131] 
#[1 7 17 0 79 7 21 0 80 7 25 0 136 7 25 0 137 7 25 0 138] 
#[1 1 114 0 1 1 114 0 4 1 114 0 9 1 114 0 14 1 114 0 18 1 114 0 50 1 114 0 55 1 114 0 59 1 114 0 61 1 114 0 68 1 114 0 69 1 114 0 70 1 114 0 71 1 114 0 78 1 114 0 79 1 114 0 80 1 114 0 83 1 114 0 84 1 114 0 85 1 114 0 86 1 114 0 88 1 114 0 90 1 114 0 93 1 114 0 94 1 114 0 95 7 37 0 141] 
#[0 3 174 0 56 0 64 0 74 0 90] 
#[1 7 41 0 10 5 29 0 17 5 37 0 132] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 7 45 0 152 7 45 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 7 45 0 171 7 45 0 175 7 45 0 176 7 45 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 3 178 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 87 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 3 182 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 87 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 3 186 0 1 3 186 0 2 3 186 0 3 3 186 0 4 3 186 0 5 3 186 0 7 3 186 0 9 3 186 0 10 3 186 0 11 3 186 0 12 3 186 0 14 3 186 0 15 3 186 0 17 3 186 0 18 3 186 0 19 3 186 0 21 3 186 0 22 3 186 0 24 3 186 0 26 3 186 0 27 3 186 0 31 3 186 0 32 3 186 0 33 3 186 0 35 3 186 0 36 3 186 0 37 3 186 0 39 3 186 0 40 3 186 0 42 3 186 0 43 3 186 0 44 3 186 0 45 3 186 0 48 3 186 0 49 3 186 0 50 3 186 0 51 3 186 0 52 3 186 0 53 3 186 0 54 3 186 0 55 3 186 0 56 3 186 0 57 3 186 0 58 3 186 0 59 3 186 0 60 3 186 0 61 3 186 0 64 3 186 0 66 3 186 0 68 3 186 0 69 3 186 0 70 3 186 0 71 3 186 0 72 3 186 0 73 3 186 0 74 3 186 0 75 3 186 0 76 3 186 0 78 3 186 0 79 3 186 0 80 3 186 0 81 3 186 0 82 3 186 0 83 3 186 0 84 3 186 0 85 3 186 0 86 5 245 0 87 3 186 0 88 3 186 0 89 3 186 0 90 3 186 0 93 3 186 0 94 3 186 0 95 6 173 0 179 3 186 0 201] 
#[1 7 49 0 65 7 53 0 88] 
#[1 3 153 0 17 3 157 0 52 7 57 0 88 3 165 0 124] 
#[1 4 97 0 64 4 101 0 74 7 61 0 90 4 105 0 113 4 113 0 131] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 65 0 111 7 65 0 114 3 77 0 151] 
#[0 3 190 0 10 0 17] 
#[1 0 29 0 93 7 69 0 103] 
#[0 3 194 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 3 198 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 7 73 0 10 6 29 0 17 6 33 0 168] 
#[1 7 77 0 10 6 29 0 17 6 33 0 168] 
#[0 3 202 0 1 0 4 0 9 0 14 0 18 0 50 0 59 0 61 0 68 0 69 0 70 0 71 0 78 0 79 0 80 0 83 0 84 0 85 0 88 0 90 0 93 0 94 0 95] 
#[1 3 206 0 31 7 81 0 38 3 206 0 64 7 85 0 67 3 206 0 72 3 206 0 74 3 206 0 81 6 153 0 88 3 206 0 90 7 89 0 139] 
#[1 1 110 0 10 1 110 0 17 7 93 0 133] 
#[1 7 97 0 10 5 225 0 93 7 101 0 198] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 7 105 0 125] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 7 109 0 114 2 29 0 126 2 37 0 151] 
#[0 3 210 0 10 0 17] 
#[0 5 193 0 30] 
#[0 3 214 0 10 0 17] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 7 113 0 114 2 29 0 126 2 37 0 151] 
#[0 3 218 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[1 3 169 0 56 1 34 0 64 1 34 0 74 1 34 0 90 7 117 0 114 3 177 0 128 3 177 0 135] 
#[0 3 222 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[0 7 121 0 9] 
#[0 7 125 0 9] 
#[1 3 226 0 56 3 226 0 64 3 226 0 74 6 153 0 88 3 226 0 90 7 129 0 139] 
#[0 3 230 0 56 0 64 0 74 0 88 0 90] 
#[0 3 234 0 56 0 64 0 74 0 88 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 0 45 0 55 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 0 77 0 86 1 93 0 88 7 133 0 90 0 141 0 93 1 97 0 94 0 149 0 95 5 45 0 140 5 49 0 151 5 49 0 152 5 49 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 5 49 0 171 5 49 0 175 5 49 0 176 5 49 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 5 49 0 199 1 225 0 200] 
#[1 7 137 0 38 3 238 0 56 3 238 0 64 3 238 0 74 6 153 0 88 3 238 0 90 7 141 0 139] 
#[0 3 242 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[1 0 29 0 93 7 145 0 103] 
#[1 0 114 0 55 0 114 0 64 0 114 0 74 0 114 0 86 0 114 0 90 7 149 0 112] 
#[1 0 114 0 55 0 114 0 64 0 114 0 74 0 114 0 86 0 114 0 90 7 153 0 112] 
#[0 3 246 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 4 97 0 64 4 101 0 74 7 157 0 90 4 105 0 113 4 113 0 131] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 0 125 0 22 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 7 161 0 152 7 161 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 7 161 0 171 7 161 0 175 7 161 0 176 7 161 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 3 250 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 3 254 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 7 165 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 7 165 0 171 7 165 0 175 7 165 0 176 7 165 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 4 2 0 31 7 189 0 38 4 2 0 64 4 2 0 72 4 2 0 74 4 2 0 81 6 153 0 88 4 2 0 90 7 193 0 139] 
#[0 4 6 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 7 197 0 10 5 29 0 17 5 37 0 132] 
#[1 4 10 0 31 7 201 0 38 4 10 0 64 7 205 0 67 4 10 0 72 4 10 0 74 4 10 0 81 6 153 0 88 4 10 0 90 7 209 0 139] 
#[1 1 110 0 10 1 110 0 17 7 213 0 133] 
#[1 3 153 0 17 3 157 0 52 7 217 0 88 3 165 0 124] 
#[1 4 97 0 64 4 101 0 74 7 221 0 90 4 105 0 113 4 113 0 131] 
#[1 4 97 0 64 4 101 0 74 7 225 0 90 4 105 0 113 4 113 0 131] 
#[1 4 97 0 64 4 101 0 74 7 229 0 90 4 105 0 113 4 113 0 131] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 7 233 0 10 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 7 237 0 147 4 145 0 152 4 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 4 145 0 171 4 145 0 175 4 145 0 176 4 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 7 241 0 10 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 7 245 0 147 4 145 0 152 4 145 0 154 1 109 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 4 145 0 171 4 145 0 175 4 145 0 176 4 145 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 225 0 200] 
#[0 4 14 0 56 0 64 0 74 0 90] 
#[0 4 18 0 31 0 56 0 64 0 72 0 74 0 81 0 90] 
#[1 7 17 0 79 7 21 0 80 7 249 0 136 7 249 0 137 7 249 0 138] 
#[0 4 22 0 56 0 64 0 74 0 90] 
#[1 0 130 0 17 0 125 0 22 0 130 0 52 0 130 0 88 7 253 0 125] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 65 0 111 8 1 0 114 3 77 0 151] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 65 0 111 8 5 0 114 3 77 0 151] 
#[0 4 26 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 4 30 0 1 0 4 0 9 0 10 0 14 0 17 0 18 0 31 0 50 0 51 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 90 0 93 0 94 0 95 0 201] 
#[0 4 34 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 4 38 0 31 4 38 0 64 4 38 0 72 2 149 0 73 4 38 0 74 4 38 0 81 2 153 0 89 4 38 0 90] 
#[0 4 42 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 46 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 50 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 54 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 8 9 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 8 9 0 171 8 9 0 175 8 9 0 176 8 9 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[0 4 58 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 4 62 0 31 8 13 0 38 4 62 0 64 8 17 0 67 4 62 0 72 4 62 0 74 4 62 0 81 6 153 0 88 4 62 0 90 8 21 0 139] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 8 25 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 8 25 0 171 8 25 0 175 8 25 0 176 8 25 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 4 66 0 31 8 29 0 38 4 66 0 64 4 66 0 72 4 66 0 74 4 66 0 81 6 153 0 88 4 66 0 90 8 33 0 139] 
#[0 4 70 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 8 37 0 10 5 29 0 17 5 37 0 132] 
#[1 0 106 0 55 0 106 0 64 0 106 0 74 0 106 0 86 0 106 0 90 8 41 0 127] 
#[0 4 74 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[0 4 78 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[0 4 82 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[0 4 86 0 56 0 64 0 74 0 88 0 90] 
#[0 8 45 0 10] 
#[0 4 90 0 56 0 64 0 74 0 88 0 90] 
#[0 8 49 0 10] 
#[1 4 94 0 56 4 94 0 64 4 94 0 74 6 153 0 88 4 94 0 90 8 53 0 139] 
#[1 3 153 0 17 3 157 0 52 8 57 0 88 3 165 0 124] 
#[1 4 97 0 64 4 101 0 74 8 61 0 90 4 105 0 113 4 113 0 131] 
#[1 4 97 0 64 4 101 0 74 8 65 0 90 4 105 0 113 4 113 0 131] 
#[0 4 98 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 8 69 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 8 69 0 171 8 69 0 175 8 69 0 176 8 69 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 4 102 0 31 8 73 0 38 4 102 0 64 4 102 0 72 4 102 0 74 4 102 0 81 6 153 0 88 4 102 0 90 8 77 0 139] 
#[0 4 106 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 110 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 8 81 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 8 81 0 171 8 81 0 175 8 81 0 176 8 81 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[0 4 114 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 4 118 0 31 8 85 0 38 4 118 0 64 8 89 0 67 4 118 0 72 4 118 0 74 4 118 0 81 6 153 0 88 4 118 0 90 8 93 0 139] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 8 97 0 114 2 29 0 126 2 37 0 151] 
#[0 4 122 0 56 0 64 0 74 0 88 0 90] 
#[0 4 126 0 56 0 64 0 74 0 88 0 90] 
#[0 4 130 0 56 0 64 0 74 0 90] 
#[1 0 114 0 55 0 114 0 64 0 114 0 74 0 114 0 86 0 114 0 90 8 101 0 112] 
#[0 4 134 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 4 138 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201] 
#[0 4 142 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 8 105 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 8 105 0 171 8 105 0 175 8 105 0 176 8 105 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[0 4 146 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 150 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 8 109 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 8 109 0 171 8 109 0 175 8 109 0 176 8 109 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[1 4 154 0 31 8 113 0 38 4 154 0 64 4 154 0 72 4 154 0 74 4 154 0 81 6 153 0 88 4 154 0 90 8 117 0 139] 
#[0 4 158 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 4 97 0 64 4 101 0 74 8 121 0 90 4 105 0 113 4 113 0 131] 
#[1 0 45 0 55 1 34 0 64 1 34 0 74 0 77 0 86 1 34 0 90 3 65 0 111 8 125 0 114 3 77 0 151] 
#[0 4 162 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 166 0 31 0 64 0 72 0 74 0 81 0 90] 
#[1 1 21 0 1 1 25 0 4 1 29 0 9 1 33 0 14 1 37 0 18 1 41 0 50 1 45 0 59 1 49 0 61 1 53 0 68 1 57 0 69 1 61 0 70 1 65 0 71 1 69 0 78 1 73 0 79 1 77 0 80 1 81 0 83 1 85 0 84 1 89 0 85 1 93 0 88 0 141 0 93 1 97 0 94 0 149 0 95 8 129 0 153 7 169 0 156 1 113 0 157 1 117 0 158 1 121 0 159 1 125 0 160 1 129 0 162 1 133 0 163 1 137 0 164 1 137 0 165 1 137 0 166 1 149 0 167 1 149 0 170 8 129 0 171 8 129 0 175 8 129 0 176 8 129 0 177 1 149 0 178 1 149 0 181 1 149 0 182 1 149 0 183 1 149 0 184 1 149 0 185 1 149 0 186 1 149 0 187 1 149 0 188 1 149 0 189 1 149 0 190 1 149 0 193 1 149 0 196 1 149 0 200] 
#[0 4 170 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 174 0 54 0 55 0 57 0 66 0 71 0 72 0 75 0 76 0 81 0 86 0 90 0 201] 
#[1 4 97 0 64 4 101 0 74 8 133 0 90 4 105 0 113 4 113 0 131] 
#[0 4 178 0 31 0 64 0 72 0 74 0 81 0 90] 
#[0 4 182 0 1 0 2 0 3 0 4 0 5 0 7 0 9 0 10 0 11 0 12 0 14 0 15 0 17 0 18 0 19 0 21 0 22 0 24 0 26 0 27 0 31 0 32 0 33 0 35 0 36 0 37 0 39 0 40 0 42 0 43 0 44 0 45 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 64 0 66 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 78 0 79 0 80 0 81 0 82 0 83 0 84 0 85 0 86 0 88 0 89 0 90 0 93 0 94 0 95 0 201]
	).
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForAssignment1: nodes [
	| result |
	result := WollokAssignmentNode new.
	result variable: (nodes at: 1).
	result operation: (nodes at: 2).
	result value: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForBlockExpression1: nodes [
	| result |
	result := WollokBlockExpressionNode new.
	result leftBraceToken: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result expressions.
	result addTokens: ((nodes at: 2) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForBlockInClosure1: nodes [
	| result |
	result := WollokBlockExpressionNode new.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForBlockInClosure2: nodes [
	| result |
	result := WollokBlockExpressionNode new.
	result addNode: (nodes at: 1) to: result expressions.
	result addNodes: ((nodes at: 2) at: 1) to: result expressions.
	result addTokens: ((nodes at: 2) at: 2) to: result semicolonTokens.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForBlockInClosure3: nodes [
	| result |
	result := WollokBlockExpressionNode new.
	result addNode: (nodes at: 1) to: result expressions.
	result addToken: (nodes at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 3) at: 1) to: result expressions.
	result addTokens: ((nodes at: 3) at: 2) to: result semicolonTokens.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForBooleanLiteral1: nodes [
	| result |
	result := WollokBooleanLiteralNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForCatch1: nodes [
	| result |
	result := WollokCatchNode new.
	result catchToken: (nodes at: 1).
	result exceptionVarName: (nodes at: 2).
	result expression: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForCatch2: nodes [
	| result |
	result := WollokCatchNode new.
	result catchToken: (nodes at: 1).
	result exceptionVarName: (nodes at: 2).
	result colonToken: (nodes at: 3).
	result exceptionType: (nodes at: 4).
	result expression: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForClass1: nodes [
	| result |
	result := WollokClassNode new.
	result classToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result variables.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result addNodes: (nodes at: 5) to: result constructors.
	result addNodes: ((nodes at: 6) at: 1) to: result members.
	result addTokens: ((nodes at: 6) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForClass2: nodes [
	| result |
	result := WollokClassNode new.
	result classToken: (nodes at: 1).
	result name: (nodes at: 2).
	result mixed_withToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result mixins.
	result addTokens: ((nodes at: 5) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result mixins.
	result addTokens: ((nodes at: 5) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 6).
	result addNodes: ((nodes at: 7) at: 1) to: result variables.
	result addTokens: ((nodes at: 7) at: 2) to: result semicolonTokens.
	result addNodes: (nodes at: 8) to: result constructors.
	result addNodes: ((nodes at: 9) at: 1) to: result members.
	result addTokens: ((nodes at: 9) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 10).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForClass3: nodes [
	| result |
	result := WollokClassNode new.
	result classToken: (nodes at: 1).
	result name: (nodes at: 2).
	result inheritsToken: (nodes at: 3).
	result superclass: (nodes at: 4).
	result leftBraceToken: (nodes at: 5).
	result addNodes: ((nodes at: 6) at: 1) to: result variables.
	result addTokens: ((nodes at: 6) at: 2) to: result semicolonTokens.
	result addNodes: (nodes at: 7) to: result constructors.
	result addNodes: ((nodes at: 8) at: 1) to: result members.
	result addTokens: ((nodes at: 8) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 9).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForClass4: nodes [
	| result |
	result := WollokClassNode new.
	result classToken: (nodes at: 1).
	result name: (nodes at: 2).
	result inheritsToken: (nodes at: 3).
	result superclass: (nodes at: 4).
	result mixed_withToken: (nodes at: 5).
	result addNode: (nodes at: 6) to: result mixins.
	result addTokens: ((nodes at: 7) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 7) at: 2) to: result mixins.
	result addTokens: ((nodes at: 7) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 8).
	result addNodes: ((nodes at: 9) at: 1) to: result variables.
	result addTokens: ((nodes at: 9) at: 2) to: result semicolonTokens.
	result addNodes: (nodes at: 10) to: result constructors.
	result addNodes: ((nodes at: 11) at: 1) to: result members.
	result addTokens: ((nodes at: 11) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 12).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForClosure1: nodes [
	| result |
	result := WollokClosureNode new.
	result leftBraceToken: (nodes at: 1).
	result addNode: (nodes at: 2) to: result parameters.
	result addTokens: ((nodes at: 3) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 3) at: 2) to: result parameters.
	result equalGreaterThanToken: (nodes at: 4).
	result expression: (nodes at: 5).
	result rightBraceToken: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForClosure2: nodes [
	| result |
	result := WollokClosureNode new.
	result leftBraceToken: (nodes at: 1).
	result equalGreaterThanToken: (nodes at: 2).
	result expression: (nodes at: 3).
	result rightBraceToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForClosure3: nodes [
	| result |
	result := WollokClosureNode new.
	result leftBraceToken: (nodes at: 1).
	result expression: (nodes at: 2).
	result rightBraceToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor1: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor2: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	result expression: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor3: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	result equalToken: (nodes at: 4).
	result delegatingConstructorCall: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor4: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	result equalToken: (nodes at: 4).
	result delegatingConstructorCall: (nodes at: 5).
	result expression: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor5: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result addNode: (nodes at: 3) to: result parameters.
	result addTokens: ((nodes at: 4) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 4) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor6: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result addNode: (nodes at: 3) to: result parameters.
	result addTokens: ((nodes at: 4) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 4) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 5).
	result expression: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor7: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result addNode: (nodes at: 3) to: result parameters.
	result addTokens: ((nodes at: 4) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 4) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 5).
	result equalToken: (nodes at: 6).
	result delegatingConstructorCall: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructor8: nodes [
	| result |
	result := WollokConstructorNode new.
	result constructorToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result addNode: (nodes at: 3) to: result parameters.
	result addTokens: ((nodes at: 4) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 4) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 5).
	result equalToken: (nodes at: 6).
	result delegatingConstructorCall: (nodes at: 7).
	result expression: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructorCall1: nodes [
	| result |
	result := WollokConstructorCallNode new.
	result newToken: (nodes at: 1).
	result classRef: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result addTokens: ((nodes at: 5) at: 1) to: result withTokens.
	result addTokens: ((nodes at: 5) at: 2) to: result mixins.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructorCall2: nodes [
	| result |
	result := WollokConstructorCallNode new.
	result newToken: (nodes at: 1).
	result classRef: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result argumentList: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	result addTokens: ((nodes at: 6) at: 1) to: result withTokens.
	result addTokens: ((nodes at: 6) at: 2) to: result mixins.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructorCall3: nodes [
	| result |
	result := WollokConstructorCallNode new.
	result newToken: (nodes at: 1).
	result classRef: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForConstructorCall4: nodes [
	| result |
	result := WollokConstructorCallNode new.
	result newToken: (nodes at: 1).
	result classRef: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result argumentList: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForFile1: nodes [
	| result |
	result := WollokFileNode new.
	result addNodes: (nodes at: 1) to: result imports.
	result addNodes: (nodes at: 2) to: result elements.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForFile2: nodes [
	| result |
	result := WollokFileNode new.
	result addNodes: (nodes at: 1) to: result imports.
	result addNodes: (nodes at: 2) to: result elements.
	result main: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForFile3: nodes [
	| result |
	result := WollokFileNode new.
	result addNodes: (nodes at: 1) to: result imports.
	result addNodes: (nodes at: 2) to: result elements.
	result addNodes: ((nodes at: 3) at: 1) to: result tests.
	result addNodes: ((nodes at: 3) at: 2) to: result suites.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForFixture1: nodes [
	| result |
	result := WollokFixtureNode new.
	result fixtureToken: (nodes at: 1).
	result leftBraceToken: (nodes at: 2).
	result addNodes: ((nodes at: 3) at: 1) to: result elements.
	result addTokens: ((nodes at: 3) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForIfExpression1: nodes [
	| result |
	result := WollokIfExpressionNode new.
	result ifToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result condition: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result then: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForIfExpression2: nodes [
	| result |
	result := WollokIfExpressionNode new.
	result ifToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result condition: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result then: (nodes at: 5).
	result elseToken: (nodes at: 6).
	result else: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForImport1: nodes [
	| result |
	result := WollokImportNode new.
	result importToken: (nodes at: 1).
	result importedNamespace: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForImport__import__1: nodes [
	| result |
	result := OrderedCollection new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForImport__import__2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForInitializer1: nodes [
	| result |
	result := WollokInitializerNode new.
	result name: (nodes at: 1).
	result colonEqualToken: (nodes at: 2).
	result value: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForListLiteral1: nodes [
	| result |
	result := WollokListLiteralNode new.
	result leftBracketToken: (nodes at: 1).
	result rightBracketToken: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForListLiteral2: nodes [
	| result |
	result := WollokListLiteralNode new.
	result leftBracketToken: (nodes at: 1).
	result addNode: (nodes at: 2) to: result elements.
	result addTokens: ((nodes at: 3) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 3) at: 2) to: result elements.
	result rightBracketToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMemberFeatureCall2: nodes [
	| result |
	result := WollokMemberFeatureCallNode new.
	result receiver: (nodes at: 1).
	result periodToken: (nodes at: 2).
	result feature: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMemberFeatureCall3: nodes [
	| result |
	result := WollokMemberFeatureCallNode new.
	result receiver: (nodes at: 1).
	result nullSafe: (nodes at: 2).
	result feature: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMemberFeatureCall4: nodes [
	| result |
	result := WollokMemberFeatureCallNode new.
	result receiver: (nodes at: 1).
	result periodToken: (nodes at: 2).
	result feature: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result arguments.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result arguments.
	result rightParenToken: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMemberFeatureCall5: nodes [
	| result |
	result := WollokMemberFeatureCallNode new.
	result receiver: (nodes at: 1).
	result nullSafe: (nodes at: 2).
	result feature: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result arguments.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result arguments.
	result rightParenToken: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMemberFeatureCall6: nodes [
	| result |
	result := WollokMemberFeatureCallNode new.
	result receiver: (nodes at: 1).
	result periodToken: (nodes at: 2).
	result feature: (nodes at: 3).
	result addNode: (nodes at: 4) to: result arguments.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMemberFeatureCall7: nodes [
	| result |
	result := WollokMemberFeatureCallNode new.
	result receiver: (nodes at: 1).
	result nullSafe: (nodes at: 2).
	result feature: (nodes at: 3).
	result addNode: (nodes at: 4) to: result arguments.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration10: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result parameters.
	result addTokens: ((nodes at: 5) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 6).
	result native: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration11: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result parameters.
	result addTokens: ((nodes at: 5) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 6).
	result native: (nodes at: 7).
	result expression: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration12: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result parameters.
	result addTokens: ((nodes at: 5) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 6).
	result native: (nodes at: 7).
	result expressionReturns: (nodes at: 8).
	result expression: (nodes at: 9).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration13: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration14: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	result expression: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration15: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	result expressionReturns: (nodes at: 6).
	result expression: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration16: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	result native: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration17: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	result native: (nodes at: 6).
	result expression: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration18: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result rightParenToken: (nodes at: 5).
	result native: (nodes at: 6).
	result expressionReturns: (nodes at: 7).
	result expression: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration19: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result parameters.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration1: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration20: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result parameters.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 7).
	result expression: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration21: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result parameters.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 7).
	result expressionReturns: (nodes at: 8).
	result expression: (nodes at: 9).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration22: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result parameters.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 7).
	result native: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration23: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result parameters.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 7).
	result native: (nodes at: 8).
	result expression: (nodes at: 9).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration24: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result override: (nodes at: 1).
	result methodToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result parameters.
	result addTokens: ((nodes at: 6) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 7).
	result native: (nodes at: 8).
	result expressionReturns: (nodes at: 9).
	result expression: (nodes at: 10).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration2: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result expression: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration3: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result expressionReturns: (nodes at: 5).
	result expression: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration4: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result native: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration5: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result native: (nodes at: 5).
	result expression: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration6: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	result native: (nodes at: 5).
	result expressionReturns: (nodes at: 6).
	result expression: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration7: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result parameters.
	result addTokens: ((nodes at: 5) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration8: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result parameters.
	result addTokens: ((nodes at: 5) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 6).
	result expression: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMethodDeclaration9: nodes [
	| result |
	result := WollokMethodDeclarationNode new.
	result methodToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result parameters.
	result addTokens: ((nodes at: 5) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result parameters.
	result rightParenToken: (nodes at: 6).
	result expressionReturns: (nodes at: 7).
	result expression: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForMixin1: nodes [
	| result |
	result := WollokMixinNode new.
	result mixinToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result members.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 5) at: 1) to: result members.
	result addTokens: ((nodes at: 5) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNamedArgumentsList1: nodes [
	| result |
	result := WollokNamedArgumentsListNode new.
	result addNode: (nodes at: 1) to: result values.
	result addTokens: ((nodes at: 2) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 2) at: 2) to: result values.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNamedObject1: nodes [
	| result |
	result := WollokNamedObjectNode new.
	result objectToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result variables.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 5) at: 1) to: result members.
	result addTokens: ((nodes at: 5) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNamedObject2: nodes [
	| result |
	result := WollokNamedObjectNode new.
	result objectToken: (nodes at: 1).
	result name: (nodes at: 2).
	result mixed_withToken: (nodes at: 3).
	result addNode: (nodes at: 4) to: result mixins.
	result addTokens: ((nodes at: 5) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 5) at: 2) to: result mixins.
	result addTokens: ((nodes at: 5) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 6).
	result addNodes: ((nodes at: 7) at: 1) to: result variables.
	result addTokens: ((nodes at: 7) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 8) at: 1) to: result members.
	result addTokens: ((nodes at: 8) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 9).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNamedObject3: nodes [
	| result |
	result := WollokNamedObjectNode new.
	result objectToken: (nodes at: 1).
	result name: (nodes at: 2).
	result inheritsToken: (nodes at: 3).
	result superclass: (nodes at: 4).
	result leftBraceToken: (nodes at: 5).
	result addNodes: ((nodes at: 6) at: 1) to: result variables.
	result addTokens: ((nodes at: 6) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 7) at: 1) to: result members.
	result addTokens: ((nodes at: 7) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNamedObject4: nodes [
	| result |
	result := WollokNamedObjectNode new.
	result objectToken: (nodes at: 1).
	result name: (nodes at: 2).
	result inheritsToken: (nodes at: 3).
	result superclass: (nodes at: 4).
	result mixed_withToken: (nodes at: 5).
	result addNode: (nodes at: 6) to: result mixins.
	result addTokens: ((nodes at: 7) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 7) at: 2) to: result mixins.
	result addTokens: ((nodes at: 7) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 8).
	result addNodes: ((nodes at: 9) at: 1) to: result variables.
	result addTokens: ((nodes at: 9) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 10) at: 1) to: result members.
	result addTokens: ((nodes at: 10) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 11).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNamedObject5: nodes [
	| result |
	result := WollokNamedObjectNode new.
	result objectToken: (nodes at: 1).
	result name: (nodes at: 2).
	result inheritsToken: (nodes at: 3).
	result superclass: (nodes at: 4).
	result leftParenToken: (nodes at: 5).
	result parentParameters: (nodes at: 6).
	result rightParenToken: (nodes at: 7).
	result leftBraceToken: (nodes at: 8).
	result addNodes: ((nodes at: 9) at: 1) to: result variables.
	result addTokens: ((nodes at: 9) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 10) at: 1) to: result members.
	result addTokens: ((nodes at: 10) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 11).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNamedObject6: nodes [
	| result |
	result := WollokNamedObjectNode new.
	result objectToken: (nodes at: 1).
	result name: (nodes at: 2).
	result inheritsToken: (nodes at: 3).
	result superclass: (nodes at: 4).
	result leftParenToken: (nodes at: 5).
	result parentParameters: (nodes at: 6).
	result rightParenToken: (nodes at: 7).
	result mixed_withToken: (nodes at: 8).
	result addNode: (nodes at: 9) to: result mixins.
	result addTokens: ((nodes at: 10) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 10) at: 2) to: result mixins.
	result addTokens: ((nodes at: 10) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 11).
	result addNodes: ((nodes at: 12) at: 1) to: result variables.
	result addTokens: ((nodes at: 12) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 13) at: 1) to: result members.
	result addTokens: ((nodes at: 13) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 14).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNullLiteral1: nodes [
	| result |
	result := WollokNullLiteralNode new.
	result nullToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForNumberLiteral1: nodes [
	| result |
	result := WollokNumberLiteralNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForObjectLiteral1: nodes [
	| result |
	result := WollokObjectLiteralNode new.
	result objectToken: (nodes at: 1).
	result leftBraceToken: (nodes at: 2).
	result addNodes: ((nodes at: 3) at: 1) to: result members.
	result addTokens: ((nodes at: 3) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 4) at: 1) to: result members.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForObjectLiteral2: nodes [
	| result |
	result := WollokObjectLiteralNode new.
	result objectToken: (nodes at: 1).
	result mixed_withToken: (nodes at: 2).
	result addNode: (nodes at: 3) to: result mixins.
	result addTokens: ((nodes at: 4) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 4) at: 2) to: result mixins.
	result addTokens: ((nodes at: 4) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 5).
	result addNodes: ((nodes at: 6) at: 1) to: result members.
	result addTokens: ((nodes at: 6) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 7) at: 1) to: result members.
	result addTokens: ((nodes at: 7) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForObjectLiteral3: nodes [
	| result |
	result := WollokObjectLiteralNode new.
	result objectToken: (nodes at: 1).
	result inheritsToken: (nodes at: 2).
	result superclass: (nodes at: 3).
	result leftBraceToken: (nodes at: 4).
	result addNodes: ((nodes at: 5) at: 1) to: result members.
	result addTokens: ((nodes at: 5) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 6) at: 1) to: result members.
	result addTokens: ((nodes at: 6) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForObjectLiteral4: nodes [
	| result |
	result := WollokObjectLiteralNode new.
	result objectToken: (nodes at: 1).
	result inheritsToken: (nodes at: 2).
	result superclass: (nodes at: 3).
	result mixed_withToken: (nodes at: 4).
	result addNode: (nodes at: 5) to: result mixins.
	result addTokens: ((nodes at: 6) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 6) at: 2) to: result mixins.
	result addTokens: ((nodes at: 6) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 7).
	result addNodes: ((nodes at: 8) at: 1) to: result members.
	result addTokens: ((nodes at: 8) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 9) at: 1) to: result members.
	result addTokens: ((nodes at: 9) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 10).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForObjectLiteral5: nodes [
	| result |
	result := WollokObjectLiteralNode new.
	result objectToken: (nodes at: 1).
	result inheritsToken: (nodes at: 2).
	result superclass: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result superclassParameters: (nodes at: 5).
	result rightParenToken: (nodes at: 6).
	result leftBraceToken: (nodes at: 7).
	result addNodes: ((nodes at: 8) at: 1) to: result members.
	result addTokens: ((nodes at: 8) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 9) at: 1) to: result members.
	result addTokens: ((nodes at: 9) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 10).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForObjectLiteral6: nodes [
	| result |
	result := WollokObjectLiteralNode new.
	result objectToken: (nodes at: 1).
	result inheritsToken: (nodes at: 2).
	result superclass: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result superclassParameters: (nodes at: 5).
	result rightParenToken: (nodes at: 6).
	result mixed_withToken: (nodes at: 7).
	result addNode: (nodes at: 8) to: result mixins.
	result addTokens: ((nodes at: 9) at: 1) to: result andTokens.
	result addNodes: ((nodes at: 9) at: 2) to: result mixins.
	result addTokens: ((nodes at: 9) at: 3) to: result commaTokens.
	result leftBraceToken: (nodes at: 10).
	result addNodes: ((nodes at: 11) at: 1) to: result members.
	result addTokens: ((nodes at: 11) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 12) at: 1) to: result members.
	result addTokens: ((nodes at: 12) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 13).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForOrExpression3: nodes [
	| result |
	result := WollokBinaryOperationNode new.
	result leftOperand: (nodes at: 1).
	result operation: (nodes at: 2).
	result rightOperand: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForPackage1: nodes [
	| result |
	result := WollokPackageNode new.
	result packageToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: (nodes at: 4) to: result elements.
	result rightBraceToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForParameter1: nodes [
	| result |
	result := WollokParameterNode new.
	result parameter: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForParameter2: nodes [
	| result |
	result := WollokParameterNode new.
	result parameter: (nodes at: 1).
	result isVarArg: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForPositionalArgumentsList1: nodes [
	| result |
	result := WollokPositionalArgumentsListNode new.
	result addNode: (nodes at: 1) to: result values.
	result addTokens: ((nodes at: 2) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 2) at: 2) to: result values.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForPostfixOperation2: nodes [
	| result |
	result := WollokPostfixOperationNode new.
	result operand: (nodes at: 1).
	result operation: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForPrimaryExpression4: nodes [
	| result |
	result := WollokParenthesizedExpressionNode new.
	result leftParenToken: (nodes at: 1).
	result expression: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForProgram1: nodes [
	| result |
	result := WollokProgramNode new.
	result programToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result elements.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForQualifiedName1: nodes [
	| result |
	result := WollokQualifiedNameNode new.
	result addToken: (nodes at: 1) to: result identifiers.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForQualifiedName2: nodes [
	| result |
	result := nodes at: 1.
	result addToken: (nodes at: 2) to: result periodTokens.
	result addToken: (nodes at: 3) to: result identifiers.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForQualifiedNameWithWildcard1: nodes [
	| result |
	result := WollokQualifiedNameWithWildcardNode new.
	result qualifiedName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForQualifiedNameWithWildcard2: nodes [
	| result |
	result := WollokQualifiedNameWithWildcardNode new.
	result qualifiedName: (nodes at: 1).
	result hasAsterisk: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForReturnExpression1: nodes [
	| result |
	result := WollokReturnExpressionNode new.
	result returnToken: (nodes at: 1).
	result expression: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSelf1: nodes [
	| result |
	result := WollokSelfNode new.
	result selfToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSelfDelegatingConstructorCall1: nodes [
	| result |
	result := WollokSelfDelegatingConstructorCallNode new.
	result selfToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSelfDelegatingConstructorCall2: nodes [
	| result |
	result := WollokSelfDelegatingConstructorCallNode new.
	result selfToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result argumentList: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSetLiteral1: nodes [
	| result |
	result := WollokSetLiteralNode new.
	result _LeftBraceToken: (nodes at: 1).
	result rightBraceToken: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSetLiteral2: nodes [
	| result |
	result := WollokSetLiteralNode new.
	result _LeftBraceToken: (nodes at: 1).
	result addNode: (nodes at: 2) to: result elements.
	result addTokens: ((nodes at: 3) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 3) at: 2) to: result elements.
	result rightBraceToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForStringLiteral1: nodes [
	| result |
	result := WollokStringLiteralNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSuite1: nodes [
	| result |
	result := WollokSuiteNode new.
	result describeToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result members.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result addNodes: ((nodes at: 5) at: 1) to: result members.
	result addTokens: ((nodes at: 5) at: 2) to: result semicolonTokens.
	result addNodes: (nodes at: 6) to: result tests.
	result rightBraceToken: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSuite2: nodes [
	| result |
	result := WollokSuiteNode new.
	result describeToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result members.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result fixture: (nodes at: 5).
	result addNodes: ((nodes at: 6) at: 1) to: result members.
	result addTokens: ((nodes at: 6) at: 2) to: result semicolonTokens.
	result addNodes: (nodes at: 7) to: result tests.
	result rightBraceToken: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSuperDelegatingConstructorCall1: nodes [
	| result |
	result := WollokSuperDelegatingConstructorCallNode new.
	result superToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSuperDelegatingConstructorCall2: nodes [
	| result |
	result := WollokSuperDelegatingConstructorCallNode new.
	result superToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result argumentList: (nodes at: 3).
	result rightParenToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSuperInvocation1: nodes [
	| result |
	result := WollokSuperInvocationNode new.
	result superToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForSuperInvocation2: nodes [
	| result |
	result := WollokSuperInvocationNode new.
	result superToken: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result addNode: (nodes at: 3) to: result arguments.
	result addTokens: ((nodes at: 4) at: 1) to: result commaTokens.
	result addNodes: ((nodes at: 4) at: 2) to: result arguments.
	result rightParenToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForTest1: nodes [
	| result |
	result := WollokTestNode new.
	result testToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftBraceToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result elements.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForTest2: nodes [
	| result |
	result := WollokTestNode new.
	result only: (nodes at: 1).
	result testToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftBraceToken: (nodes at: 4).
	result addNodes: ((nodes at: 5) at: 1) to: result elements.
	result addTokens: ((nodes at: 5) at: 2) to: result semicolonTokens.
	result rightBraceToken: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForThrow1: nodes [
	| result |
	result := WollokThrowNode new.
	result throwToken: (nodes at: 1).
	result exception: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForTry1: nodes [
	| result |
	result := WollokTryNode new.
	result tryToken: (nodes at: 1).
	result expression: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result catchBlocks.
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForTry2: nodes [
	| result |
	result := WollokTryNode new.
	result tryToken: (nodes at: 1).
	result expression: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result catchBlocks.
	result then_alwaysToken: (nodes at: 4).
	result alwaysExpression: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForUnaryOperation3: nodes [
	| result |
	result := WollokUnaryOperationNode new.
	result operation: (nodes at: 1).
	result rightOperand: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariable1: nodes [
	| result |
	result := WollokVariableNode new.
	result name: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration1: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result writable: (nodes at: 1).
	result variable: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration2: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result writable: (nodes at: 1).
	result variable: (nodes at: 2).
	result equalToken: (nodes at: 3).
	result right: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration3: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result writable: (nodes at: 1).
	result property: (nodes at: 2).
	result variable: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration4: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result writable: (nodes at: 1).
	result property: (nodes at: 2).
	result variable: (nodes at: 3).
	result equalToken: (nodes at: 4).
	result right: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration5: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result constToken: (nodes at: 1).
	result variable: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration6: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result constToken: (nodes at: 1).
	result variable: (nodes at: 2).
	result equalToken: (nodes at: 3).
	result right: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration7: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result constToken: (nodes at: 1).
	result property: (nodes at: 2).
	result variable: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionForVariableDeclaration8: nodes [
	| result |
	result := WollokVariableDeclarationNode new.
	result constToken: (nodes at: 1).
	result property: (nodes at: 2).
	result variable: (nodes at: 3).
	result equalToken: (nodes at: 4).
	result right: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor_Test__test_____Suite__suite__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor_Test__test_____Suite__suite__2: nodes [
	| result |
	result := Array new: 2.
	result at: 2 put: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor_Test__test_____Suite__suite___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: ((nodes at: 1) at: 1) to: (result at: 1).
	self add: ((nodes at: 1) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor_Test__test_____Suite__suite___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor_VariableDeclaration__variable_______2: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor_VariableDeclaration__variable________1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor___and________QualifiedName__mixin__1: nodes [
	| result |
	result := Array new: 3.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor___and________QualifiedName__mixin__2: nodes [
	| result |
	result := Array new: 3.
	result at: 3 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor___and________QualifiedName__mixin___1: nodes [
	| result |
	result := Array new: 3.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	result at: 3 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
WollokParser >> reduceActionFor___and________QualifiedName__mixin___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	self add: ((nodes at: 2) at: 3) to: (result at: 3).
	^ result
]
