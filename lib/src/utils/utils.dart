import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';

///Función que se encarga de abrir el resultado del escaneo. Si es de tipo http entonces va abrir el navegador web, si es de tipo geo entonces se abrira el mapa.
abrirScan(BuildContext context, ScanModel scan) async {
  //Si el tipo es http procede a verificar si dicha url puede ser mostrada, y si se puede entonces carga el navegador
  if(scan.tipo == 'http') {
    //Comprueba si alguna aplicacion instalada en el dispositivo puede manejar la URL especificada. Con el await le decimos espera a que se verifique para poder seguir.
    if(await canLaunch(scan.valor)) {
      //si se puede abrir entonces lanza dicha url para ser mostrada en el navegador
      await launch(scan.valor);
    } else {
      //si no retorna un aviso
      throw 'Could not launch ${scan.valor}';
    }
  //si no es de tipo http entonces seria de tipo geo, por ende tendria qur llamar la pagina mapa.
  } else {
    //usando el Navigator navegamos a la pagina mapa, donde le pasamos el contex, nombre de la pagina y el objeto arguments el cual recibe los argumetos de la clase ScanModel
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }

}