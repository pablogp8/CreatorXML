package analizadores;

import java_cup.runtime.*;
import javax.swing.*;
import java.util.*;
import creatorxml.*;
%%

%state COMENT, COMENT2, IMPTR, IMPTR2, ETIQ
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
<YYINITIAL> {Espacio}   {/*no hace nada, aumenta una columna*/yychar++; }
<YYINITIAL> {NLinea}    {yychar=0; yyline=0;}
<YYINITIAL>{Num}  	{      System.out.println("numero: "+ yytext()); return new Symbol(sym.num, yyline, yychar,  Integer.parseInt(yytext()));}
<YYINITIAL>","          {  System.out.println("Etiqueta coma"); return new Symbol(sym.coma, yyline, yychar,  yytext());}
<YYINITIAL>"<"          {yybegin(ETIQ); System.out.println("APERTURA"); return new Symbol(sym.ietiqueta, yyline, yychar,  yytext());}
<YYINITIAL>"<Importar>" { yybegin(IMPTR); System.out.println("Etiqueta importar"); return new Symbol(sym.importa, yyline, yychar,  yytext());}
<YYINITIAL>"</ventana>" { yybegin(IMPTR); System.out.println("Etiqueta FIN VENTANA"); return new Symbol(sym.eventanaf, yyline, yychar,  yytext());}

<ETIQ>\"[^\"]*\"        { System.out.println(" encont: "+yytext().replaceAll("\"", ""));return new Symbol(sym.txtcom, yyline, yychar,  yytext().replaceAll("\"","")); }
<ETIQ>"Ventana"         {System.out.println(" Etiqueta Ventana"); return new Symbol(sym.eventana, yyline, yychar,  yytext());}
<ETIQ>">"               {yybegin(YYINITIAL); System.out.println(" fin etiqueta"); return new Symbol(sym.fetiqueta, yyline, yychar,  yytext());}
<ETIQ>"id"              {System.out.println(" Etiqueta id"); return new Symbol(sym.eid, yyline, yychar,  yytext());}
<ETIQ>"tipo"            {System.out.println(" Etiqueta tipo"); return new Symbol(sym.etipo, yyline, yychar,  yytext());}
<ETIQ>"="               {System.out.println(" Etiqueta asigna"); return new Symbol(sym.asigna, yyline, yychar,  yytext());}
<ETIQ>"color"           {System.out.println(" Etiqueta color"); return new Symbol(sym.ecolor, yyline, yychar,  yytext());}
<ETIQ>"accionInicial"   {System.out.println(" Etiqueta Accion Inicial"); return new Symbol(sym.eaccioni, yyline, yychar,  yytext());}
<ETIQ>"accionFinal"     {System.out.println(" Etiqueta Accion final"); return new Symbol(sym.eaccionf, yyline, yychar,  yytext());}
<ETIQ>"{"[^"}"]*"}"     {System.out.println(" funcion: "+yytext());return new Symbol(sym.funcionn, yyline, yychar,  yytext()); }


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