class ConsultaSimple {
    constructor(id) {
        this.identificador = id;
    }
    run(entornos) {
        let newEntornos = new Array();
        entornos.forEach((e) => {
            let flag = false;
            let nuevoEntorno = new Entorno(e.getAnterior());
            e.getTable().forEach((s) => {
                if (s instanceof Nodo) {
                    if (this.identificador === "*") {
                        flag = true;
                        nuevoEntorno.add(s);
                    }
                    else if (s.getNombre() == this.identificador) {
                        flag = true;
                        nuevoEntorno.add(s);
                    }
                }
            });
            if (flag) {
                newEntornos.push(nuevoEntorno);
            }
        });
        return newEntornos;
    }
    getIdentificador() {
        return this.identificador;
    }
}
