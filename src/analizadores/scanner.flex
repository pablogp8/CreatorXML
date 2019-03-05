package analizadores;

import java_cup.runtime.*;
import javax.swing.*;
import java.util.*;
import creatorxml.*;
%%

%state COMENT, COMENT2, IMPTR, IMPTR2
%class scanner
%{String literal;
  String temp_include;

%}
%{
int columna=1;
%}
%public
%cup
%line
%full
%unicode
%ignorecase
%char

%{
  public String sourceFilename;
 StringBuffer string = new StringBuffer();
  int ultimoEstado = 0;
 public void init(){};
%}

%eofval{
{return new Symbol(sym.EOF, null); }
%eofval}

Num=[0-9][0-9]*
Decim=Num(.)Num
ID=[A-Za-z]([A-Za-z]|Num|(_))*
DIRE=(".")((\/)*((_)|([A-Za-z]|[0-9][0-9]*))+)+(".")[A-Za-z]+([A-Za-z]|[0-9][0-9])*
ALPHA_NUMERIC={ALPHA}|{DIGITO}
MAIL=ID("@")ID(".")("com")
NLinea=(\n|\r)
Espacio=([\ |\t|\f])
FinL = \r|\n|\r\n
Entrada = [^\r\n]
st = [^\\\n\"]+ | [\\][\\] | "\\\"" | "\\\'" |"\\t"| "\\n" | "\\r" |"\\b" |"\n"


//FRASE=("_"|{ALPHA_NUMERIC})("_"|{ALPHA_NUMERIC})*

%%


[ \t\f] { /* ignore white space. */ }

\' { /* ignore apostrofos. */ } 
<YYINITIAL>"#$"	{  yybegin(COMENT); System.out.println("comentario multilinea: "+yytext());}
<YYINITIAL>"##"	{  yybegin(COMENT2); System.out.println("comentario una linea: "+yytext());}
\"[^\"]*\" 		{ System.out.println("encont: "+yytext().replaceAll("\"", ""));return new Symbol(sym.txtcom, yyline, yychar,  yytext().replaceAll("\"","")); }
<YYINITIAL> {Espacio}  {/*no hace nada, aumenta una columna*/yychar++; }
<YYINITIAL> {NLinea}     {yychar=0; yyline=0;}
<YYINITIAL>{Num}  	{      System.out.println("numero: "+ yytext()); return new Symbol(sym.num, yyline, yychar,  Integer.parseInt(yytext()));}
<YYINITIAL>","          {  System.out.println("Etiqueta coma"); return new Symbol(sym.coma, yyline, yychar,  yytext());}

<YYINITIAL>"<Importar>"   { yybegin(IMPTR); System.out.println("Etiqueta importar"); return new Symbol(sym.importa, yyline, yychar,  yytext());}

<IMPTR>"<"      { yybegin(IMPTR2); System.out.println("  ENTRO AL Fin Etiqueta importar"); return new Symbol(sym.fimporta, yyline, yychar,  yytext());}
<IMPTR>[^"<"]*	{System.out.println("  DIRECCION: " + yytext());return new Symbol(sym.direcc, yyline, yychar,  yytext());}
<IMPTR2>"/Importar>"    { yybegin(YYINITIAL); System.out.println("    Fin Etiqueta importar"); }
<IMPTR2>[^"/Importar>"]* {System.out.println("    HAY ALGO MAS DE FIN");}

<COMENT>"$#"		{yybegin(YYINITIAL); System.out.println("  Fin comentario multilinea");}
<COMENT>[^"$#"]*	{System.out.println("  Comentario: " + yytext());}
<COMENT2>{NLinea}	{yybegin(YYINITIAL); System.out.println("  Fin comentario una linea");}
<COMENT2>[^\n]*	{System.out.println("  Comentario UNA LINEA: " + yytext());}
.		        {
              System.out.println("error lexico en la fila "+yyline +" y en la columna " + yytext());
//interfaz.rotular("error lexico :"+  yytext()+" en la fila "+yyline +" y en la columna " + yychar);

	          	}