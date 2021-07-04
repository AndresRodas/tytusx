"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
exports.__esModule = true;
exports.Division = void 0;
var Expresion_1 = require("./Expresion");
var Literal_1 = require("./Literal");
var Division = /** @class */ (function (_super) {
    __extends(Division, _super);
    function Division(izq, der, l, c) {
        var _this = _super.call(this) || this;
        _this.operacion = 'div';
        _this.hI = izq;
        _this.hD = der;
        _this.linea = l;
        _this.columna = c;
        return _this;
    }
    Division.prototype.copiarValor = function () {
        return new Division(this.hI.copiarValor(), this.hD.copiarValor(), this.linea, this.columna);
    };
    Division.prototype.getValor = function (entorno) {
        var res = new Literal_1.Literal(69, '@ERROR@', this.linea, this.columna);
        var e1 = this.hI.getValor(entorno);
        var e2 = this.hD.getValor(entorno);
        if (e1.tipo == 0) {
            if (e2.tipo == 0) {
                if (parseInt(e2.valor.toString()) != 0) {
                    res.tipo = 1;
                    res.valor = parseInt(e1.valor.toString()) / parseInt(e2.valor.toString());
                    return res;
                }
                else {
                    //ERROR: valor2 no puede ser 0
                }
            }
            else if (e2.tipo == 1) {
                if (parseInt(e2.valor.toString()) != 0) {
                    res.tipo = 1;
                    res.valor = parseInt(e1.valor.toString()) / parseFloat(e2.valor.toString());
                    return res;
                }
                else {
                    //ERROR: valor2 no puede ser 0
                }
            }
            else {
                //ERROR: tipo2 no es valido para las divisiones
            }
        }
        else if (e1.tipo == 1) {
            if (e2.tipo == 0) {
                if (parseInt(e2.valor.toString()) != 0) {
                    res.tipo = 1;
                    res.valor = parseFloat(e1.valor.toString()) / parseInt(e2.valor.toString());
                    return res;
                }
                else {
                    //ERROR: valor2 no puede ser 0
                }
            }
            else if (e2.tipo == 1) {
                if (parseInt(e2.valor.toString()) != 0) {
                    res.tipo = 1;
                    res.valor = parseFloat(e1.valor.toString()) / parseFloat(e2.valor.toString());
                    return res;
                }
                else {
                    //ERROR: valor2 no puede ser 0
                }
            }
            else {
                //ERROR: tipo2 no es valido para las divisiones
            }
        }
        else {
            //ERROR: tipo1 no es valido para las divisiones
        }
        return res;
    };
    return Division;
}(Expresion_1.Expresion));
exports.Division = Division;
