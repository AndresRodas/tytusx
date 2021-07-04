class AnyIdentifier implements Expresion{
    private identifier:string;
    private predicatesList: Expresion[];
    linea: number;
    columna: number;

    constructor(identifier: string, predicatesList: Expresion[], linea: number, columna: number) {
        this.identifier = identifier;
        this.predicatesList = predicatesList;
        this.linea = linea;
        this.columna = columna;
    }

    getTipo(ent: TablaSimbolos): Tipo {
        return new Tipo(TipoDato.err);
    }

    getValor(ent: TablaSimbolos): any {
        let ts = ent.findAllObjectsByNombreElemento(this.identifier);
        return PredicateExpresion.filterXpathExpresion(ts,this.predicatesList);
    }
}