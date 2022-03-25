// Grammaire du langage PROJET
// CMPL L3info 
// Nathalie Girard, Anne Grazon, Veronique Masson
// il convient d'y inserer les appels a {PtGen.pt(k);}
// relancer Antlr apres chaque modification et raffraichir le projet Eclipse le cas echeant

// attention l'analyse est poursuivie apres erreur si l'on supprime la clause rulecatch

grammar projet;

options {
  language=Java; k=1;
 }

@header {           
import java.io.IOException;
import java.io.DataInputStream;
import java.io.FileInputStream;
} 


// partie syntaxique :  description de la grammaire //
// les non-terminaux doivent commencer par une minuscule


@members {

 
// variables globales et methodes utiles a placer ici
  
}
// la directive rulecatch permet d'interrompre l'analyse a la premiere erreur de syntaxe
@rulecatch {
catch (RecognitionException e) {reportError (e) ; throw e ; }}


unite  :   unitprog  EOF
      |    unitmodule  EOF
  ;
  
unitprog
  : 'programme' ident ':'  
     declarations  
     corps { System.out.println("succes, arret de la compilation "); }
  ;
  
unitmodule
  : 'module' ident ':' 
     declarations   
  ;
  
declarations
  : partiedef? partieref? consts? vars? decprocs? 
  ;
  
partiedef
  : 'def' ident  (',' ident )* ptvg
  ;
  
partieref: 'ref'  specif (',' specif)* ptvg
  ;
  
specif  : ident  ( 'fixe' '(' type  ( ',' type  )* ')' )? 
                 ( 'mod'  '(' type  ( ',' type  )* ')' )? 
  ;
  
consts  : 'const' ( ident  '=' valeur {PtGen.pt(16);}   ptvg  )+ 
  ;
  
vars  : 'var' ( type ident {PtGen.pt(17);}  ( ','  ident {PtGen.pt(17);} )* ptvg  )+ {PtGen.pt(18);}
  ;
  
type  : 'ent'  {PtGen.pt(70);}
  |     'bool' {PtGen.pt(80);}
  ;
  
decprocs: (decproc ptvg)+
  ;
  
decproc :  'proc'  ident  parfixe? parmod? consts? vars? corps 
  ;
  
ptvg  : ';'
  | 
  ;
  
corps : 'debut' instructions 'fin' {PtGen.pt(255);}
  ;
  
parfixe: 'fixe' '(' pf ( ';' pf)* ')'
  ;
  
pf  : type ident  ( ',' ident  )*  
  ;

parmod  : 'mod' '(' pm ( ';' pm)* ')'
  ;
  
pm  : type ident  ( ',' ident  )*
  ;
  
instructions
  : instruction ( ';' instruction)*
  ;
  
instruction
  : inssi
  | inscond
  | boucle
  | lecture
  | ecriture
  | affouappel
  |
  ;
  
inssi : 'si' expression {PtGen.pt(110);} 'alors' instructions ('sinon'  instructions  {PtGen.pt(111);} )? 'fsi' {PtGen.pt(200);}
  ;
  
inscond : 'cond' {PtGen.pt(312);} expression {PtGen.pt(110);} ':' instructions {PtGen.pt(111);}
          (','  expression {PtGen.pt(110);} ':' instructions {PtGen.pt(111);})* 
          ('aut'  instructions |  ) 
          'fcond' {PtGen.pt(200);}
  ;
  
boucle  : 'ttq' {PtGen.pt(312);} expression {PtGen.pt(310);}'faire' instructions 'fait' {PtGen.pt(300);}
  ;
  
lecture: 'lire' '(' ident {PtGen.pt(100);} ( ',' ident {PtGen.pt(100);} )* ')' 
  ;
  
ecriture: 'ecrire' '(' expression {PtGen.pt(101);} ( ',' expression {PtGen.pt(101);} )* ')'
   ;
  
affouappel
  : ident  (    ':=' expression {PtGen.pt(15);}
            |   (effixes (effmods)?)?  
           )
  ;
  
effixes : '(' (expression  (',' expression  )*)? ')'
  ;
  
effmods :'(' (ident  (',' ident  )*)? ')'
  ; 
  
expression: (exp1) ('ou'  exp1 {PtGen.pt(13);} )*
  ; 
  
exp1  : exp2 ('et'  exp2 {PtGen.pt(12);} )*
  ;
  
exp2  : 'non' exp2  {PtGen.pt(11);}
  | exp3  
  ;
  
exp3  : exp4  
  ({PtGen.pt(20);} '='   exp4 {PtGen.pt(21);}
  |{PtGen.pt(20);} '<>'  exp4 {PtGen.pt(22);}
  |{PtGen.pt(20);} '>'   exp4 {PtGen.pt(23);}
  |{PtGen.pt(20);} '>='  exp4 {PtGen.pt(24);}
  |{PtGen.pt(20);} '<'   exp4 {PtGen.pt(25);}
  |{PtGen.pt(20);} '<='  exp4 {PtGen.pt(26);}
  ) ?
  ;
  
exp4  : exp5 
        ({PtGen.pt(20);}'+'  exp5 {PtGen.pt(1);}
        |{PtGen.pt(20);}'-'  exp5 {PtGen.pt(2);}
        )*
  ;
  
exp5  : primaire 
        (    '*'   primaire  {PtGen.pt(3);}
          | 'div'  primaire  {PtGen.pt(4);}
        )*
  ;
  
primaire: valeur {PtGen.pt(10);}
  | ident {PtGen.pt(14);}
  | '(' expression ')'
  ;
  
valeur  : nbentier {PtGen.pt(7);}
  | '+' nbentier {PtGen.pt(7); }
  | '-' nbentier {PtGen.pt(6); }
  | 'vrai' {PtGen.pt(8); }
  | 'faux' {PtGen.pt(9); }
  ;

// partie lexicale  : cette partie ne doit pas etre modifiee  //
// les unites lexicales de ANTLR doivent commencer par une majuscule
// Attention : ANTLR n'autorise pas certains traitements sur les unites lexicales, 
// il est alors ncessaire de passer par un non-terminal intermediaire 
// exemple : pour l'unit lexicale INT, le non-terminal nbentier a du etre introduit
 
      
nbentier  :   INT { UtilLex.valEnt = Integer.parseInt($INT.text);}; // mise a jour de valEnt

ident : ID  { UtilLex.traiterId($ID.text); } ; // mise a jour de numIdCourant
     // tous les identificateurs seront places dans la table des identificateurs, y compris le nom du programme ou module
     // (NB: la table des symboles n'est pas geree au niveau lexical mais au niveau du compilateur)
        
  
ID  :   ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9'|'_')* ; 
     
// zone purement lexicale //

INT :   '0'..'9'+ ;
WS  :   (' '|'\t' |'\r')+ {skip();} ; // definition des "blocs d'espaces"
RC  :   ('\n') {UtilLex.incrementeLigne(); skip() ;} ; // definition d'un unique "passage a la ligne" et comptage des numeros de lignes

COMMENT
  :  '\{' (.)* '\}' {skip();}   // toute suite de caracteres entouree d'accolades est un commentaire
  |  '#' ~( '\r' | '\n' )* {skip();}  // tout ce qui suit un caractere diese sur une ligne est un commentaire
  ;

// commentaires sur plusieurs lignes
ML_COMMENT    :   '/*' (options {greedy=false;} : .)* '*/' {$channel=HIDDEN;}
    ;	   



	   
