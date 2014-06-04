grammar Swift;

// Statements

// GRAMMAR OF A STATEMENT

statement : expression ';'?
 | declaration ';'?
 | loop_statement ';'?
 | branch_statement ';'?
 | labeled_statement
 | control_transfer_statement ';'?
 ;

statements : statement statements? ;

// GRAMMAR OF A LOOP STATEMENT

loop_statement : for_statement
 | for_in_statement
 | while_statement
 | do_while_statement
 ;

// GRAMMAR OF A FOR STATEMENT

for_statement : 'for' for_init?';' expression?';' expression? code_block
 | 'for' ( for_init?';' expression?';' expression?) code_block
 ;
for_init : variable_declaration | expression_list  ;

// GRAMMAR OF A FOR_IN STATEMENT

for_in_statement : 'for' pattern 'in' expression code_block  ;

// GRAMMAR OF A WHILE STATEMENT

while_statement : 'while' while_condition code_block  ;
while_condition : expression | declaration  ;

// GRAMMAR OF A DO_WHILE STATEMENT

do_while_statement : 'do' code_block 'while' while_condition  ;

// GRAMMAR OF A BRANCH STATEMENT

branch_statement : if_statement | switch_statement  ;

// GRAMMAR OF AN IF STATEMENT

if_statement : 'if' if_condition code_block else_clause? ;
if_condition : expression | declaration  ;
else_clause : 'else' code_block | 'else' if_statement  ;

// GRAMMAR OF A SWITCH STATEMENT

switch_statement : 'switch' expression { switch_cases?}  ;
switch_cases : switch_case switch_cases? ;
switch_case : case_label statements | default_label statements  | case_label ';' | default_label ';'  ;
case_label : 'case' case_item_list ':' ;
case_item_list : pattern guard_clause?  pattern guard_clause?',' case_item_list  ;
default_label : 'default' ':' ;
guard_clause : 'where' guard_expression ;
guard_expression : expression  ;

// GRAMMAR OF A LABELED STATEMENT

labeled_statement : statement_label loop_statement | statement_label switch_statement  ;
statement_label : label_name ':' ;
label_name : identifier  ;

// GRAMMAR OF A CONTROL TRANSFER STATEMENT

control_transfer_statement : break_statement
 | continue_statement
 | fallthrough_statement
 | return_statement
 ;

// GRAMMAR OF A BREAK STATEMENT

break_statement : 'break' label_name? ;

// GRAMMAR OF A CONTINUE STATEMENT

continue_statement : 'continue' label_name? ;

// GRAMMAR OF A FALLTHROUGH STATEMENT

fallthrough_statement : 'fallthrough'  ;

// GRAMMAR OF A RETURN STATEMENT

return_statement : 'return' expression? ;

// Generic Parameters and Arguments

// GRAMMAR OF A GENERIC PARAMETER CLAUSE

generic_parameter_clause : '<' generic_parameter_list requirement_clause?'>'  ;
generic_parameter_list : generic_parameter | generic_parameter ',' generic_parameter_list  ;
generic_parameter : type_name | type_name ':' type_identifier | type_name ':' protocol_composition_type  ;
requirement_clause : 'where' requirement_list  ;
requirement_list : requirement | requirement ',' requirement_list  ;
requirement : conformance_requirement | same_type_requirement  ;
conformance_requirement : type_identifier ':' type_identifier | type_identifier ':' protocol_composition_type  ;
same_type_requirement : type_identifier '==' type_identifier  ;

// GRAMMAR OF A GENERIC ARGUMENT CLAUSE

generic_argument_clause : '<' generic_argument_list '>'  ;
generic_argument_list : generic_argument | generic_argument ',' generic_argument_list  ;
generic_argument : type  ;

// Declarations

// GRAMMAR OF A DECLARATION

declaration : import_declaration
 | constant_declaration
 | variable_declaration
 | typealias_declaration
 | function_declaration
 | enum_declaration
 | struct_declaration
 | class_declaration
 | protocol_declaration
 | initializer_declaration
 | deinitializer_declaration
 | extension_declaration
 | subscript_declaration
 | operator_declaration
 ;

declarations : declaration declarations? ;
declaration_specifiers : declaration_specifier declaration_specifiers? ;
declaration_specifier : 'class' | 'mutating' | 'nonmutating' | 'override' | 'static' | 'unowned' | 'unowned(safe)' | 'unowned(unsafe)' | 'weak' ;

// GRAMMAR OF A TOP_LEVEL DECLARATION

top_level_declaration : statements? ;

// GRAMMAR OF A CODE BLOCK

code_block : { statements?}  ;

// GRAMMAR OF AN IMPORT DECLARATION

import_declaration : attributes? 'import' import_kind? import_path  ;
import_kind : 'typealias' | 'struct' | 'class' | 'enum' | 'protocol' | 'var' | 'func'  ;
import_path : import_path_identifier | import_path_identifier . import_path  ;
import_path_identifier : identifier | operator  ;

// GRAMMAR OF A CONSTANT DECLARATION

constant_declaration : attributes? declaration_specifiers? 'let' pattern_initializer_list  ;
pattern_initializer_list : pattern_initializer | pattern_initializer ',' pattern_initializer_list  ;
pattern_initializer : pattern initializer? ;
initializer : '=' expression  ;

// GRAMMAR OF A VARIABLE DECLARATION

variable_declaration : variable_declaration_head pattern_initializer_list
 | variable_declaration_head variable_name type_annotation code_block
 | variable_declaration_head variable_name type_annotation getter_setter_block
 | variable_declaration_head variable_name type_annotation getter_setter_keyword_block
 | variable_declaration_head variable_name type_annotation initializer? willSet_didSet_block
 ;

variable_declaration_head : attributes? declaration_specifiers? 'var'  ;
variable_name : identifier  ;
getter_setter_block : { getter_clause setter_clause?}  | { setter_clause getter_clause }  ;
getter_clause : attributes? get code_block  ;
setter_clause : attributes? set setter_name? code_block  ;
setter_name : ( identifier )  ;
getter_setter_keyword_block : { getter_keyword_clause setter_keyword_clause?} | { setter_keyword_clause getter_keyword_clause }  ;
getter_keyword_clause : attributes? get  ;
setter_keyword_clause : attributes? set  ;
willSet_didSet_block : { willSet_clause didSet_clause?} | { didSet_clause willSet_clause }  ;
willSet_clause : attributes? willSet setter_name? code_block  ;
didSet_clause : attributes? didSet setter_name? code_block  ;

// GRAMMAR OF A TYPE ALIAS DECLARATION

typealias_declaration : typealias_head typealias_assignment  ;
typealias_head : 'typealias' typealias_name  ;
typealias_name : identifier  ;
typealias_assignment : '=' type  ;

// GRAMMAR OF A FUNCTION DECLARATION

function_declaration : function_head function_name generic_parameter_clause? function_signature function_body  ;
function_head : attributes? declaration_specifiers? 'func'  ;
function_name : identifier |  operator  ;
function_signature : parameter_clauses function_result? ;
function_result : '->' attributes? type  ;
function_body : code_block  ;
parameter_clauses : parameter_clause parameter_clauses? ;
parameter_clause : ( ) |  ( parameter_list '...'?)  ;
parameter_list : parameter | parameter ',' parameter_list  ;
parameter : inout? let? '#'? parameter_name local_parameter_name? type_annotation default_argument_clause? ;
parameter : inout? 'var' '#'? parameter_name local_parameter_name? type_annotation default_argument_clause? ;
parameter : attributes? type  ;
parameter_name : identifier | '_'  ;
local_parameter_name : identifier | '_'  ;
default_argument_clause : '=' expression  ;

// GRAMMAR OF AN ENUMERATION DECLARATION

enum_declaration : attributes? union_style_enum | attributes? raw_value_style_enum  ;
union_style_enum : enum_name generic_parameter_clause?{ union_style_enum_members?}  ;
union_style_enum_members : union_style_enum_member union_style_enum_members? ;
union_style_enum_member : declaration | union_style_enum_case_clause  ;
union_style_enum_case_clause : attributes? 'case' union_style_enum_case_list  ;
union_style_enum_case_list : union_style_enum_case | union_style_enum_case ',' union_style_enum_case_list  ;
union_style_enum_case : enum_case_name tuple_type? ;
enum_name : identifier  ;
enum_case_name : identifier  ;
raw_value_style_enum : enum_name generic_parameter_clause? ':' type_identifier { raw_value_style_enum_members?}  ;
raw_value_style_enum_members : raw_value_style_enum_member raw_value_style_enum_members? ;
raw_value_style_enum_member : declaration | raw_value_style_enum_case_clause  ;
raw_value_style_enum_case_clause : attributes? 'case' raw_value_style_enum_case_list  ;
raw_value_style_enum_case_list : raw_value_style_enum_case | raw_value_style_enum_case ',' raw_value_style_enum_case_list  ;
raw_value_style_enum_case : enum_case_name raw_value_assignment? ;
raw_value_assignment : '=' literal  ;

// GRAMMAR OF A STRUCTURE DECLARATION

struct_declaration : attributes? 'struct' struct_name generic_parameter_clause? type_inheritance_clause? struct_body  ;
struct_name : identifier  ;
struct_body : { declarations?}  ;

// GRAMMAR OF A CLASS DECLARATION

class_declaration : attributes? 'class' class_name generic_parameter_clause? type_inheritance_clause? class_body  ;
class_name : identifier  ;
class_body : { declarations?}  ;

// GRAMMAR OF A PROTOCOL DECLARATION

protocol_declaration : attributes? 'protocol' protocol_name type_inheritance_clause? protocol_body  ;
protocol_name : identifier  ;
protocol_body : { protocol_member_declarations?}  ;
protocol_member_declaration : protocol_property_declaration
 | protocol_method_declaration
 | protocol_initializer_declaration
 | protocol_subscript_declaration
 | protocol_associated_type_declaration
 ;
protocol_member_declarations : protocol_member_declaration protocol_member_declarations? ;

// GRAMMAR OF A PROTOCOL PROPERTY DECLARATION

protocol_property_declaration : variable_declaration_head variable_name type_annotation getter_setter_keyword_block  ;

// GRAMMAR OF A PROTOCOL METHOD DECLARATION

protocol_method_declaration : function_head function_name generic_parameter_clause? function_signature  ;

// GRAMMAR OF A PROTOCOL INITIALIZER DECLARATION

protocol_initializer_declaration : initializer_head generic_parameter_clause? parameter_clause  ;

// GRAMMAR OF A PROTOCOL SUBSCRIPT DECLARATION

protocol_subscript_declaration : subscript_head subscript_result getter_setter_keyword_block  ;

// GRAMMAR OF A PROTOCOL ASSOCIATED TYPE DECLARATION

protocol_associated_type_declaration : typealias_head type_inheritance_clause? typealias_assignment? ;

// GRAMMAR OF AN INITIALIZER DECLARATION

initializer_declaration : initializer_head generic_parameter_clause? parameter_clause initializer_body  ;
initializer_head : attributes? convenience? 'init'  ;
initializer_body : code_block  ;

// GRAMMAR OF A DEINITIALIZER DECLARATION

deinitializer_declaration : attributes? 'deinit' code_block  ;

// GRAMMAR OF AN EXTENSION DECLARATION

extension_declaration : 'extension' type_identifier type_inheritance_clause? extension_body  ;
extension_body : { declarations?}  ;

// GRAMMAR OF A SUBSCRIPT DECLARATION

subscript_declaration : subscript_head subscript_result code_block
 | subscript_head subscript_result getter_setter_block
 | subscript_head subscript_result getter_setter_keyword_block
 ;
subscript_head : attributes? 'subscript' parameter_clause  ;
subscript_result : '->' attributes? type  ;

// GRAMMAR OF AN OPERATOR DECLARATION

operator_declaration : prefix_operator_declaration | postfix_operator_declaration | infix_operator_declaration  ;
prefix_operator_declaration : operator prefix operator { }  ;
postfix_operator_declaration : operator postfix operator { }  ;
infix_operator_declaration : operator infix operator { infix_operator_attributes?}  ;
infix_operator_attributes : precedence_clause? associativity_clause? ;
precedence_clause : precedence precedence_level  ;
precedence_level : integer_literal ;
associativity_clause : associativity associativity  ;
associativity : left | right | none  ;

// Patterns


// GRAMMAR OF A PATTERN

pattern : wildcard_pattern type_annotation?
 | identifier_pattern type_annotation?
 | value_binding_pattern
 | tuple_pattern type_annotation?
 | enum_case_pattern
 | type_casting_pattern
 | expression_pattern
 ;

// GRAMMAR OF A WILDCARD PATTERN

wildcard_pattern : '_'  ;

// GRAMMAR OF AN IDENTIFIER PATTERN

identifier_pattern : identifier  ;

// GRAMMAR OF A VALUE_BINDING PATTERN

value_binding_pattern : 'var' pattern | 'let' pattern  ;

// GRAMMAR OF A TUPLE PATTERN

tuple_pattern : ( tuple_pattern_element_list?)  ;
tuple_pattern_element_list : tuple_pattern_element | tuple_pattern_element ',' tuple_pattern_element_list  ;
tuple_pattern_element : pattern  ;

// GRAMMAR OF AN ENUMERATION CASE PATTERN

enum_case_pattern : type_identifier?. enum_case_name tuple_pattern? ;

// GRAMMAR OF A TYPE CASTING PATTERN

type_casting_pattern : is_pattern | as_pattern  ;
is_pattern : 'is' type  ;
as_pattern : pattern 'as' type  ;

// GRAMMAR OF AN EXPRESSION PATTERN

expression_pattern : expression  ;

// Attributes

// GRAMMAR OF AN ATTRIBUTE

attribute : '@' attribute_name attribute_argument_clause? ;
attribute_name : identifier  ;
attribute_argument_clause : '('  balanced_tokens?  ')'  ;
attributes : attribute attributes? ;
balanced_tokens : balanced_token balanced_tokens? ;
balanced_token : '('  balanced_tokens? ')'
 | '[' balanced_tokens?']'
 | { balanced_tokens?}
 | Any identifier | keyword | literal | operator
// | Any punctuation except ( ,  ')' , '[' , ']' , { , or }
 ;

// Expressions


// GRAMMAR OF AN EXPRESSION

expression : prefix_expression binary_expressions? ;
expression_list : expression | expression ',' expression_list  ;

// GRAMMAR OF A PREFIX EXPRESSION

prefix_expression : prefix_operator? postfix_expression
 | in_out_expression
 ;
in_out_expression : '&' identifier ;

// GRAMMAR OF A BINARY EXPRESSION

binary_expression : binary_operator prefix_expression
 | assignment_operator prefix_expression
 | conditional_operator prefix_expression
 | type_casting_operator
 | binary_expression binary_expressions?
 ;

// GRAMMAR OF AN ASSIGNMENT OPERATOR

assignment_operator : '='  ;

// GRAMMAR OF A CONDITIONAL OPERATOR

conditional_operator : '?' expression ':' ;

// GRAMMAR OF A TYPE_CASTING OPERATOR

type_casting_operator : 'is' type | 'as' '?'? type ;

// GRAMMAR OF A PRIMARY EXPRESSION

primary_expression : identifier generic_argument_clause?
 | literal_expression
 | self_expression
 | superclass_expression
 | closure_expression
 | parenthesized_expression
 | implicit_member_expression
 | wildcard_expression
 ;

// GRAMMAR OF A LITERAL EXPRESSION

literal_expression : literal
 | array_literal | dictionary_literal
 | '__FILE__' | '__LINE__' | '__COLUMN__' | '__FUNCTION__'  ;
array_literal : '[' array_literal_items? ']'  ;
array_literal_items : array_literal_item ','?  array_literal_item ',' array_literal_items  ;
array_literal_item : expression  ;
dictionary_literal : '[' dictionary_literal_items ']' | '[' ':' ']'  ;
dictionary_literal_items : dictionary_literal_item ','?  dictionary_literal_item ',' dictionary_literal_items  ;
dictionary_literal_item : expression ':' expression  ;

// GRAMMAR OF A SELF EXPRESSION

self_expression : self
 | 'self' . identifier
 | 'self' '[' expression ']'
 | 'self' . init
 ;

// GRAMMAR OF A SUPERCLASS EXPRESSION

superclass_expression : superclass_method_expression | superclass_subscript_expression  superclass_initializer_expression  ;
superclass_method_expression : 'super' . identifier  ;
superclass_subscript_expression : 'super' '[' expression ']'  ;
superclass_initializer_expression : 'super' . 'init'  ;

// GRAMMAR OF A CLOSURE EXPRESSION

closure_expression : { closure_signature? statements }  ;
closure_signature : parameter_clause function_result? in
 | identifier_list function_result? in
 | capture_list parameter_clause function_result? in
 | capture_list identifier_list function_result? in
 | capture_list in
 ;
capture_list : '[' capture_specifier expression ']'  ;
capture_specifier : weak | unowned | unowned(safe) | unowned(unsafe)  ;

// GRAMMAR OF A IMPLICIT MEMBER EXPRESSION

implicit_member_expression : . identifier  ;

// GRAMMAR OF A PARENTHESIZED EXPRESSION

parenthesized_expression : '('  expression_element_list? ')'  ;
expression_element_list : expression_element | expression_element ',' expression_element_list  ;
expression_element : expression | identifier ':' expression  ;

// GRAMMAR OF A WILDCARD EXPRESSION

wildcard_expression : '_'  ;

// GRAMMAR OF A POSTFIX EXPRESSION

postfix_expression : primary_expression
 | postfix_expression postfix_operator
 | function_call_expression
 | initializer_expression
 | explicit_member_expression
 | postfix_self_expression
 | dynamic_type_expression
 | subscript_expression
 | forced_value_expression
 | optional_chaining_expression
 ;

// GRAMMAR OF A FUNCTION CALL EXPRESSION

function_call_expression : postfix_expression parenthesized_expression
 | postfix_expression parenthesized_expression? trailing_closure
 ;
trailing_closure : closure_expression  ;

// GRAMMAR OF AN INITIALIZER EXPRESSION

initializer_expression : postfix_expression . 'init'  ;

// GRAMMAR OF AN EXPLICIT MEMBER EXPRESSION

explicit_member_expression : postfix_expression . decimal_digit
 | postfix_expression . identifier generic_argument_clause?
 ;

// GRAMMAR OF A SELF EXPRESSION

postfix_self_expression : postfix_expression . 'self' ;

// GRAMMAR OF A DYNAMIC TYPE EXPRESSION

dynamic_type_expression : postfix_expression . 'dynamicType'  ;

// GRAMMAR OF A SUBSCRIPT EXPRESSION

subscript_expression : postfix_expression '[' expression_list ']'  ;

// GRAMMAR OF A FORCED_VALUE EXPRESSION

forced_value_expression : postfix_expression '!'  ;

// GRAMMAR OF AN OPTIONAL_CHAINING EXPRESSION

optional_chaining_expression : postfix_expression ?  ;

// GRAMMAR OF OPERATORS

operator : operator_character operator? ;
Operator_character : [/=\-+!*%<>&|^!.] ;
binary_operator : operator  ;
prefix_operator : operator  ;
postfix_operator : operator  ;

// Types


// GRAMMAR OF A TYPE

type : array_type | function_type | type_identifier | tuple_type | optional_type | implicitly_unwrapped_optional_type | protocol_composition_type | metatype_type  ;

// GRAMMAR OF A TYPE ANNOTATION

type_annotation : ':' attributes? type  ;

// GRAMMAR OF A TYPE IDENTIFIER

type_identifier : type_name generic_argument_clause?  type_name generic_argument_clause?. type_identifier  ;
type_name : identifier  ;

// GRAMMAR OF A TUPLE TYPE

tuple_type : '('  tuple_type_body? ')'  ;
tuple_type_body : tuple_type_element_list '...'? ;
tuple_type_element_list : tuple_type_element | tuple_type_element ',' tuple_type_element_list  ;
tuple_type_element : attributes? inout? type | inout? element_name type_annotation ;
element_name : identifier  ;

// GRAMMAR OF A FUNCTION TYPE

function_type : type '->' type  ;

// GRAMMAR OF AN ARRAY TYPE

array_type : type '[' ']' | array_type '[' ']'  ;

// GRAMMAR OF AN OPTIONAL TYPE

optional_type : type ?  ;

// GRAMMAR OF AN IMPLICITLY UNWRAPPED OPTIONAL TYPE

implicitly_unwrapped_optional_type : type '!'  ;

// GRAMMAR OF A PROTOCOL COMPOSITION TYPE

protocol_composition_type : 'protocol' '<' protocol_identifier_list?'>'  ;
protocol_identifier_list : protocol_identifier | protocol_identifier ',' protocol_identifier_list  ;
protocol_identifier : type_identifier  ;

// GRAMMAR OF A METATYPE TYPE

metatype_type : type . 'Type' | type . Protocol;

// GRAMMAR OF A TYPE INHERITANCE CLAUSE

type_inheritance_clause : ':' type_inheritance_list  ;
type_inheritance_list : type_identifier | type_identifier ',' type_inheritance_list  ;

// ---------- Lexical Structure -----------

// GRAMMAR OF AN IDENTIFIER

Identifier : Identifier_head Identifier_characters?
 | '`' Identifier_head Identifier_characters? '`'
 | Implicit_parameter_name
 | context_sensitive_keywords
 ;

context_sensitive_keywords :
 'associativity' | 'didSet' | 'get' | 'infix' | 'inout' | 'left' | 'mutating' | 'none' | 'nonmutating' | 'operator' | 'override' | 'postfix' | 'precedence' | 'prefix' | 'right' | 'set' | 'unowned' | 'unowned(safe)' | 'unowned(unsafe)' | 'weak' | 'willSet'
 ;

identifier_list : identifier | identifier ',' identifier_list  ;

fragment Identifier_head : [a-zA-Z]
 | '\u00A8' | '\u00AA' | '\u00AD' | '\u00AF' | [\u00B2-\u00B5] | [\u00B7-\u00BA]
 | [\u00BC-\u00BE] | [\u00C0-\u00D6] | [\u00D8-\u00F6] | [\u00F8-\u00FF]
 | [\u0100-\u02FF] | [\u0370-\u167F] | [\u1681-\u180D] | [\u180F-\u1DBF]
 | [\u1E00-\u1FFF]
 | [\u200B-\u200D] | [\u202A-\u202E] | [\u203F-\u2040] | '\u2054' | [\u2060-\u206F] |
 | [\u2070-\u20CF] | [\u2100-\u218F] | [\u2460-\u24FF] | [\u2776-\u2793]
 | [\u2C00-\u2DFF] or [\u2E80-\u2FFF]
 | [\u3004-\u3007] | [\u3021-\u302F] | [\u3031-\u303F] | [\u3040-\uD7FF]
 | [\uF900-\uFD3D] | [\uFD40-\uFDCF] | [\uFDF0-\uFE1F] | [\uFE30-\uFE44]
 | [\uFE47-\uFFFD]
/*
 | U+10000–U+1FFFD | U+20000–U+2FFFD | U+30000–U+3FFFD | U+40000–U+4FFFD
 | U+50000–U+5FFFD | U+60000–U+6FFFD | U+70000–U+7FFFD | U+80000–U+8FFFD
 | U+90000–U+9FFFD | U+A0000–U+AFFFD | U+B0000–U+BFFFD | U+C0000–U+CFFFD
 | U+D0000–U+DFFFD or U+E0000–U+EFFFD
*/
 ;

fragment Identifier_character : [0-9]
 | [\u0300-\u036F] | [\u1DC0-\u1DFF] | [\u20D0-\u20FF] | [\uFE20-\uFE2F]
 | Identifier_head
 ;

fragment Identifier_characters : Identifier_character Identifier_characters? ;

Implicit_parameter_name : '$' Decimal_digits  ;

// GRAMMAR OF A LITERAL

literal : integer_literal | floating_point_literal | string_literal  ;

// GRAMMAR OF AN INTEGER LITERAL

integer_literal : Binary_literal
 | Octal_literal
 | Decimal_literal
 | Hexadecimal_literal
 ;
fragment Binary_literal : '0b' Binary_digit Binary_literal_characters? ;
fragment Binary_digit : [01] ;
fragment Binary_literal_character : Binary_digit | '_'  ;
fragment Binary_literal_characters : Binary_literal_character Binary_literal_characters? ;
Octal_literal : '0o' Octal_digit Octal_literal_characters? ;
fragment Octal_digit : [0-7] ;
fragment Octal_literal_character : Octal_digit | '_'  ;
fragment Octal_literal_characters : Octal_literal_character Octal_literal_characters? ;
Decimal_literal : Decimal_digit Decimal_literal_characters? ;
fragment Decimal_digit : [0-9] ;
fragment Decimal_digits : Decimal_digit Decimal_digits? ;
fragment Decimal_literal_character : Decimal_digit | '_'  ;
fragment Decimal_literal_characters : Decimal_literal_character Decimal_literal_characters? ;
Hexadecimal_literal : '0x' Hexadecimal_digit Hexadecimal_literal_characters? ;
fragment Hexadecimal_digit : [0-9a-fA-F] ;
fragment Hexadecimal_literal_character : Hexadecimal_digit | '_'  ;
fragment Hexadecimal_literal_characters : Hexadecimal_literal_character Hexadecimal_literal_characters? ;

// GRAMMAR OF A FLOATING_POINT LITERAL

Floating_point_literal : Decimal_literal Decimal_fraction? Decimal_exponent?
 | Hexadecimal_literal Hexadecimal_fraction? Hexadecimal_exponent
 ;
fragment Decimal_fraction : '.' Decimal_literal  ;
fragment Decimal_exponent : floating_point_e sign? Decimal_literal  ;
fragment Hexadecimal_fraction : '.' Hexadecimal_literal? ;
fragment Hexadecimal_exponent : floating_point_p sign? Hexadecimal_literal  ;
fragment Floating_point_e : [eE] ;
fragment Floating_point_p : [pP] ;
fragment Sign : [+-] ;

// GRAMMAR OF A STRING LITERAL

String_literal : '"' Quoted_text '"' ;
Quoted_text : Quoted_text_item Quoted_text? ;
Quoted_text_item : Escaped_character | '\\(' expression ')' | ~["\\\u000A\u000D] ;
Escaped_character : '\\' [0\\tnr"']
 | '\\x' Hexadecimal_digit Hexadecimal_digit
 | '\\u' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit
 | '\\U' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit
;

