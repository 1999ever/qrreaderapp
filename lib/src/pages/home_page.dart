import 'package:flutter/material.dart';


// import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
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
            onPressed: () {
              
            },
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
        onPressed: _scanQR,
      ),
    );
  }


  _scanQR() async {
      //https://etvblog.000webhostapp.com
      //geo:40.72735525448057,-73.79445448359378
    // String futureString = '';
    String futureString = '';

    try {
      // futureString = await new QRCodeReader().scan();
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    print('futureString: $futureString');

    if(futureString != null) {
      print('TENEMOS INFORMACION');
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