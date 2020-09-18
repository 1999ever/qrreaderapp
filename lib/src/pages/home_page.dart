import 'dart:io';

import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/bloc/scan_bloc.dart';

//esta importación ya no es necesario porque en el archivo db_provider.dart ya lo importe y a su vez lo exporte, este export es con el fin de que cuando yo use el db_provider tambien venga junto a ella el scan_model.dart
// import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';

import 'package:qrreaderapp/src/utils/utils.dart' as utils;



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final scanBloc = new ScansBloc();

  ///El index actual esta inicializado con valor 0, pero este va ir cambiando cuando se haga onTap en el BottomNavigationBar.
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scanBloc.borrarScanTodos,
          )
        ],
      ),
      //el cuerpo va depender del index actual, es decir si el index es 0, entonces va mostrar la pagina mapas, y si es 1 va mostrar la pagina direcciones
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottonNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.filter_center_focus),
      //al precionar en este boton se va ejecutar el metodo que recibe que es el _scanQR
        onPressed: () => _scanQR(context),//le pasamos por referecia, ya que este se va ejecutar si se hace Tap
      ),
    );
  }

  ///Método que se encarga de lanzar el lector de codigo QR usando el paquete de Barcode Scanner
  _scanQR(BuildContext context) async {

    // https://etvblog.000webhostapp.com
    //geo:-17.800996,-63.153869
    //En esta varible se va almacenar el valor o resultado del escaneo
    String futureString;
 
    try {
      //Llamamos el BarcodeScanner que es el que se encarga de mostrar el escaneador de codigo QR
      //y el resultado que se obtenga despues que escanee se va almacenar en la variable futureString
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    //Si el resultado del escaneo es diferente a 'FormatException: Invalid envelope' quiere decir que es un escaneo valido, por ende va ejecutar el cuerpo del if.
    if(futureString != 'FormatException: Invalid envelope') {
      //dicho valor del escaneo lo pasamos como argumeto al ScanModel para que este haga lo que tiene que hacer y nos devuelva un resultado de tipo ScanModel que se almacenará en la variable scan.
      final scan = ScanModel(valor: futureString);
      // DBProvider.db.nuevoScan(scan); Ya no lo uso
      //el valor del scan lo pasamos como argumento al método agregar scan, este va realizar su trabajo y regresar el reslutado que sera mostraado
      scanBloc.agregarScan(scan);

      //ahora procedemos ver el resultado real, si es de tipo http entoces se va abrir el navegador y cargar la direccion url
      //en ios tarda un poco en cerrarse el escaner y abrir la url, entonces ponemos una condicion que si es ios que tarde unos milisegunodos antes de abrir o cargar la pagina web, si no es ios que cargue normal.
      if(Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(context, scan);
        });
      } else {//caso contrario como no es ios seria android y abrimos el resultado en el navegado o en el mapa dependiendo del tipo
        utils.abrirScan(context, scan);
      }
      
    }

  }


  ///Este widget va ser encargado de llamar la pagina dependiento del index que reciba como argumento, este index se va manejar usando un Switch Case.
  Widget _callPage(int paginaActual) {
    //Usando el switch verificamos el numero de index que se recibio, y dependiendo a este mostramos una pagina u otra
    switch (paginaActual) {
      case 0: return MapasPage();
        break;
      case 1: return DireccionesPage();
        break;
      default: return MapasPage();
    }
  }

  ///Crea los BottomNavigationBar
  Widget _crearBottonNavigationBar() {
    return BottomNavigationBar(
      //le pasamos el index actual que al inicio es 0, pero este va ir cambiando segun se haga Tap en los BottonNavigationBar
      currentIndex: currentIndex,
      //cada vez que se haga tap en los items va cambiar el index y se va redibujar con ese cambio
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}