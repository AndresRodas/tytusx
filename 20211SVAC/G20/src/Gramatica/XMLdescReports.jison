/* Definición Léxica */
%lex

%options case-insensitive

BSL                                 "\\".
%s                                  comment
%%

"//".*                              /* skip comments */

"<!--"                               this.begin('comment');
<comment>"-->"                       this.popState();
<comment>.                          /* skip commentario content*/



"&lt;"                            %{ return 'tk_lt'; %}
"&gt;"                            %{ return 'tk_gt'; %}
"&amp;"                           %{ return 'tk_amp'; %}
"&apos;"                          %{ return 'tk_apos'; %}
"&quot;"                          %{ return 'tk_quot'; %}
[0-9]+("."[0-9]+)?\b              %{ return 'tk_numero';  %}
"xml"                  %{ return 'tk_xml'; %}
"version"                  %{ return 'tk_version'; %}
"encoding"                  %{ return 'tk_encoding'; %}
">"                     %{ return 'tk_mayor'; %}
"</"                     %{ return 'tk_menorslash'; %}
"<"                     %{ return 'tk_menor'; %}
"="                     %{ return 'tk_igual'; %}
"?"                     %{ return 'tk_interrogacion'; %}
"/"                     %{ return 'tk_slash'; %}
\"[^\"]*\"              %{ yytext = yytext.substr(1, yyleng-2); return 'tk_cadena1'; %}
\'[^\']*\'              %{ yytext = yytext.substr(1, yyleng-2); return 'tk_cadena2'; %}
([a-zA-ZäëïöüÄËÏÖÜáéíúóàèìòÁÉÍÓÚÀÈÌÒÙñÑ])[a-zA-Z0-9äëïöüÄËÏÖÜáéíúóàèìòÁÉÍÓÚÀÈÌÒÙñÑ_]*     %{ return 'tk_identificador'; %}
[a-zA-Z0-9äëïöüÄËÏÖÜáéíúóàèìòÁÉÍÓÚÀÈÌÒÙñÑ_!@#$%\+\^\'\`\"&\*()/¡:;.,~-]+     %{ return 'tk_texto'; %}
[']     %{ return 'tk_squote'; %}
["]      %{ return 'tk_dquote'; %}
"["      %{ return 'tk_corchetea'; %}
"]"      %{ return 'tk_corchetec'; %}
"{"      %{ return 'tk_llavea'; %}
"}"      %{ return 'tk_llavec'; %}

\s+                                 /* skip whitespace */
[ \t\r\n\f] %{  /*Los Ignoramos*/   %}
<<EOF>>     %{  return 'EOF';   %}
.          {
        ListaErr.agregarError(new Error(NumeroE, yylloc.first_line, yylloc.first_column + 1, "Lexico", "El caracter " + yytext + " no pertenece al lenguaje.","XML")); NumeroE++;
 }

/lex

//SECCION DE IMPORTS
%{
/*var nodoAux = null;
var objeto = null;
var atributo = null; */ 
%}


%left tk_menor

// DEFINIMOS PRODUCCIÓN INICIAL
%start INICIO

%%

/* Definición de la gramática */
INICIO : MOBJETOS EOF     { RGxmlDesc.agregarElemento("INICIO -> listaObjetosRaiz","INICIO.val := ListaObjetosRaiz.val");
                            var root = new NodoArbol("INICIO","");
                            root.agregarHijo($1[1]);                              
                            console.log(ListaErr.getErrores());
                            console.log("TODO BIEN, TODO CORRECTO :D!! (Version 2)");
                            $$ = [$1[0], root]
                            return $$;
                            } ;


MOBJETOS: MOBJETO OTRO_OBJETO { RGxmlDesc.agregarElemento("ListaObjetosRaiz -> ObjetoRaiz OtroObjetoRaiz","ListaObjetosRaiz.val := ObjetoRaiz.val.concat(OtroObjetoRaiz.val)");
                                nodoAux = new NodoArbol("ListaObjetosRaiz","");                                  
                                nodoAux.agregarHijo($1[1]);
                                nodoAux.agregarHijo($2[1]);
                                arr = [$1[0]];
                                arr = arr.concat($2[0]); 
                                $$ = [arr,nodoAux]; };

OTRO_OBJETO : MOBJETO OTRO_OBJETO {     RGxmlDesc.agregarElemento("OtroObjeto -> ObjetoRaiz OtroObjeto","OtroObjeto.val :=  ObjetoRaiz.val.concat(OtroObjetoRaiz.val)");
                                        nodoAux = new NodoArbol("OtroObjeto","");                                  
                                        nodoAux.agregarHijo($1[1]);
                                        nodoAux.agregarHijo($2[1]);
                                        arr = [$1[0]];
                                        arr = arr.concat($2[0]); 
                                        $$ = [arr,nodoAux]; }
        | {     RGxmlDesc.agregarElemento("OtroObjeto -> ϵ","OtroObjeto.val := null");
                objeto = new Objeto("","","",1, 1,[],[],0);
                nodoAux = new NodoArbol("OtroObjeto","");
                nodoAux.agregarHijo(new NodoArbol("ϵ",""));
                $$ = [[objeto],nodoAux]; 
         };

                
MOBJETO  : tk_menor tk_identificador LATRIBUTOS tk_mayor OBJETOS tk_menorslash tk_identificador tk_mayor {
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos ">" objetos "<" / id>`,"Objeto.val := new Objeto(id.val,atributos.val,objetos.val)");
                nodoAux = new NodoArbol("ObjetoRaiz","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo($5[1]);
                nodoAux.agregarHijo(new NodoArbol($6,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($7,"identificador"));
                nodoAux.agregarHijo(new NodoArbol($8,"simbolo"));
                objeto = new Objeto($2,$7,'',@1.first_line, @1.first_column,$3[0],$5[0],1);
                $$ = [objeto,nodoAux];
        } 
        | tk_menor tk_identificador LATRIBUTOS tk_mayor TEXTOS tk_menorslash tk_identificador tk_mayor {
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos ">" textos "<" / id>`,"Objeto.val := new Objeto(id.val,atributos.val,textos.val)");
                nodoAux = new NodoArbol("ObjetoRaiz","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo($5[1]);
                nodoAux.agregarHijo(new NodoArbol($6,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($7,"identificador"));
                nodoAux.agregarHijo(new NodoArbol($8,"simbolo"));
                objeto = new Objeto($2,$7,$5[0],@1.first_line, @1.first_column,$3[0],[],1);
                $$ = [objeto,nodoAux];
        } 
        | tk_menor tk_identificador LATRIBUTOS tk_mayor tk_menorslash tk_identificador tk_mayor { 
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos ">" "<" / id>`,"Objeto.val := new Objeto(id.val,atributos.val,null)");
                nodoAux = new NodoArbol("ObjetoRaiz","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($5,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($6,"identificador"));
                nodoAux.agregarHijo(new NodoArbol($7,"simbolo"));
                objeto = new Objeto($2,$6,'',@1.first_line, @1.first_column,$3[0],[],1);
                $$ = [objeto,nodoAux];
        } 
        | tk_menor tk_identificador LATRIBUTOS tk_slash tk_mayor {
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos / id>`,"Objeto.val := new Objeto(id.val,atributos.val,null)");
                nodoAux = new NodoArbol("ObjetoRaiz","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($5,"simbolo"));
                objeto = new Objeto($2,$2,'',@1.first_line, @1.first_column,$3[0],[],2);
                $$ = [objeto,nodoAux];
        }
        | tk_menor tk_interrogacion tk_xml tk_version tk_igual CADENA tk_encoding tk_igual CADENA tk_interrogacion tk_mayor {
                RGxmlDesc.agregarElemento(`Objeto -> "<" "?" "xml" "version" "=" Cadena "encoding" "igual" Cadena "?" ">"`,"Objeto.val := new Objeto(encoding,null,null)"); 
                nodoAux = new NodoArbol("ObjetoRaiz","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($3,"palabra reservada"));
                nodoAux.agregarHijo(new NodoArbol($4,"palabra reservada"));
                nodoAux.agregarHijo(new NodoArbol($5,"simbolo"));
                nodoAux.agregarHijo($6[1]);
                nodoAux.agregarHijo(new NodoArbol($7,"palabra reservada"));
                nodoAux.agregarHijo(new NodoArbol($8,"simbolo"));
                nodoAux.agregarHijo($9[1]);
                nodoAux.agregarHijo(new NodoArbol($10,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($11,"simbolo"));
                objeto = new Objeto("version","version",$9[0],@1.first_line, @1.first_column,[],[],0);
                $$ = [objeto,nodoAux];
        } 
        | error {
                nodoAux = new NodoArbol("ObjetoRaiz","");
                nodoAux.agregarHijo(new NodoArbol("Error",""));
                ListaErr.agregarError(new Error(NumeroE, yylineno,this._$.first_column + 1, "Sintactico", "Se esperaba un objeto y se encontro "+ yytext,"XML")); NumeroE++;
                objeto = new Objeto("","",'',@1.first_line, @1.first_column,[],[],0);
                $$ = [objeto,nodoAux];
        } ;

FINERROR: tk_mayor 

        | tk_menor

        | tk_identificador

        | tk_slash

        | tk_igual

        | tk_texto

        | tk_cadena1

        | tk_cadena2

        | EOF;
        


CADENA : tk_cadena1 {   RGxmlDesc.agregarElemento(`Cadena -> tk_cadena`,"Cadena.val := tk_cadena.val");
                        nodoAux = new NodoArbol($1,"cadena");
                        $$ = [$1, nodoAux]; }

        | tk_cadena2 {  RGxmlDesc.agregarElemento(`Cadena -> tk_cadena`,"Cadena.val := tk_cadena.val");
                        nodoAux = new NodoArbol($1,"cadena");
                        $$ = [$1, nodoAux]; };


TEXTOS: TEXTO OTRO_TEXTO { RGxmlDesc.agregarElemento(`Textos -> Texto OtroTexto`,`Textos.val := Texto.val + " " + OtroTexto.val`);
                           nodoAux = new NodoArbol("Textos","");                                  
                           nodoAux.agregarHijo($1[1]);
                           nodoAux.agregarHijo($2[1]);
                           $1[0]= $1[0] + " " + $2[0]; 
                           $$ = [$1[0],nodoAux]; };

OTRO_TEXTO: TEXTO OTRO_TEXTO { RGxmlDesc.agregarElemento(`OtroTexto -> Texto OtroTexto`,`OtroTexto.val := Texto.val + " " + OtroTexto.val`);
                               nodoAux = new NodoArbol("OtroTexto","");                                  
                               nodoAux.agregarHijo($1[1]);
                               nodoAux.agregarHijo($2[1]);
                               $1[0]= $1[0] + " " + $2[0]; 
                               $$ = [$1[0],nodoAux]; }
                           | { RGxmlDesc.agregarElemento(`OtroTexto -> ϵ`,`OtroTexto.val := ""`);
                               nodoAux = new NodoArbol("OtroTexto","");                                  
                               nodoAux.agregarHijo(new NodoArbol(`""`,""));
                               $$ = ["",nodoAux]; };



TEXTO :      tk_identificador   { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_numero          { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_lt              { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("<","texto"));
                                  $$ = ["<",nodoAux]; }

        |    tk_gt              { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol(">","texto"));
                                  $$ = [">",nodoAux]; }

        |    tk_amp             { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("&","texto"));
                                  $$ = ["&",nodoAux]; }
                                  
        |    tk_apos            { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("\'","texto"));
                                  $$ = ["\'",nodoAux]; }

        |    tk_squote          { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_interrogacion   { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("interrogracion","texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_dquote          { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("comilla doble","texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_corchetea       { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("corcheteA","texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_corchetec       { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("corcheteC","texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_llavea          { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("Llave abierta","texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_llavec          { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("Llave cerrada","texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_xml             { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_encoding        { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_version         { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_quot            { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("&quot;","texto"));
                                  $$ = ["\"",nodoAux]; }

        |    tk_cadena1         { $1 = `"`+ $1 + `"`;
                                  nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux]; }

        |    tk_cadena2         { $1 = `'`+ $1 + `'`;
                                  nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol($1,"texto"));
                                  $$ = [$1,nodoAux];  }
                                  
        |    tk_texto           { nodoAux = new NodoArbol("TEXTO","");
                                  nodoAux.agregarHijo(new NodoArbol("texto","texto"));
                                  $$ = [$1,nodoAux];  };


OBJETOS: OBJETO OTRO_UOBJETO {  RGxmlDesc.agregarElemento("ListaObjetos -> Objeto OtroObjeto","ListaObjetos.val := Objeto.val.concat(OtroObjeto.val)");
                                nodoAux = new NodoArbol("ListaObjetos","");                                  
                                nodoAux.agregarHijo($1[1]);
                                nodoAux.agregarHijo($2[1]);
                                arr = [$1[0]];
                                arr = arr.concat($2[0]); 
                                $$ = [arr,nodoAux]; };

OTRO_UOBJETO : OBJETO OTRO_UOBJETO {
                                RGxmlDesc.agregarElemento("OtroObjeto -> Objeto OtroObjeto","OtroObjeto.val :=  Objeto.val.concat(OtroObjeto.val)"); 
                                nodoAux = new NodoArbol("OtroObjeto","");                                  
                                nodoAux.agregarHijo($1[1]);
                                nodoAux.agregarHijo($2[1]);
                                arr = [$1[0]];
                                arr = arr.concat($2[0]); 
                                $$ = [arr,nodoAux]; }
        | {     RGxmlDesc.agregarElemento("OtroObjeto -> ϵ","OtroObjeto.val := null");
                objeto = new Objeto("","","",1, 1,[],[],0);
                nodoAux = new NodoArbol("OtroObjeto","");
                nodoAux.agregarHijo(new NodoArbol("ϵ",""));
                $$ = [[objeto],nodoAux];
         };


                
OBJETO  : tk_menor tk_identificador LATRIBUTOS tk_mayor OBJETOS tk_menorslash tk_identificador tk_mayor {
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos ">" objetos "<" / id>`,"Objeto.val := new Objeto(id.val,atributos.val,objetos.val)");
                nodoAux = new NodoArbol("Objeto","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo($5[1]);
                nodoAux.agregarHijo(new NodoArbol($6,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($7,"identificador"));
                nodoAux.agregarHijo(new NodoArbol($8,"simbolo"));
                objeto = new Objeto($2,$7,'',@1.first_line, @1.first_column,$3[0],$5[0],1);
                $$ = [objeto,nodoAux];
        } 
        | tk_menor tk_identificador LATRIBUTOS tk_mayor TEXTOS tk_menorslash tk_identificador tk_mayor {
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos ">" textos "<" / id>`,"Objeto.val := new Objeto(id.val,atributos.val,textos.val)");
                nodoAux = new NodoArbol("Objeto","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo($5[1]);
                nodoAux.agregarHijo(new NodoArbol($6,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($7,"identificador"));
                nodoAux.agregarHijo(new NodoArbol($8,"simbolo"));
                objeto = new Objeto($2,$7,$5[0],@1.first_line, @1.first_column,$3[0],[],1);
                $$ = [objeto,nodoAux];
        } 
        | tk_menor tk_identificador LATRIBUTOS tk_mayor tk_menorslash tk_identificador tk_mayor { 
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos ">" "<" / id>`,"Objeto.val := new Objeto(id.val,atributos.val,null)");
                nodoAux = new NodoArbol("Objeto","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($5,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($6,"identificador"));
                nodoAux.agregarHijo(new NodoArbol($7,"simbolo"));
                objeto = new Objeto($2,$6,'',@1.first_line, @1.first_column,$3[0],[],1);
                $$ = [objeto,nodoAux];
        } 
        | tk_menor tk_identificador LATRIBUTOS tk_slash tk_mayor {
                RGxmlDesc.agregarElemento(`Objeto -> "<" id atributos / id>`,"Objeto.val := new Objeto(id.val,atributos.val,null)");
                nodoAux = new NodoArbol("Objeto","");
                nodoAux.agregarHijo(new NodoArbol($1,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($2,"identificador"));
                nodoAux.agregarHijo($3[1]);
                nodoAux.agregarHijo(new NodoArbol($4,"simbolo"));
                nodoAux.agregarHijo(new NodoArbol($5,"simbolo"));
                objeto = new Objeto($2,$2,'',@1.first_line, @1.first_column,$3[0],[],2);
                $$ = [objeto,nodoAux];
         }
        | error  {
                nodoAux = new NodoArbol("Objeto","");
                nodoAux.agregarHijo(new NodoArbol("Error",""));
                ListaErr.agregarError(new Error(NumeroE, yylineno,this._$.first_column + 1, "Sintactico", "Se esperaba un objeto y se encontro "+ yytext,"XML")); NumeroE++;
                objeto = new Objeto("","",'',@1.first_line, @1.first_column,[],[],0);
                $$ = [objeto,nodoAux];
        } ;


LATRIBUTOS: ATRIBUTOS   { RGxmlDesc.agregarElemento(`ListaAtributos -> Atributos`,"ListaAtributos.val := Atributos.val");
                          nodoAux = new NodoArbol("ListaAtributos","");
                          nodoAux.agregarHijo($1[1]);
                          $$ = [$1[0], nodoAux]; }

           |            { RGxmlDesc.agregarElemento(`ListaAtributos -> ε`,"ListaAtributos.val := []");
                          nodoAux = new NodoArbol("ListaAtributos","");
                          nodoAux.agregarHijo(new NodoArbol("E","simbolo"));
                          $$ = [[], nodoAux]; };

ATRIBUTOS: ATRIBUTO OTRO_ATRIBUTO {     RGxmlDesc.agregarElemento("ListaAtributos -> Atributo OtroAtributo","ListaAtributos.val := Atributo.val.concat(OtroAtributo.val)");
                                        nodoAux = new NodoArbol("ListaAtributos","");                                  
                                        nodoAux.agregarHijo($1[1]);
                                        nodoAux.agregarHijo($2[1]);
                                        arr = [$1[0]];
                                        arr = arr.concat($2[0]); 
                                        $$ = [arr,nodoAux]; };

OTRO_ATRIBUTO : ATRIBUTO OTRO_ATRIBUTO {RGxmlDesc.agregarElemento("OtroAtributo -> Atributo OtroAtributo","OtroAtributo.val :=  Atributo.val.concat(OtroAtributo.val)"); 
                                        nodoAux = new NodoArbol("OtroAtributo","");                                  
                                        nodoAux.agregarHijo($1[1]);
                                        nodoAux.agregarHijo($2[1]);
                                        arr = [$1[0]];
                                        arr = arr.concat($2[0]); 
                                        $$ = [arr,nodoAux]; }
                                | {     RGxmlDesc.agregarElemento("OtroAtributo -> ϵ","OtroAtributo.val := null");
                                        atributo = new Atributo("", "", @1.first_line, @1.first_column);
                                        nodoAux = new NodoArbol("OtroAtributo","");
                                        nodoAux.agregarHijo(new NodoArbol("ϵ",""));
                                        $$ = [[atributo],nodoAux];    
                                };


ATRIBUTO: tk_identificador tk_igual tk_cadena1  {  RGxmlDesc.agregarElemento(`Atributo -> id "=" Cadena`,"Atributo.val := new Atributo(id.val,cadena.val)");
                                                   nodoAux = new NodoArbol("Atributo","");
                                                   nodoAux.agregarHijo(new NodoArbol($1,"identificador"));
                                                   nodoAux.agregarHijo(new NodoArbol($2,"simbolo"));
                                                   nodoAux.agregarHijo(new NodoArbol($3,"cadena"));
                                                   atributo = new Atributo($1, $3, @1.first_line, @1.first_column);
                                                   $$ = [atributo,nodoAux]; }
        

        | tk_identificador tk_igual tk_cadena2  {  RGxmlDesc.agregarElemento(`Atributo -> id "=" Cadena`,"Atributo.val := new Atributo(id.val,cadena.val)");
                                                   nodoAux = new NodoArbol("Atributo","");
                                                   nodoAux.agregarHijo(new NodoArbol($1,"identificador"));
                                                   nodoAux.agregarHijo(new NodoArbol($2,"simbolo"));
                                                   nodoAux.agregarHijo(new NodoArbol($3,"cadena"));
                                                   atributo = new Atributo($1, $3, @1.first_line, @1.first_column);
                                                   $$ = [atributo,nodoAux]; }
        | error FINERROR {
        
          nodoAux = new NodoArbol("Atributo","");
          nodoAux.agregarHijo(new NodoArbol("Error",""));
          ListaErr.agregarError(new Error(NumeroE, yylineno, this._$.first_column + 1, "Sintactico", "Se esperaba un atributo y se encontro "+ yytext,"XML")); NumeroE++;
          atributo = null;
          $$ = [atributo,nodoAux];
          } ;





