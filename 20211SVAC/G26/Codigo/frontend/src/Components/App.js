import React from 'react';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import IconButton from '@material-ui/core/IconButton';
import Typography from '@material-ui/core/Typography';
import InputLabel from '@material-ui/core/InputLabel';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';
import MenuIcon from '@material-ui/icons/Menu';
import Alert from '@material-ui/lab/Alert';
import Collapse from '@material-ui/core/Collapse';
import CloseIcon from '@material-ui/icons/Close';

import '../Styles/App.css';
import Editor from './Editor';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faFileAlt, faFileUpload, faPlay, faSave } from '@fortawesome/free-solid-svg-icons';

import {Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'reactstrap';
import 'bootstrap/dist/css/bootstrap.css';

import {Graphviz} from 'graphviz-react';

import analizador from '../Analizador/indexAnalizador';

class App extends React.Component {
  state = {
    open: false,
    modalOpen: false,
    modalOpenCst: false,
    alertOpen: false,
    opcion: '',
    consoleText: '',
    fileName: '',
    xml: '',
    xpath: '',
    listaErrores: '',
    fileDownloadUrl: null,
    selectedOption: '',
    dot:`digraph {}`,
  }

  abrirModal = () => {
    this.setState({modalOpen: !this.state.modalOpen});
  }

  handleClose = () => {
    this.setState({open: false});
  }

  handleOpen = () => {
    this.setState({open: true});
  }
  
  handleXML = (value) => {
    this.setState({xml: value});
  }

  handleXPath = (value) => {
    this.setState({xpath: value});
  }

  handleDot = (value) => {
    this.setState({dot: value});
  }

  handleDot = (value) => {
    this.setState({listaErrores: value});
  }

  nuevo = () => {
    this.setState({fileName: '', xml: '', xpath: ''});
  }

  upload = (event) => {
  	event.preventDefault();
    this.dofileUpload.click()
  }

  open = (evt) => {
    const fileObj = evt.target.files[0];
    const reader = new FileReader();
        
    let fileloaded = e => {
      // e.target.result is the file's content as text
      const fileContents = e.target.result;
      this.setState ({xml: fileContents, fileName: fileObj.name})
    }
    
    // Mainline of the method
    fileloaded = fileloaded.bind(this);
    reader.onload = fileloaded;
    reader.readAsText(fileObj);  
  }

  downloadXML = (event) => {
    event.preventDefault();
  	// Prepare the file
    let output;
    output = this.state.xml;
    // Download it
    const blob = new Blob([output]);
    const fileDownloadUrl = URL.createObjectURL(blob);
    if(this.state.fileName === null || this.state.fileName === ''){
      var hoy = new Date();
      var dd = hoy.getDate();
      var mm = hoy.getMonth() + 1;
      var yyyy = hoy.getFullYear();
      var HH = hoy.getHours();
      var MM = hoy.getMinutes();
      var formato = dd + "_" + mm + "_" + yyyy + "_" + HH + "_" + MM;
      this.setState({fileName: formato})
    }
    this.setState ({fileDownloadUrl: fileDownloadUrl}, 
      () => {
        this.dofileDownload.click(); 
        URL.revokeObjectURL(fileDownloadUrl);  // free up storage--no longer needed.
        this.setState({fileDownloadUrl: ""})
    })    
  }

  downloadXPath = (event) => {
    event.preventDefault();
  	// Prepare the file
    let output;
    output = this.state.xml;
    // Download it
    const blob = new Blob([output]);
    const fileDownloadUrl = URL.createObjectURL(blob);
    if(this.state.fileName === null || this.state.fileName === ''){
      var hoy = new Date();
      var dd = hoy.getDate();
      var mm = hoy.getMonth() + 1;
      var yyyy = hoy.getFullYear();
      var HH = hoy.getHours();
      var MM = hoy.getMinutes();
      var formato = dd + "_" + mm + "_" + yyyy + "_" + HH + "_" + MM;
      this.setState({fileName: formato})
    }
    this.setState ({fileDownloadUrl: fileDownloadUrl}, 
      () => {
        this.dofileDownload.click(); 
        URL.revokeObjectURL(fileDownloadUrl);  // free up storage--no longer needed.
        this.setState({fileDownloadUrl: ""})
    })    
  }

  onValueChange = (event) => {
    this.setState({
      selectedOption: event.target.value
    });
  }

  formSubmit = (event) => {
    event.preventDefault();
    console.log(this.state.selectedOption)
  }

  analizar = (event) => {
    this.abrirModal();
    let resultado = '';
    switch(this.state.selectedOption){
      case 'Ascendente':
        analizador.xmlAscendente(this.state.xml);
        resultado = this.state.xpath !== ''?analizador.XPathAscendente(this.state.xpath):'';
        break;
      case 'Descendente':
        analizador.xmlDescendente(this.state.xml);
        resultado = this.state.xpath !== ''?analizador.XPathDescendente(this.state.xpath):'';
        break;
      default:
        break;
    }
    this.setState({consoleText:resultado});
    if (this.state.selectedOption !== '') 
      this.setState({alertOpen: true});
  }

  reporteTablaSimbolos = (event) => {
    this.setState({dot:analizador.getRepTablaSimbolos()});
  }

  reporteListaErrores = (event) => {
    this.setState({listaErrores:analizador.getRepErrores()});
  }

  mostrarCst = () => {
    this.setState({modalOpenCst: !this.state.modalOpenCst});
    //this.setState({dot:analizador.getCSTXmlAsc()});
  }

  reporteCst = (event) => {
    this.mostrarCst();
    switch(this.state.selectedOption){
      case 'Xml Ascendente':
        this.setState({dot:analizador.getCSTXmlAsc()});
        break;
      case 'Xml Descendente':
        this.setState({dot:analizador.getCSTXmlDesc()});
        break;
      default:
        break;
    }
  }

  render(){
    const modalStyles={
      position: "absolute",
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)'
    }
    return (
      <>
      <div className="App" style={{width:"100%"}}>
        <header className="App-header">
          <AppBar position="static">
            <Toolbar>
              <IconButton edge="start" className="menuButton" color="inherit" aria-label="menu">
                <MenuIcon />
              </IconButton>
              <Typography variant="h6" className="title">
                TytusX
              </Typography>
            </Toolbar>
          </AppBar>
        </header>
        <div className="App-body">
          <Grid container spacing={3}>
          <Grid item xs={1}></Grid>
            <Grid item xs={10}>
              <div className="row">
                <div> 
                  <button className="Boton" style={{backgroundColor:"white"}} onClick={this.nuevo}>
                    <FontAwesomeIcon icon={faFileAlt} /> 
                  </button>
                  <button onClick={this.upload} className="Boton" style={{backgroundColor:"white", color:"yellowgreen"}}>
                    <FontAwesomeIcon icon={faFileUpload} /> 
                  </button> 
                  <input type="file" style={{display:'none'}}
                    multiple={false}
                    accept=".xml,application/xml"
                    onChange={evt => this.open(evt)}
                    ref={e=>this.dofileUpload = e}
                  />
                  <div style={{display:"inline-block", padding:'0px 10px 0px 10px'}}>
                    <Typography style={{color:"black"}}>Guardar XML</Typography>
                    <button className="Boton" style={{backgroundColor:"white", color:"gray"}} onClick={this.downloadXML}>
                      <FontAwesomeIcon icon={faSave} />
                    </button> 
                    <a style={{display:'none'}}
                        download={this.state.fileName}
                        href={this.state.fileDownloadUrl}
                        ref={e=>this.dofileDownload = e}>download it</a>
                  </div> 

                  <div style={{display:"inline-block", padding:'0px 5px 0px 5px'}}>  
                    <Typography style={{color:"black"}}>Guardar XPath</Typography>
                    <button className="Boton" style={{backgroundColor:"white", color:"gray"}} onClick={this.downloadXPath}>
                      <FontAwesomeIcon icon={faSave} /> 
                    </button>
                    <a style={{display:'none'}}
                        download={this.state.fileName}
                        href={this.state.fileDownloadUrl}
                        ref={e=>this.dofileDownload = e}>download it</a>
                  </div>        
                  <button className="Boton" style={{backgroundColor:"white", color:"green"}} onClick={this.abrirModal}>
                    <FontAwesomeIcon icon={faPlay} /> 
                  </button>     
                </div>
                <div>

                </div>
              </div>
            </Grid>
            <Grid item xs={1}></Grid>
            <Grid item xs={1}></Grid>
            <Grid item xs={5}>
              <Paper className="paper"  /*style={{background: 'rgba(96,113,121,0.3)'}}*/>
                <Editor
                  language="xml"
                  displayName="XML"
                  value={this.state.xml}
                  onChange={this.handleXML}
                />
              </Paper>
            </Grid>
            <Grid item xs={5}>
              <Paper className="paper"  /*style={{background: 'rgba(96,113,121,0.3)'}}*/>
                <Editor 
                  language="xquery"
                  displayName="XPATH"
                  value={this.state.xpath}
                  onChange={this.handleXPath}
                />
              </Paper>
            </Grid>
            <Grid item xs={1}></Grid>
            <Grid item xs={1}></Grid>
            <Grid item xs={10}>
              <Paper className="paper"  /*style={{background: 'rgba(96,113,121,0.3)'}}*/>          
                <div className="row">
                  <div className="col-md-12">
                      <InputLabel style={{fontWeight: 'bold', fontFamily: 'sans-serif'}}>CONSOLA</InputLabel> 
                      <div id="consola">
                        <textarea 
                          id="txtConsola" 
                          value={this.state.consoleText} 
                          name="txtConsola" 
                          disabled={true} 
                          className="consola" 
                          rows="8" style={{width: "100%"}}/>
                      </div>
                  </div>
                </div>

              </Paper>
            </Grid>
            <Grid item xs={1}></Grid>
            <Grid item xs={1}></Grid>
            <Grid item xs={10}>
              <Paper className="paper">
                <div className="row">
                  <div className="col-md-12">
                    <br></br>
                    <InputLabel style={{fontWeight: 'bold', fontFamily: 'sans-serif'}}>Reportes</InputLabel>
                    <Button className="btn bg-primary" onClick={this.reporteTablaSimbolos}>Tabla de Simbolos</Button> |
                    <Button className="btn bg-secondary">AST</Button> |
                    <Button className="btn bg-success" onClick={this.mostrarCst}>CST</Button> |
                    <Button className="btn bg-danger" onClick={this.reporteListaErrores}>Lista de Errores</Button> |
                    <Button className="btn bg-warning">GRAMATICA</Button>
                    <br></br>
                    <div id="pnlGraphviz" style={{borderStyle: 'solid', borderRadius: '2em'}}>
                      <Graphviz dot={this.state.dot} options={{fit:true, width:950,zoom: true}}/>
                    </div>
                  </div>
                </div>
                <div className="row">
                  <div className="col-md-12">
                    <Paper>
                      <InputLabel style={{fontWeight: 'bold', fontFamily: 'sans-serif'}}>LISTA ERRORES</InputLabel> 
                      <div id="pnlErorres" dangerouslySetInnerHTML={{ __html: this.state.listaErrores }} />
                    </Paper>
                  </div>
                </div>
              </Paper> 
            </Grid>
            <Grid item xs={1}></Grid>
          </Grid>
        </div>
      </div>

      <Collapse in={this.state.alertOpen} style={{position: 'fixed', top: '90%', left:'50%', transform: 'translate(-50%, -50%)'}}>
        <Alert
          action={
            <IconButton
              aria-label="close"
              color="inherit"
              size="small"
              onClick={() => {
                this.setState({alertOpen: false});
              }}
            >
              <CloseIcon fontSize="inherit" />
            </IconButton>
          }
        >
          Analizado correctamente!
        </Alert>
      </Collapse>

      <Modal isOpen={this.state.modalOpen} style={modalStyles}>
      <ModalHeader>
        Analizar
      </ModalHeader>
      <ModalBody>
        <form onSubmit={this.formSubmit}>
          <div className="radio">
            <label>
              <input
                type="radio"
                value="Ascendente"
                checked={this.state.selectedOption === "Ascendente"}
                onChange={this.onValueChange}
              />
              Ascendente
            </label>
          </div>
          <div className="radio">
            <label>
              <input
                type="radio"
                value="Descendente"
                checked={this.state.selectedOption === "Descendente"}
                onChange={this.onValueChange}
              />
              Descendente
            </label>
          </div>
        </form>
      </ModalBody>
      <ModalFooter>
          <Button color="primary" onClick={this.analizar}>Analizar</Button>
          <Button color="secondary" onClick={() => {this.setState({selectedOption: ''}); this.abrirModal();}}>Cerrar</Button>
      </ModalFooter>
      </Modal>


      <Modal isOpen={this.state.modalOpenCst} style={modalStyles}>
      <ModalHeader>
        Reporte CST
      </ModalHeader>
      <ModalBody>
        <form onSubmit={this.formSubmit}>
          <div className="radio">
            <label>
              <input
                type="radio"
                value="Xml Ascendente"
                checked={this.state.selectedOption === "Xml Ascendente"}
                onChange={this.onValueChange}
              />
              Xml Ascendente
            </label>
          </div>
          <div className="radio">
            <label>
              <input
                type="radio"
                value="Xml Descendente"
                checked={this.state.selectedOption === "Xml Descendente"}
                onChange={this.onValueChange}
              />
              Xml Descendente
            </label>
          </div>
        </form>
      </ModalBody>
      <ModalFooter>
          <Button color="primary" onClick={this.reporteCst}>Generar Reporte</Button>
          <Button color="secondary" onClick={() => {this.setState({selectedOption: ''}); this.mostrarCst();}}>Cerrar</Button>
      </ModalFooter>
      </Modal>

      </>
    );
  }
}

export default App;
