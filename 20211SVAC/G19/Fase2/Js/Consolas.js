var EntradaXPath = CodeMirror.fromTextArea
(document.getElementById('entrada_xpath'),{
    mode : "xquery",
    htmlMode: true,
    theme: "ayu-dark",
    lineNumbers: false,
    fixedGutter: false,
    autoRefresh:true
});

EntradaXPath.setSize(null, 50);
EntradaXPath.refresh();

var EntradaXQuery = CodeMirror.fromTextArea
(document.getElementById('entrada_xquery'),{
    mode : "xquery",
    htmlMode: true,
    theme: "ayu-dark",
    lineNumbers: true,
    fixedGutter: false,
    autoRefresh:true
});

EntradaXQuery.setSize(null, 200);
EntradaXQuery.refresh();


var SalidaXPath = CodeMirror.fromTextArea
(document.getElementById('salida_xpath'),{
    mode : "text/html",
    htmlMode: true,
    theme: "ayu-dark",
    lineNumbers: false,
    fixedGutter: false,
    autoRefresh: true,
    readOnly: true,
    readOnly: "nocursor"
});

SalidaXPath.setSize(null, 425);
SalidaXPath.refresh();

var ReporteOptimizar = CodeMirror.fromTextArea
(document.getElementById('reporte'),{
    mode : "text/html",
    htmlMode: true,
    theme: "ayu-dark",
    lineNumbers: false,
    fixedGutter: false,
    autoRefresh: true,
    readOnly: true,
    readOnly: "nocursor"
});

ReporteOptimizar.setSize(1000, 425);
ReporteOptimizar.refresh();


var SalidaTraduccion = CodeMirror.fromTextArea
(document.getElementById('salida_traduccion'),{
    mode: "text/x-csrc",
    htmlMode: true,
    theme: "ayu-dark",
    lineNumbers: true,
    fixedGutter: false,
    autoRefresh:true
});

SalidaTraduccion.setSize(1000, 550);
SalidaTraduccion.refresh();


