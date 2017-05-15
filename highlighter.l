%{
#include <stdio.h>
FILE *pf;
%}

datatype                                                      "int"|"double"|"float"|"long"|"boolean"|"void"|"char"
data                                                          "static"|"final"
access                                                        "private"|"public"|"protected"
statement                                                     "while"|"do"|"for"|"if"|"else"|"else if"
import                                                        "import"
null                                                          "null"
return                                                        "return"
class                                                         "class"
keyword                                                       ({datatype}|{data}|{access}|{statement}|{import}|{null}|{return}|{class}|"true"|"false"|"super"|"try"|"catch"|"this")
operator                                                      "!"|"+"|"-"|"/"|"*"|"%"|"&"|"|"|"="|"<"|">"|"("|")"|"["|"]"|":"|";"
bracket                                                       "[""]"
digit                                                         [0-9]
capital                                                       [A-Z]
letter                                                        [a-zA-Z]
text                                                          (({digit}|{letter}))*
method                                                        {text}+([.]{text})+
var                                                           {letter}+({text}|[_]{letter})*
constant                                                      {capital}+[_]*{capital}*

%x  I1 DT1 C1 A1 M1

%%
 /* \n, space, <> */
[\n]                                                          {fprintf(pf,"<BR>");}
[ ]                                                           {fprintf(pf,"&nbsp;");}
[\t]                                                          {fprintf(pf,"&nbsp;&nbsp;&nbsp;&nbsp;");}
"<"                                                           {fprintf(pf,"&lt");}
">"                                                           {fprintf(pf,"&gt");}
 /* null, true, false, new, return, 숫자, "string" */
({null}|"true"|"false")                                       {fprintf(pf,"<b><FONT COLOR=\"#663399\">%s</FONT></b>",yytext);}
("new"|"super"|"try"|"catch"|"this"|{return})                 {fprintf(pf,"<b><FONT COLOR=\"#921826\">%s</FONT></b>",yytext);}
({digit}+|{digit}+[.]{digit}*)                                {fprintf(pf,"<FONT COLOR=\"#006600\">%s</FONT>",yytext);}
["][^"]*["] 	                                                {fprintf(pf,"<FONT COLOR=\"#CC9933\">%s</FONT>",yytext);}
 /* 주석 */
"//".*[\n]                                                    {fprintf(pf,"<b><FONT COLOR=\"#669900\">%s</FONT></b><BR>",yytext);}
"/*"([^\*]|\*[^/])*"*/"                                       {fprintf(pf,"<b><FONT COLOR=\"#669900\">%s</FONT></b>",yytext);} 
 /* 모든 글자 */
.                                                             {fprintf(pf,"%s",yytext);}
 /* aa[] or aa() */
{letter}+[ ]*/("[]"|"()")                                     {fprintf(pf,"<b><FONT COLOR=\"#FC0101\">%s</FONT></b>",yytext);}
 /** statement **/
{statement}[ ]*/"("                                           {fprintf(pf,"<b><FONT COLOR=\"#921826\">%s</FONT></b>",yytext);}     
{statement}                                                   {fprintf(pf,"<b><FONT STYLE=\"text-decoration:line-through\">%s</FONT></b>",yytext);}

  /** import **/
{import}                                                      {fprintf(pf,"<b><FONT COLOR=\"#F15F5F\">%s</FONT></b>",yytext);
                                                              BEGIN(I1);}
  /* import fail */           
<I1>[ ]*{keyword}[;]*                                         {fprintf(pf,"<b><FONT STYLE=\"text-decoration:line-through\">%s</FONT></b>",yytext);
                                                              BEGIN(INITIAL);}
  /* import success */            
<I1>[ ]*{text}+({text}|[.]{text})+[;]                         {fprintf(pf,"%s",yytext);
                                                              BEGIN(INITIAL);}                                                 
  /** datatype **/                       
({datatype}|{datatype}[ ]*{bracket}*)                         {fprintf(pf,"<b><FONT COLOR=\"#FC0101\">%s</FONT></b>",yytext);
                                                              BEGIN(DT1);}
  /* datatype fail */     
<DT1>[ ]*({method}|{keyword})                                 {fprintf(pf,"<b><FONT STYLE=\"text-decoration:line-through\">%s</FONT></b>",yytext);
                                                              BEGIN(INITIAL);}
<DT1>[ ]*[0-9]+[^;]*[;]                                       {fprintf(pf,"<b><FONT STYLE=\"text-decoration:line-through\">%s</FONT></b>",yytext);
                                                              BEGIN(INITIAL);}
  /* method */                                                            
<DT1>[ ]*{var}+/"("                                           {fprintf(pf,"<b><FONT COLOR=\"#660066\">%s</FONT></b>",yytext);
                                                              BEGIN(INITIAL);}
  /* variable */
<DT1>[ ]*{var}                                                {fprintf(pf,"%s",yytext);
                                                              BEGIN(INITIAL);}
  /** class **/                      
{class}[ ]                                                    {fprintf(pf,"<b><FONT COLOR=\"#CC0099\">%s</FONT></b>",yytext);
                                                              BEGIN(C1);}
  /* class name error */                                                            
<C1>({class}[ ]|{keyword}|{method})                           {fprintf(pf,"<b><FONT STYLE=\"text-decoration:line-through\">%s</FONT></b>",yytext);
                                                              BEGIN(C1);}
  /* class name */                                                            
<C1>[ ]*{text}+                                               {fprintf(pf,"<b><FONT COLOR=\"#FF9900\">%s</FONT></b>",yytext);
                                                              BEGIN(INITIAL);}
  /** acces & data **/                      
({access}|{data})                                             {fprintf(pf,"<b><FONT COLOR=\"#0054FF\">%s</FONT></b>",yytext);
                                                              BEGIN(A1);}
  /* acces & data fail */                                                          
<A1>[ ]*{access}                                              {fprintf(pf,"<b><FONT STYLE=\"text-decoration:line-through\">%s</FONT></b>",yytext);
                                                              BEGIN(INITIAL);}
  /* access & data success */                                                            
<A1>[ ]*{data}                                                {fprintf(pf,"<b><FONT COLOR=\"#0054FF\">%s</FONT></b>",yytext);
                                                              BEGIN(INITIAL);}
  /* exit */                                                            
<A1>.                                                         {fprintf(pf,"%s",yytext);
                                                              BEGIN(INITIAL);}

%%
main(int argc,char** argv)
{
  if (argc > 0)
  {
    yyin = fopen(argv[1], "r");
  }
  else
  {
    printf("input error !!");
  }

pf = fopen("output.html","wt");

yylex();

fclose(pf);

return 0;
}
