var declaracionAsig =/**@class */(function(){
    function declaracionAsig(linea, columna, expr, ids, tipo, tipo_dato){
        this.linea = linea
        this.columna = columna
        this.expr = expr
        this.ids = ids
        this.tipo = tipo
        this.tipo_dato = tipo_dato
        this.codigo=""
    }
    declaracionAsig.prototype.getTipo = function(){
        return this.tipo
    }
    declaracionAsig.prototype.setOptimizado = function (codigo) {
        this.codigo=codigo
        return 
    }
    declaracionAsig.prototype.set3D = function(){
        this.codigo = this.tipo_dato
        for (let i=0; i<this.ids.length; i++){
            if(i==0)
                this.codigo+=" "+this.ids[i]
            else
                this.codigo+= ", "+this.ids[i]
        }
        this.codigo += " = "+this.expr+";\n"
        return this.codigo
    }
    declaracionAsig.prototype.getOptimizado=function () {
        return this.codigo
    }
    return declaracionAsig
}())