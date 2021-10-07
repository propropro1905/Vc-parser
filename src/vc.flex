
import java_cup.runtime.*;

%%

// Options and declarations

%public // Makes the generated class public (the class is only accessible in its own package by default).
%class VCScanner
%implements sym

%8bit

%line // count lines
%column // count columns

%cup // Inferface with CUP generated parser.

%{
  StringBuilder string = new StringBuilder();

  private Symbol symbol(int type) {
    return new VCSymbol(type, yyline+1, yycolumn+1, yytext());
  }

  private Symbol symbol(int type, Object value) {
    return new VCSymbol(type, yyline+1, yycolumn+1, value, yytext());
  }
%}

// Character set
LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]
InputCharacter = [^\r\n]

// Comments
TraditionalComment = "/*" .* "*/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
Comment = {TraditionalComment} | {EndOfLineComment}

// Identifiers
Letter = [A-Za-z_]
Digit = [0-9]
Identifier = {Letter}({Letter}|{Digit})*

// Literals

// Integer literals
IntLiteral = {Digit}{Digit}*

// Float literals
Exponent = [Ee] [+-]? {Digit}+
Fraction = \. {Digit}+
FloatLiteral = (({Digit}* {Fraction} {Exponent}?)|({Digit}+ \.)|({Digit}+ (\.)? {Exponent}))

// String and character literals
StringCharacter = [^\r\n\"\\]

%state STRING

%%

<YYINITIAL> {
	// Keywords
	"boolean"			{ return symbol(BOOLEAN);}
	"break"				{ return symbol(BREAK);}
	"continue"			{ return symbol(CONTINUE);}
	"else"				{ return symbol(ELSE);}
	"for"				{ return symbol(FOR);}
	"float"				{ return symbol(FLOAT);}
	"if"				{ return symbol(IF);}
	"int"				{ return symbol(INT);}
	"return"			{ return symbol(RETURN);}
	"void"				{ return symbol(VOID);}
	"while"				{ return symbol(WHILE);}

	// Boolean literals
	"true"				{ return symbol(BOOLLITERAL, true);}
	"false"				{ return symbol(BOOLLITERAL, false);}

	// Separators
	"{"					{ return symbol(LBRACE);}
	"}"					{ return symbol(RBRACE);}
	"("					{ return symbol(LPAREN);}
	")"					{ return symbol(RPAREN);}
	"["					{ return symbol(LBRACK);}
	"]"					{ return symbol(RBRACK);}
	";"					{ return symbol(SEMICOLON);}
	","					{ return symbol(COMMA);}

	// Operators
	// Arithmetic Operators
	"+"					{ return symbol(PLUS);}
	"-"					{ return symbol(MINUS);}
	"*"					{ return symbol(MULT);}
	"/"					{ return symbol(DIV);}

	// Relational Operators
	"<"					{ return symbol(LT);}
	"<="				{ return symbol(LTEQ);}
	">"					{ return symbol(GT);}
	">="				{ return symbol(GTEQ);}

	// Equality Operators
	"=="				{ return symbol(EQEQ);}
	"!="				{ return symbol(NOTEQ);}

	// Logical Operators
	"||"				{ return symbol(OROR);}
	"&&"				{ return symbol(ANDAND);}
	"!"					{ return symbol(NOT);}

	// Assignment Operator
	"="					{ return symbol(EQ);}

	// String literal
	\"					{ yybegin(STRING); string.setLength(0);} // String beginning. Switch to STRING state.

	// Numeric literals
	"-2147483648"		{ return symbol(INTLITERAL, Integer.valueOf(Integer.MIN_VALUE));}

	{IntLiteral}		{ return symbol(INTLITERAL, Integer.valueOf(yytext()));}
	{FloatLiteral}		{ return symbol(FLOATLITERAL, new Float(yytext().substring(0, yylength()-1)));}

	// Comments
	{Comment}			{ } // Ignore

	// WhiteSpace
	{WhiteSpace}		{ } // Ignore

	// Identifiers
	{Identifier}		{ return symbol(ID, yytext());}
}

<STRING> {
	\"					{ yybegin(YYINITIAL); return symbol(STRINGLITERAL, string.toString()); } // End of string. Switch back to YYINITIAL state.

	{StringCharacter}+	{ string.append(yytext());}

	// Escape sequences
	"\\b"				{ string.append('\b');}
	"\\f"				{ string.append('\f');}
	"\\n"				{ string.append('\n');}
	"\\r"				{ string.append('\r');}
	"\\'"				{ string.append('\'');}
	"\\\""				{ string.append('\"');}
	"\\\\"				{ string.append('\\');}

	// Error cases
	\\.					{ throw new RuntimeException("Illegal escape sequence \"" + yytext() + "\"");}
	{LineTerminator}	{ throw new RuntimeException("Unterminated character literal at end of line");}
}

// Error fallback
[^]						{ throw new RuntimeException("Illegal character \"" + yytext() + "\" at line " + yyline + ", column " + yycolumn);}
<<EOF>>					{ return symbol(EOF);}