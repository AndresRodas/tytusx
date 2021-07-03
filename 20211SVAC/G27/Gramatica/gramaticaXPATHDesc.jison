/* Definición Léxica */
%lex

%options case-insensitive

%%
\s+                                 /* skip whitespace */
/* PALABRAS RESERVADAS */
"last"                     return  'last';
"position"                 return  'position';
"text"                     return  'text';
"ancestor"                 return  'ancestor'; 
"attribute"                return  'attribute'
"child"                    return  'child'
"descendant"               return  'descendant'
"following"                return  'following'
"namespace"                return  'namespace'
"parent"                   return  'parent'
"preceding"                return  'preceding'
"sibling"                  return  'sibling'
"self"                     return  'self'
"node"                     return  'node'
\"[^"]+\"                   yytext = yytext.slice(1,-1); return 'STRING';

/* SIMBOLOS PARA OPERACIONES ARITMÉTICAS */
"+"                         return 'mas';
"-"                         return 'menos';
"*"                         return 'por';
"%"                         return 'mod';
"div"                       return 'div';

/* SIMBOLOS PARA OPERACIONES RELACIONALES */
"<="                        return 'menorigual';
">="                        return 'mayorigual';
"<"                         return 'menor';
">"                         return 'mayor';
"="                         return 'igual';
"=="                        return 'digual';
"!="                        return 'noigual';

"&&"                        return 'and';
"or"                        return 'or';
"!"                         return 'not';

";"                         return 'semicolon';
"("                         return 'parentesisa';
")"                         return 'parentesisc';

"&&"                        return 'and';
"||"                        return 'or';
"!"                         return 'not';
"|"                         return 'union';


"["                         return 'cora';
"]"                         return 'corc';
"."                         return 'punto';
"::"                        return 'ddpuntos';
"@"                         return 'arroba';

/* Number literals */
(([0-9]+"."[0-9]*)|("."[0-9]+))     return 'decimal';
[0-9]+                              return 'entero';
[a-zA-Z0-9_nÑ]+                       return 'nodoid';
\/\/                                return 'ddoble';
\/                                  return 'dsimple';


//error lexico
.                                   {
                                        console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);
                                    }


<<EOF>>                     return 'EOF'

/lex

//SECCION DE IMPORTS


// DEFINIMOS PRESEDENCIA DE OPERADORES
%left 'or'
%left 'and'
%left 'not'
%left 'union'
%left 'igual' 'noigual'
%left 'menor' 'mayor' 'menorigual' 'mayorigual' 
%left 'ddoble' 'dsimple'
%left 'cora' 'corc'
%left 'parentesisa' 'parentesisc'
%left 'por' 'div' 'mod'
%left 'mas' 'menos'

// DEFINIMOS PRODUCCIÓN INICIAL
%start START

%%

/* Definición de la gramática */
START : LISTA_NODOS EOF;

LISTA_NODOS : NODO LISTA_NODOS_PRIMA
;

LISTA_NODOS_PRIMA : OPERADOR NODO LISTA_NODOS_PRIMA
                  |
;

OPERADOR : union
              |or
              |;

NODO : ddoble VALOR_NODO
      |dsimple VALOR_NODO      
      |VALOR_NODO;

VALOR_NODO : nodoid NODO_COMPLEMENTO
            |FUNCION
            |SELECT
            |EJE
            |arroba nodoid NODO_COMPLEMENTO;

NODO_COMPLEMENTO :cora EXPRESION corc    
                 |punto punto               
                 |;

SELECT : ddoble SELECT_ARGUMENTO
        |dsimple SELECT_ARGUMENTO;

SELECT_ARGUMENTO : arroba por
                  |por
                  |punto
                  |punto punto;

EJE: ancestor OR_SELF
       |attribute ddpuntos EJE_COMPLEMENTO
       |child ddpuntos EJE_COMPLEMENTO
       |descendant OR_SELF
       |following SIBLING
       |namespace ddpuntos EJE_COMPLEMENTO
       |parent ddpuntos EJE_COMPLEMENTO
       |preceding SIBLING 
       |self ddpuntos EJE_COMPLEMENTO;

OR_SELF : menos or menos self ddpuntos EJE_COMPLEMENTO
       | ddpuntos EJE_COMPLEMENTO;

SIBLING : menos sibling ddpuntos EJE_COMPLEMENTO
       | ddpuntos EJE_COMPLEMENTO;

EJE_COMPLEMENTO:  FUNCION
                | nodoid EJE_COMPLEMENTO_2
                | SELECT_ARGUMENTO;

EJE_COMPLEMENTO_2:cora EXPRESION corc
                |;

FUNCION : position parentesisa parentesisc
         |last parentesisa parentesisc
         |text parentesisa parentesisc
         |node parentesisa parentesisc;

EXPRESION : ARITMETICA
            |LOGICA
            |PRIMITIVO             
            |FUNCION;

ARITMETICA : EXPRESION mas EXPRESION
            |EXPRESION menos EXPRESION
            |EXPRESION por EXPRESION
            |EXPRESION div EXPRESION
            |parentesisa EXPRESION parentesisc;
            
PRIMITIVO :  entero
             |decimal
             |nodoid
             |punto
             |STRING
             |arroba nodoid
             |por;

LOGICA : EXPRESION menor  EXPRESION
        |EXPRESION mayor  EXPRESION
        |EXPRESION igual EXPRESION
        |EXPRESION menorigual EXPRESION
        |EXPRESION mayorigual EXPRESION;