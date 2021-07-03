"use strict";
//Object.defineProperty(exports, "__esModule", { value: true });
//exports.XPath = void 0;
var XPath = /** @class */ (function () {
    function XPath(linea, columna, lista) {
        this.linea = linea;
        this.columna = columna;
        this.listaNodos = lista;
        this.global = null;
        this.temporal = null;
        this.resultadoAux = null;
        this.objetos = [];
    }
    XPath.prototype.ejecutar = function (ent, arbol) {


        for (var i=0; i < this.listaNodos.length;i++ ) {
        
            if (this.listaNodos[i].getTipo() == 4){
                objetos.splice(i,1);
                i--; 
               // continue;
            }          
        }
        objetosGlobal = ObtenerObjetos(ent);
        entornosGlobal = [ent];
        //este arreglo con el entorno global servira por si algun nodo tiene doble slash "//",".//" o "./"
        this.global = [ent];
        //"temporal" es arreglo con el entorno global es el punto de partida donde se iniciara a buscar
        //"temporal" ira variando dependiendo del retorno de cada NodoXPath
        this.temporal = [ent];

        for (var i=0; i < this.listaNodos.length;i++ ){
       
            this.listaNodos[i].setGlobal(this.global);
            this.resultadoAux = this.listaNodos[i].getValorImplicito(this.temporal,"");
            this.temporal = this.resultadoAux[0];
            this.objetos = this.resultadoAux[1];
            //this.listaNodos[i].getValorImplicito(this.temporal,"");
        }
        
        console.log("↓ SALIDA XPATH (ENTORNOS) ↓");
        console.log(this.temporal);
        console.log("↓ SALIDA XPATH  (OBJETOS) ↓");
        console.log(this.objetos);
        return this.objetos;

    };

    

    return XPath;
}());
//exports.XPath = XPath;
