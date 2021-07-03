%{
    
    let listaTokens = [];
    let listaErrores = [];
    let nodoPadre;
    let gramatical = ' ';
    let gramaticapp = ' ';
    let tipoencoding = ' ';    

    let verificarEtiquetas = [];
%}

// ===================================== ANALISIS LEXICO ==============================================
%lex
%options case-sensitive
%%

// EXPRESIONES A OMITIR
\s+                                         %{ /* Omitir espacios en blanco */ %}
[\t\r]+                                     %{ /* Omitir saltos de linea, tabs y retornos*/ %}

// COMENTARIOS <!-------Your comment----->
[<][!][-][-][^>]*[-][-]+[>]                        {}


// PALABRAS RESERVADAS

"<?xml version"                     %{ listaTokens.push(new Token("Palabra_Reservada", yytext, yylloc.first_line, yylloc.first_column)); return "tk_inicio_prologo";%}
"?>"                                %{ listaTokens.push(new Token("Palabra_Reservada", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_fin_prologo';%}
"encoding"                          %{ listaTokens.push(new Token("Palabra_Reservada", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_encoding';%}
"standalone"                        %{ listaTokens.push(new Token("Palabra_Reservada", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_standalone';%}


// SIMBOLOS
"</"                    %{ listaTokens.push(new Token("Abre", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_abre_dos';%}
"/>"                    %{ listaTokens.push(new Token("Cierra", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_cierra_dos';%}
"<"                    %{ listaTokens.push(new Token("Abre", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_abre';%}
">"                    %{ listaTokens.push(new Token("Cierra", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_cierra';%}
"&lt;"                    %{ listaTokens.push(new Token("PPmenor", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_less';%}
"&gt;"                    %{ listaTokens.push(new Token("PPmayor", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_great';%}
"&amp;"                    %{ listaTokens.push(new Token("PPampersand", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_amper';%}
"&apos;"                    %{ listaTokens.push(new Token("PPapostrofe", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_apostro';%}
"&quot;"                    %{ listaTokens.push(new Token("PPcomillas", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_quota';%}

"="                    %{ listaTokens.push(new Token("Igual", yytext, yylloc.first_line, yylloc.first_column)); return 'tk_igual';%}


// EXP.REGULARES
\"([^\\\"]|\\.)*\"                          %{ listaTokens.push(new Token("Cadena", yytext.substr(1, yyleng-2), yylloc.first_line, yylloc.first_column)); return "tk_hilera";%}
<<EOF>>                                     %{ return "EOF"; %}
[a-zA-Z_À-ÿ\u00F1\u00D1]([a-zA-ZÀ-ÿ\-\.\u00F1\u00D10-9_])*                     %{ listaTokens.push(new Token("Etiqueta", yytext, yylloc.first_line, yylloc.first_column)); return "tk_etiqueta";%}
[0-9]+("."[0-9]+)?\b   %{ listaTokens.push(new Token("Numero", yytext, yylloc.first_line, yylloc.first_column)); return "tk_numero";%}


// FIN DEL ARCHIVO
<<EOF>>                                     %{ return "EOF"; %}

// ERRORES LEXICOS
.                                           %{ listaErrores.push(new TokenError("XML",'Error Lexico ' , "Caracter desconocido " + yytext ,  yylloc.first_line, yylloc.first_column )); %}


/lex

// ===================================== ANALISIS SINTACTICO ==============================================


//GRAMATICA RECURSIVA POR LA IZQUIERDA

// DEFINIMOS PRODUCCIÓN INICIAL
// DEFINIMOS PRODUCCIÓN INICIAL
%start INICIO 
%%


/* Definición de la gramática */
INICIO: PROLOGO EOF {
   
    // REPORTE GRAMATICAL

    gramaticapp = `~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\nI   -> P EOF \n` + gramaticapp;
    gramatical = `~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n<INICIO> := <PROLOGO> <EOF> \n` + gramatical;
 
    return {
        "json": $1,
        "gramaticapp": gramaticapp,
        "gramatical": gramatical,
        "listaErrores": listaErrores,
        "tipoencoding": tipoencoding
    };
};

PROLOGO
    : tk_inicio_prologo VERSION CODIFICACION DEPENDENCIA tk_fin_prologo RAIZ {
        $$ = $6;

        // REPORTE GRAMATICAL
        gramaticapp = `PROLOGO.VAL -> prologo.lexval VERSION.VAL CODIFICACION.VAL DEPENDENCIA.VAL prologof.lexval RAIZ.VAL \n` + gramaticapp;
        gramatical = `<PROLOGO> := ${$1} <VERSION> <CODIFICACION> <DEPENDENCIA> ${$5} <RAIZ> \n` + gramatical;
    }
    | RAIZ {
        $$ = $1;

        // REPORTE GRAMATICAL
        gramaticapp = `PROLOGO.VAL -> RAIZ.VAL \n` + gramaticapp;
        gramatical = `<PROLOGO> := <RAIZ> \n` + gramatical;
    }
;

VERSION
    :tk_igual tk_hilera {
        // REPORTE GRAMATICAL
        gramaticapp = `VERSION.VAL -> igual.lexval cadena.lexval \n` + gramaticapp;
        gramatical = `<VERSION> := ${$1} ${$2} \n` + gramatical;
    }
;

CODIFICACION
    :tk_encoding tk_igual tk_hilera {
        // REPORTE GRAMATICAL
        gramaticapp = `CODIFICACION.VAL -> encoding.lexval igual.lexval cadena.lexval \n` + gramaticapp;
        gramatical = `<CODIFICACION> := ${$1} ${$2} ${$3} \n` + gramatical;
        tipoencoding = `${$3}`.replaceAll("\"", ' ');
    }
    | {
        // REPORTE GRAMATICAL
        gramaticapp = `CODIFICACION.VAL -> ε \n` + gramaticapp;
        gramatical = `<CODIFICACION> := ε \n` + gramatical;

    };

DEPENDENCIA
    :tk_standalone tk_igual tk_hilera {
        // REPORTE GRAMATICAL
        gramaticapp = `DEPENDENCIA.VAL -> standalone.lexval igual.lexval cadena.lexval\n` + gramaticapp;
        gramatical = `<DEPENDENCIA> := ${$1} ${$2} ${$3} \n` + gramatical;
    }
    |{
        // REPORTE GRAMATICAL
        gramaticapp = `DEPENDENCIA.VAL -> ε \n` + gramaticapp;
        gramatical = `<DEPENDENCIA> := ε \n` + gramatical;
    };

RAIZ
    :ETIQUETA {
        $$ = $1;

        // CST
        nodoPadre = new Nodo("RAIZ","RAIZ");
        nodoPadre.agregarHijo($1['nodo']);

        $$['nodo'] = nodoPadre;

        // REPORTE GRAMATICAL
        gramaticapp = `RIAZ.VAL -> ETIQUETA.VAL \n` + gramaticapp;
        gramatical = `<RAIZ> := <ETIQUETA> \n` + gramatical;
    }
;

ETIQUETA
    : ETIQUETA_UNICA {
        $$ = $1;

        // CST
        nodoPadre = new Nodo("ETIQUETA","ETIQUETA");
        nodoPadre.agregarHijo($1['nodo']);

        $$['nodo'] = nodoPadre;

        // REPORTE GRAMATICAL
        gramaticapp = `ETIQUETA.VAL -> ETIQUETA_UNICA.VAL\n` + gramaticapp;
        gramatical = `<ETIQUETA> := <ETIQUETA_UNICA> \n` + gramatical;
    }
    | APERTURA CONTENIDO CIERRE {
        $$ = $1;
        $$["texto"] = $2["texto"];
        $$["hijos"] = $2["hijos"];

        // CST
        nodoPadre = new Nodo("ETIQUETA","ETIQUETA");
        nodoPadre.agregarHijo($1['nodo']);

        if($2) {
            nodoPadre.agregarHijo($2['nodo']);
        }

        nodoPadre.agregarHijo($3['nodo']);

        $$['nodo'] = nodoPadre;


        // REPORTE GRAMATICAL
        gramaticapp = `ETIQUETA.VAL -> APERTURA.VAL CONTENIDO.VAL CIERRE.VAL\n` + gramaticapp;
        gramatical = `<ETIQUETA> := <APERTURA> <CONTENIDO> <CIERRE> \n` + gramatical;
    }
        | error tk_cierra
        {
            listaErrores.push(new TokenError("XML",'Este es un error sintáctico: ' , "Me recupero con: " + yytext , @1.first_line, @2.first_column ));
            
        }
;


ETIQUETA_UNICA
    : tk_abre tk_etiqueta ATRIBUTOS tk_cierra_dos {
        $$ = {}
        $$["etiqueta"] = $2;
        $$["tipo"] = "unica";
        $$["atributos"] = [];
        $$["linea"] = @2.first_line;
        $$["columna"] = @2.first_column;    

        // CST
        nodoPadre = new Nodo("ETIQUETA UNICA","ETIQUETA UNICA");
        nodoPadre.agregarHijo(new Nodo("APERTURA", $1));
        nodoPadre.agregarHijo(new Nodo("ETIQUETA", $2));
        if ($3) {
            $$['atributos'] = $3['atributos'];
            nodoPadre.agregarHijo($3['nodo']);
        }
        nodoPadre.agregarHijo(new Nodo("CIERRE", $4));

        $$['nodo'] = nodoPadre;

        // REPORTE GRAMATICAL
        gramaticapp = `ETIQUETA_UNICA.VAL -> abre.lexval etiqueta.lexval ATRIBUTOS.VAL cierra_dos.lexval\n` + gramaticapp;
        gramatical = `<ETIQUETA_UNICA> := ${$1} ${$2} <ATRIBUTOS> ${$4} \n` + gramatical;
    }
;

APERTURA
    : tk_abre tk_etiqueta ATRIBUTOS tk_cierra {
        $$ = {}
        $$["etiqueta"] = $2;
        $$["tipo"] = "completa";
        $$["atributos"] = [];
        $$["linea"] = @2.first_line;
        $$["columna"] = @2.first_column;

        // CST
        nodoPadre = new Nodo('ETIQUETA COMPLETA', 'ETIQUETA COMPLETA');
        nodoPadre.agregarHijo(new Nodo("APERTURA",$1));
        nodoPadre.agregarHijo(new Nodo("ETIQUETA", $2));

        if($3) {
            $$['atributos'] = $3['atributos'];
            nodoPadre.agregarHijo($3['nodo']);
        } 

        nodoPadre.agregarHijo(new Nodo("CIERRE",$4));

        $$['nodo'] = nodoPadre;


        // REPORTE GRAMATICAL
        gramaticapp = `APERTURA.VAL -> abre.lexval etiqueta.lexval ATRIBUTOS.VAL cierra.lexval\n` + gramaticapp;
        gramatical = `<APERTURA> := ${$1} ${$2} <ATRIBUTOS> ${$4} \n` + gramatical;

        // Verificar Etiqueta
        verificarEtiquetas.push(new Token("ETIQUETA",$2 , @2.first_line, @2.first_column ));
    }
;

ATRIBUTOS
    : ATRIBUTO ATRIBUTOS {
        // CST
        nodoPadre = new Nodo("ATRIBUTOS", "ATRIBUTOS");
        nodoPadre.agregarHijo($1['nodo']);
        if ($2 && $2['nodo']) {
            nodoPadre.agregarHijo($2['nodo']);
        }

        // GUARDAR LOS DATOS
        $$ = {
            'atributos': [$1]
        }

        if ($2) {
            $2['atributos'].forEach(atributo => {
                $$['atributos'].push(atributo);
            });
        }

        // ALMACENANDO EL NODO
        $$['nodo'] = nodoPadre;

        // REPORTE GRAMATICAL
        gramaticapp = `ATRIBUTOS.VAL -> ATRIBUTO.VAL ATRIBUTOS.VAL \n` + gramaticapp;
        gramatical = `<ATRIBUTOS> := <ATRIBUTO> <ATRIBUTOS> \n` + gramatical;
    }
    | {
        // REPORTE GRAMATICAL
        gramaticapp = `ATRIBUTOS.VAL -> ε \n` + gramaticapp;
        gramatical = `<ATRIBUTOS> := ε \n` + gramatical;
    }
;

ATRIBUTO
    : tk_etiqueta tk_igual tk_hilera {
        // CST
        nodoPadre = new Nodo("ATRIBUTO", "ATRIBUTO");
        nodoPadre.agregarHijo(new Nodo("ETIQUETA", $1));    
        nodoPadre.agregarHijo(new Nodo("IGUAL", $2));    
        nodoPadre.agregarHijo(new Nodo("VALOR", $3.replaceAll('"','')));
        

        // GUARDAR LOS DATOS
        $$ = {};
        $$["valorAtributo"] = $3.replaceAll('"','');
        $$["nombreAtributo"]=$1;
        $$["tipo"] = "atributo";
        $$["linea"] = @1.first_line;
        $$["columna"] = @1.first_column;

        // ALMACENANDO EL CST
        $$["nodo"] = nodoPadre;
         
         // REPORTE GRAMATICAL
        gramaticapp = `ATRIBUTO.VAL -> etiqueta.lexval igual.lexval cadena.lexval \n` + gramaticapp;
        gramatical = `<ATRIBUTO> := ${$1} ${$2} ${$3} \n` + gramatical;

    }
;

CONTENIDO
    : tk_etiqueta CONTENIDO  {
        // CST
        nodoPadre = new Nodo("CONTENIDO", "CONTENIDO");
        nodoPadre.agregarHijo(new Nodo('ETIQUETA', $1));
        if ($2 && $2['nodo']) {
            nodoPadre.agregarHijo($2['nodo']);
        }

        // GUARDAR LOS DATOS
        $$ = {}
        $$["hijos"] = [];
        $$["texto"] = $1;


        if ($2) {           
            if ($2["hijos"].length > 0) {
                $2["hijos"].forEach(hijo => {
                    $$["hijos"].push(hijo);
                });
            }

            if ($2["texto"] !== "" || $2["texto"] !== " ") {
                $$["texto"] += " " + $2["texto"];
            }
        }

        // AGREGAR A LOS DATOS
        $$['nodo'] = nodoPadre

        // REPORTE GRAMATICAL
        gramaticapp = `CONTENIDO.VAL -> etiqueta.lexval CONTENIDO.VAL \n` + gramaticapp;
        gramatical = ` <CONTENIDO> := ${$1} <CONTENIDO> \n` + gramatical;
    }
    | tk_numero CONTENIDO {
        // CST
        nodoPadre = new Nodo("CONTENIDO", "CONTENIDO");
        nodoPadre.agregarHijo(new Nodo('NUMERO', $1));
        if ($2 && $2['nodo']) {
            nodoPadre.agregarHijo($2['nodo']);
        }

        // GUARDAR LOS DATOS
        $$ = {}
        $$["hijos"] = [];
        $$["texto"] = $1;


        if ($2) {           
            if ($2["hijos"].length > 0) {
                $2["hijos"].forEach(hijo => {
                    $$["hijos"].push(hijo);
                });
            }

            if ($2["texto"] !== "" || $2["texto"] !== " ") {
                $$["texto"] += " " + $2["texto"];
            }
        }

        // AGREGAR A LOS DATOS
        $$['nodo'] = nodoPadre

        // REPORTE GRAMATICAL
        gramaticapp = `CONTENIDO.VAL -> numero.lexval CONTENIDO.VAL \n` + gramaticapp;
        gramatical = `<CONTENIDO> := ${$1} <CONTENIDO> \n` + gramatical;

    }
    | ETIQUETA CONTENIDO {
        // CST
        nodoPadre = new Nodo("CONTENIDO", "CONTENIDO");
        nodoPadre.agregarHijo($1['nodo']);
        if ($2 && $2['nodo']) {
            nodoPadre.agregarHijo($2['nodo']);
        }

        // GUARDAR LOS DATOS
        $$ = {};
        $$["texto"] = "";
        $$["hijos"] = [$1];

        if ($2) {           
            if ($2["hijos"].length > 0) {
                $2["hijos"].forEach(hijo => {
                    $$["hijos"].push(hijo);
                });
            }

            if ($2["texto"] !== "" || $2["texto"] !== " ") {
                $$["texto"] += " " + $2["texto"];
            }
        }

        // AGREGAR A LOS DATOS
        $$['nodo'] = nodoPadre

        // REPORTE GRAMATICAL
        gramaticapp = `CONTENIDO.VAL -> ETIQUETA.VAL CONTENIDO.VAL \n` + gramaticapp;
        gramatical = `<CONTENIDO> := <ETIQUETA> <CONTENIDO> \n` + gramatical;
    }
    | CARACESPECIAL CONTENIDO {
        // CST
        nodoPadre = new Nodo("CONTENIDO", "CONTENIDO");
        nodoPadre.agregarHijo(new Nodo('CARACTER', $1));
        if ($2 && $2['nodo']) {
            nodoPadre.agregarHijo($2['nodo']);
        }

        $$ = {}
        $$["hijos"] = [];
        $$["texto"] = $1;


        if ($2) {           
            if ($2["hijos"].length > 0) {
                $2["hijos"].forEach(hijo => {
                    $$["hijos"].push(hijo);
                });
            }

            if ($2["texto"] !== "" || $2["texto"] !== " ") {
                $$["texto"] += " " + $2["texto"];
            }
        }

        // AGREGAR A LOS DATOS
        $$['nodo'] = nodoPadre;

        // REPORTE GRAMATICAL
        gramaticapp = `CONTENIDO.VAL  -> CARACTERESPECIAL.VAL CONTENIDO.VAL \n` + gramaticapp;
        gramatical = `<CONTENIDO> := ${$1} <CONTENIDO> \n` + gramatical;

    } 
    | 
;

CARACESPECIAL
        : tk_less {
            $$ = "<";
            // REPORTE GRAMATICAL
            gramaticapp = `CARACTERESPECIAL.VAL -> less.lexval \n` + gramaticapp;
            gramatical = `<CARAESPECIAL> := ${$1} \n` + gramatical;
        }
        | tk_great {
            $$ = ">";
            // REPORTE GRAMATICAL
            gramaticapp = `CARACTERESPECIAL.VAL -> great.lexval\n` + gramaticapp;
            gramatical = `<CARAESPECIAL> := ${$1} \n` + gramatical;
        }
        | tk_amper {
            $$ = "&";
            // REPORTE GRAMATICAL
            gramaticapp = `CARACTERESPECIAL.VAL -> amper.lexval \n` + gramaticapp;
            gramatical = `<CARAESPECIAL> := ${$1} \n` + gramatical;
        }
        | tk_apostro {
            $$ = "'";
            // REPORTE GRAMATICAL
            gramaticapp = `CARACTERESPECIAL.VAL -> apostro.lexval\n` + gramaticapp;
            gramatical = `<CARAESPECIAL> := ${$1} \n` + gramatical;
        }
        | tk_quota {
            $$ = '"';
            // REPORTE GRAMATICAL
            gramaticapp = `CARACTERESPECIAL.VAL -> quota.lexval\n` + gramaticapp;
            gramatical = `<CARAESPECIAL> := ${$1} \n` + gramatical;
        }
        ;

CIERRE
    : tk_abre_dos tk_etiqueta tk_cierra {
        $$ = {}

        // CST
        nodoPadre = new Nodo("CIERRE", "CIERRE");
        nodoPadre.agregarHijo(new Nodo("APERTURA", $1));
        nodoPadre.agregarHijo(new Nodo("ETIQUETA", $2));
        nodoPadre.agregarHijo(new Nodo("CIERRE", $3));

        $$['nodo'] = nodoPadre;

        // REPORTE GRAMATICAL
        gramaticapp = `CIERRE.VAL -> abre.lexval etiqueta.lexval cierra.lexval \n` + gramaticapp;
        gramatical = `<CIERRE> := ${$1} ${$2} ${$3} \n` + gramatical;

        //VERIFICAR ETIQUETA
        let etiqueta = verificarEtiquetas.pop();
        if (etiqueta.lexema === $2) {
            // Etiqueta correcta
        } else {
            listaErrores.push(new TokenError("XML", "Semantico", `Se abrio la etiqueta ${etiqueta.lexema} en la linea ${etiqueta.linea} y se esta cerrando con ${$2} en la linea ${@2.first_line}` , @2.first_line, @2.first_column ));
        }
    }
;




