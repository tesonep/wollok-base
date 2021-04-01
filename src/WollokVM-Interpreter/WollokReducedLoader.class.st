Class {
	#name : #WollokReducedLoader,
	#superclass : #Object,
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokReducedLoader >> addBindingOfClass: aName of: selector in: anInterpreter [

	| anAST aWollokClass |
	
	anAST := WollokParser parse: (self perform: selector).

	aWollokClass := WollokVMClass new
		name: aName;
		ast: anAST;
		yourself.
	
	anInterpreter addBinding: aName value: aWollokClass.
]

{ #category : #'as yet unclassified' }
WollokReducedLoader >> loadInto: anInterpreter [

	self addBindingOfClass: 'wollok.lang.Object' of: #wollokLangObject in: anInterpreter.
	self addBindingOfClass: 'wollok.lang.Number' of: #wollokLangNumber in: anInterpreter.	
	self addBindingOfClass: 'wollok.lang.Boolean' of: #wollokLangBoolean in: anInterpreter.		
]

{ #category : #'as yet unclassified' }
WollokReducedLoader >> wollokLangBoolean [

^ 'class Boolean {

  /**
   * Answers the result of applying the logical AND operator
   * to the specified boolean operands self and other
   */
  method and(other) native

  /** A synonym for and operation */
  method &&(other) native

  /** 
   * Answers the result of applying the logical OR operator
   * to the specified boolean operands self and other
   */
  method or(other) native

  /** A synonym for or operation */
  method ||(other) native

  /** String representation of this boolean value. */
  override method toString() native

  /** 
   * Compares this string to the specified object.
   * The result is true if and only if the
   * argument is not null and represents same value
   * (true or false)
   */
  override method ==(other) native

  /** NOT logical operation */
  method negate() native
}
'
]

{ #category : #'as yet unclassified' }
WollokReducedLoader >> wollokLangNumber [

^ '/**
 *
 * In Wollok we have numbers as an immutable representation. You can customize
 * how many decimals you want to work with, and printing strategies. So
 * number two could be printed as "2", "2,00000", "2,000", etc.
 *
 * Coercing strategy for numbers can be
 * 1) rounding up: 2,3258 using 3 decimals will result in 2,326
 * 2) rounding down or truncation: 2,3258 using 3 decimals will
 *    result in 2,325
 * 3) not allowed: 2,3258 using 3 decimals will throw an exception
 *    since decimals exceeds maximum allowed
 *
 * @author jfernandes
 * @author dodain (unification between Double and Integer in a single Number class)
 *
 * @since 1.3
 * @noInstantiate
 */
class Number {

  /**
   * @private
   *
   * Applies coercing strategy to integer. If it is an integer, nothing happens.
   * Otherwise, if it is a decimal, defined coercing algorithm is applied
   * (see definition of class Number)
   */
  method coerceToInteger() native

  /**
   * @private
   * @see coerceToInteger
   *
   * Applies coercing strategy to integer. And throws exception if it is negative.
   */
  method coerceToPositiveInteger() native

  /**
   * Two references are identical if they are the same number
   */
  override method ===(other) native

  method +(other) native
  method -(other) native
  method *(other) native
  method /(other) native

  /**
   * Integer division between self and other
   *
   * Example:
   *    8.div(3)      ==> Answers 2
   *    15.div(5)     ==> Answers 3
   *    8.2.div(3.3)  ==> Answers 2
   */
  method div(other) {
    return (self / other).truncate(0)
  }

  /**
   * raisedTo operation
   *
   * Example:
   *     3.2 ** 2 ==> Answers 10.24
   *     3 ** 2   ==> Answers 9
   */
  method **(other) native

  /**
   * Answers remainder of division between self and other
   */
  method %(other) native

  /** String representation of self number */
  override method toString() native

  /**
   * Builds a Range between self and end
   *
   * Example:
   *     1..4       Answers ==> a new Range object from 1 to 4
   */
  method ..(end) {
    self.checkNotNull(end, "..")
    return new Range(start = self, end = end)
  }

  method >(other) native
  method <(other) native

  method >=(other) = self > other || self == other
  method <=(other) = self < other || self == other

  /**
   * Answers absolute value of self
   *
   * Example:
   *     2.abs()      ==> 2
   *     (-3).abs()   ==> 3 (be careful with parentheses)
   *     2.7.abs()    ==> Answers 2.7
   *     (-3.2).abs() ==> Answers 3.2 (be careful with parentheses)
   */
  method abs() native

  /**
   * Inverts sign of self
   *
   * Example:
   *     3.invert()      ==> Answers -3
   *     (-2).invert()   ==> Answers 2 (be careful with parentheses)
   *     3.2.invert()    ==> -3.2
   *     (-2.4).invert() ==> 2.4 (be careful with parentheses)
   */
  method invert() native

  /**
   * Answers the greater number between two
   *
   * Example:
   *     5.max(8)    ==> Answers 8
   */
  method max(other) {
    self.checkNotNull(other, "max")
    return if (self >= other) self else other
  }

  /**
    * Answers the lower number between two. @see max
    *
    * Example:
    *     5.min(8)    ==> Answers 5
    */
  method min(other) {
    self.checkNotNull(other, "min")
    return if (self <= other) self else other
  }

  /**
   * Given self and a range of integer values,
   * answers self if it is in that range
   * or nearest value from self to that range
   *
   * Examples
   * 4.limitBetween(2, 10) ==> Answers 4, because 4 is in the range
   * 4.limitBetween(6, 10) ==> Answers 6, because 4 is not in range 6..10, and 6 is nearest value to 4
   * 4.limitBetween(1, 2)  ==> Answers 2, because 4 is not in range 1..2, but 2 is nearest value to 4
   *
   */
  method limitBetween(limitA, limitB) {
    self.checkNotNull(limitA, "limitBetween")
    self.checkNotNull(limitB, "limitBetween")
    return
      if (limitA <= limitB)
        limitA.max(self).min(limitB)
      else
        limitB.max(self).min(limitA)
  }

  /**
   * Answers whether self is between min and max
   *
   * Example:
   *     2.between(2, 3) ==> Answers true
   *     6.between(4, 6) ==> Answers true
   *     3.between(4, 6) ==> Answers false
   */
  method between(min, max) = (self >= min) && (self <= max)

  /** Answers squareRoot of self
   *
   * Example:
   *     9.squareRoot() => Answers 3
   */
  method squareRoot() = self ** 0.5

  /** Answers square of self
   *
   * Example:
   *     3.square() => Answers 9
   */
  method square() = self * self

  /**
   * Answers whether self is an even number
   * (divisible by 2, mathematically 2k).
   *
   * Self must be an integer value
   */
  method even() = self % 2 == 0

  /**
   * Answers whether self is an odd number
   * (not divisible by 2, mathematically 2k + 1).
   *
   * Self must be an integer value
   */
  method odd() {
    if (!self.isInteger()) return false
    return !self.even()
  }

  /** Answers remainder between self and other
   *
   * Example:
   *     5.rem(3)   ==> Answers 2
   *     5.5.rem(3) ==> Answers 2
   */
  method rem(other) {
    self.checkNotNull(other, "rem")
    return self % other
  }

  /*
   * Self as String value. Equivalent: toString()
   */
  method stringValue() = self.toString()

  /**
   * Rounds up self up to a certain amount of decimals.
   * Amount of decimals must be a positive and integer value.
   *
   * Example:
   *     1.223445.roundUp(3)  ==> 1.224
   *     -1.223445.roundUp(3) ==> -1.224
   *     14.6165.roundUp(3)   ==> 14.617
   *     5.roundUp(3)         ==> 5
   */
   method roundUp(_decimals) native

  /**
   * Truncates self up to a certain amount of decimals.
   * Amount of decimals must be a positive and integer value.
   *
   * Example:
   *     1.223445.truncate(3) ==> 1.223
   *     14.6165.truncate(3)  ==> 14.616
   *     -14.6165.truncate(3) ==> -14.616
   *     5.truncate(3)        ==> 5
   */
  method truncate(_decimals) native

  /**
   * Answers a random number between self and max
   */
  method randomUpTo(max) native

  /**
   * Answers the next integer greater than self
   *
   * Example:
   *     13.224.roundUp()  ==> 14
   *     -13.224.roundUp() ==> -14
   *     15.942.roundUp()  ==> 16
   */
  method roundUp() = self.roundUp(0)

  /**
   * greater common divisor.
   * Both self and "other" parameter are coerced to be integer values.
   *
   * Example:
   *     8.gcd(12) ==> Answers 4
   *     5.gcd(10) ==> Answers 5
   */
  method gcd(other) native

  /**
   * least common multiple.
   * Both self and "other" parameter are coerced to be integer values.
   *
   * Example:
   *     3.lcm(4)  ==> Answers 12
   *     6.lcm(12) ==> Answers 12
   */
  method lcm(other) {
    self.checkNotNull(other, "lcm")
    const mcd = self.gcd(other)
    return self * (other / mcd)
  }

  /**
   * Number of digits of self (without sign)
   *
   * Examples:
   *     600.digits()     ==> Answers 3
   *     6.00012.digits() ==> Answers 6
   *     -100.digits()    ==> Answers -3
   */
  method digits() {
    var digits = self.toString().size()
    if (self < 0) {
      digits -= 1
    }
    if (!self.isInteger()) {
      digits -= 1
    }
    return digits
  }

  /**
   * Tells if this number can be considered an integer number.
   *
   * Examples:
   *     2.isInteger()     ==> Answers true
   *     (2.0).isInteger() ==> Answers true
   *     (2.3).isInteger() ==> Answers false
   *
   * This could depend also on the rounding strategy, for example:
   *     (2.0001).isInteger() ==> Answers false if rounding strategy is set to 5 decimal places (default)
   *     (2.0001).isInteger() ==> Answers true if rounding strategy is set to 3 decimal places
   */
  method isInteger() native

  /** 
   * Answers whether self is a prime number,
   * like 2, 3, 5, 7, 11 ...
   * Self must be an integer positive value
   */
  method isPrime() {
    const intValue = self.coerceToInteger()
    if (intValue == 1) return false
    if (intValue == 2) return true
    return (2..(intValue.div(2) + 1)).any({ i => intValue % i == 0 }).negate()
  }

  /**
   * Executes the given action n times (n = self)
   *
   * Self must be a positive integer value.
   * The closure must have one argument (index goes from 1 to self)
   *
   * Example:
   *     4.times({ i => console.println(i) }) ==> Answers
   *       1
   *       2
   *       3
   *       4
   */
  method times(action) {
    self.checkNotNull(action, "times")
    const intValue = self.coerceToInteger()
    if (intValue < 0) self.error("times requires a positive integer number")
    if (intValue > 0) (1..intValue).forEach(action)
  }

  /** Allows users to define a positive number with 1 or +1 */
  method plus() = self
}'
]

{ #category : #'as yet unclassified' }
WollokReducedLoader >> wollokLangObject [

^ 'class Object {

  method initialize() { }

  /** 
   * Answers object identity of a Wollok object, represented by
   * a unique number in Wollok environment
   */
  method identity() native

  /** Object description in english/spanish/... (depending on i18n configuration)
   *
   * Examples:
   *     "2".kindName()  => Answers "a String"
   *    2.kindName()    => Answers "a Integer"
   *
   * @private
   */
  method kindName() native

  /**
   * Full name of Wollok object class
   * @private
   */
  method className() native

  /**
   * Tells whether self object is "equal" to the given object
   *
   * This method implements an equivalence relation on non-null object references:
   *
   * - It is reflexive: for any non-null reference value x, x == x should return true.
   * - It is symmetric: for any non-null reference values x and y, x == y
   *   should return true if and only if y == x returns true.
   * - It is transitive: for any non-null reference values x, y, and z, 
   *   if x == y returns true and y == z returns true, 
   *   then x == z should return true.
   * - It is consistent: for any non-null reference values x and y, multiple invocations
   *   of x == y consistently return true or consistently return false,
   *   provided no information used in equals comparisons on the objects is modified.
   * - For any non-null reference value x, x == null should return false.
   * 
   * The default behavior compares them in terms of identity (===)
   */
  method ==(other) = self === other 
  
  /** Tells whether self object is not equal to the given one */
  method !=(other) = ! (self == other)

  /**
   * Tells whether self object is identical (the same) to the given one.
   * It does it by comparing their identities.
   * So self basically relies on the wollok.lang.Integer equality (which is native)
   */
  method ===(other) = self.identity() == other.identity()

  /**
   * Tells whether self object is not identical (the same) to the given one.
   * @See === message.
   */
  method !==(other) = ! (self === other)

  /**
   * o1.equals(o2) is a synonym for o1 == o2
   */
  method equals(other) = self == other

  /**
   * String representation of Wollok object
   */
  method toString() {
    return self.kindName()
  }

  /**
   * Shows a short, internal representation
   */
  method shortDescription() = self.toString()

  /**
   * Provides a visual representation of Wollok Object
   * By default, same as toString but can be overridden
   * like in String
   */
  method printString() = self.toString()

  /** @private */
  method messageNotUnderstood(messageName, parameters) {
    self.doMessageNotUnderstood(messageName, parameters)
  }

  method doMessageNotUnderstood(messageName, parameters) native
}'
]
