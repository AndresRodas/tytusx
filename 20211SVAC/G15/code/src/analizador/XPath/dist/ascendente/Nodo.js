class NodoAST{
    constructor(Valor,Tipo){
        this.Valor=Valor;
        this.Tipo=Tipo;
        this.Hijos = [];
        this.ID=0;
    }


    addHijos(Hijos){
        this.Hijos.push(Hijos);
    }

}
//export default NodoAST;
module.exports = NodoAST
//exports.NodoAST = NodoAST;
