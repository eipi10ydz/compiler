/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
  if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
    YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;

extern YYSTYPE cool_yylval;

bool ifvalid = false;   /// check whether \0 appears
int layers = 0;     /// the layer of the comment "(* *)"
bool check_length(const char *insert);

/*
 *  Add Your own definitions here
 */

%}

%x string comments line_comments

%option noyywrap

/*
 * Define names for regular expressions here.
 */

digit           [0-9]+
space           [ \n\f\r\t\v]
alphabet        [a-zA-Z]
type_id         [A-Z]+[0-9a-zA-Z_]*
obj_id          [a-z]+[0-9a-zA-Z_]*
newline         [\n]
darrow          =>
assign          <-
lessequal       <=
class           (?i:class)
else            (?i:else)
false           f(?i:alse)
fi              (?i:fi)
if              (?i:if)
in              (?i:in)
inherits        (?i:inherits)
isvoid          (?i:isvoid)
let             (?i:let)
loop            (?i:loop)
pool            (?i:pool)
then            (?i:then)
while           (?i:while)
case            (?i:case)
esac            (?i:esac)
new             (?i:new)
of              (?i:of)
not             (?i:not)
true            t(?i:rue)
comma           [,]
l_bracket       [\(]
r_bracket       [\)]
l_parenthesis   [\{]
r_parenthesis   [\}]
semicolon       [;]
plus            [+]
minus           [-]
multiplication  [\*]
division        [/]
equal           [=]
colon           [:]
dot             [\.]
less            [<]
complement      [~]
at              [@]
%%

 /*
  * Define regular expressions for the tokens of COOL here. Make sure, you
  * handle correctly special cases, like:
  *   - Nested comments
  *   - String constants: They use C like systax and can contain escape
  *     sequences. Escape sequence \c is accepted for all characters c. Except
  *     for \n \t \b \f, the result is c.
  *   - Keywords: They are case-insensitive except for the values true and
  *     false, which must begin with a lower-case letter.
  *   - Multiple-character operators (like <-): The scanner should produce a
  *     single token for every such operator.
  *   - Line counting: You should keep the global variable curr_lineno updated
  *     with the correct line number
  */

\"     { ifvalid = false; string_buf_ptr = string_buf; BEGIN(string); }
"(*"   { layers = 0; ++layers; BEGIN(comments); }
--     { BEGIN(line_comments); }

<line_comments>{
    \n {
        ++curr_lineno;
        BEGIN(INITIAL);
    }
    [^\n]
}

<string>{
    \" {
        BEGIN(INITIAL);
        if(ifvalid)
        {
            cool_yylval.error_msg = "String contains null character.";
            return ERROR;
        }        
        else if (!check_length("\0"))
        {
            cool_yylval.error_msg = "String constant too long";
            return ERROR;
        }
        cool_yylval.symbol = stringtable.add_string(string_buf, MAX_STR_CONST - 1);
        return STR_CONST;
    }

    \n  {
        cool_yylval.error_msg = "Unterminated string constant";
        ++curr_lineno;
        BEGIN(INITIAL);
        return ERROR;
    }

    \0 {
        ifvalid = true;
    }

    \\b     { check_length("\b"); }
    \\t     { check_length("\t"); }
    \\n     { check_length("\n"); }
    \\f     { check_length("\f"); }

    "\\"+\n { check_length(yytext + 1); ++curr_lineno; }

    "\\"+[^\0] { check_length(yytext + 1); }

    "\\" { check_length("\\"); }

    <<EOF>> {
        cool_yylval.error_msg = "EOF in string constant";
        BEGIN(INITIAL);
        return ERROR;
    }

    [^\\\n\"\0] { check_length(yytext); }
}

<comments>{
    "*)"  {
        if (--layers == 0)
        {
            BEGIN(INITIAL);
        }
    }

    "(*"  { ++layers; }

    <<EOF>> {
        cool_yylval.error_msg = "EOF in comment";
        BEGIN(INITIAL);
        return ERROR;
    }

    \n  { ++curr_lineno; }

    [^*\n(]
    "("+[^*]
    "*"+[^)]
}

"*)"                { cool_yylval.error_msg = "Unmatched *)"; return ERROR; }
{newline}           { ++curr_lineno; }
{space}
{darrow}            { return DARROW; }
{lessequal}         { return LE; }
{comma}             { return ','; }
{colon}             { return ':'; }
{semicolon}         { return ';'; }
{at}                { return '@'; }
{complement}        { return '~'; }
{plus}              { return '+'; }
{minus}             { return '-'; }
{multiplication}    { return '*'; }
{division}          { return '/'; }
{equal}             { return '='; }
{l_parenthesis}     { return '{'; }
{r_parenthesis}     { return '}'; }
{l_bracket}         { return '('; }
{r_bracket}         { return ')'; }
{dot}               { return '.'; }
{less}              { return '<'; }
{assign}            { return ASSIGN; }
{class}             { return CLASS; }
{else}              { return ELSE; }
{false}             { cool_yylval.boolean = 0; return BOOL_CONST; }
{fi}                { return FI; }
{if}                { return IF; }
{in}                { return IN; }
{inherits}          { return INHERITS; }
{isvoid}            { return ISVOID; }
{let}               { return LET; }
{loop}              { return LOOP; }
{pool}              { return POOL; }
{then}              { return THEN; }
{while}             { return WHILE; }
{case}              { return CASE; }
{esac}              { return ESAC; }
{new}               { return NEW; }
{of}                { return OF; }
{not}               { return NOT; }
{true}              { cool_yylval.boolean = 1; return BOOL_CONST; }
{type_id}           { cool_yylval.symbol = idtable.add_string(yytext, MAX_STR_CONST - 1); return TYPEID; }
{obj_id}            { cool_yylval.symbol = idtable.add_string(yytext, MAX_STR_CONST - 1); return OBJECTID; }
{digit}             { cool_yylval.symbol = inttable.add_string(yytext, MAX_STR_CONST - 1); return INT_CONST; }
.                   { cool_yylval.error_msg = yytext; return ERROR; }

%%

/**
 *   @brief Concat the string in parameter and string_buf_ptr and store the result in string_buf
 *
 *   @param [in] string to be concated
 *
 *   @retval bool that tells whether the size of the string overflows
 */

bool check_length(const char *insert)
{
    int len = strlen(insert);
    if (!(string_buf_ptr - string_buf + len >= MAX_STR_CONST))
    {
        if (*insert == '\0')
        {
            *string_buf_ptr++ = '\0';
        }
        else
        {
            strncpy(string_buf_ptr, insert, len);
            string_buf_ptr += len;
        }
    }
    else
    {
        string_buf_ptr += len;
        return false;
    }
    return true;
}