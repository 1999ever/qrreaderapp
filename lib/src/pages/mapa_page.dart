import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';

///Clase que muestra la pagina del mapa con las coordenadas que se le especifiquen
class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();

}

class _MapaPageState extends State<MapaPage> {
  //map de tipo MapController, controla informacion referente al mapa en tiempo de ejecucion, como por ejemplo gracias a este puedo volver a la pocicion central cuando me mueva a otro lado de mapa, tambien al volver a dicha posicion tambien vuelve a zoom inicial.
  final map = MapController();

  //esta propiedad es la que va cambiar de valor cada vez que presionemos el boton de cambiar mapa, por ende necesito utilizar el StatefulWidget, ya que con el StatelesWidged no se puede
  // String tipoMapa = 'a';

  @override
  Widget build(BuildContext context) {
    //recibimos los argumetos de la pagiana anterior, dichos argumentos lo almacenamos en la variable scan
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    // print(scan.tipo);
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              //cada vez que se precione el icono se va ejecutar MapController y el metodo .move(del paquete flutter_map), el cual este método recibe un argumento de tipo LatLng y el zoom del mapa.
              //notemos que el map es de tipo controller que se encargar de controlar el estado del mapa y poder cambiarlo.
              map.move(scan.getLatLng(), 12.0);
            },
          ),
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  ///se encarga de crear un boton y que al presionar dicho boton el tipo de mapa cambie
  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        // if(tipoMapa == 'a') {
        //   tipoMapa = 'b';
        // } else if(tipoMapa == 'b') {
        //   tipoMapa = 'c';
        // } else{
        //   tipoMapa = 'a';
        // }

        // setState(() {});
      },
    );
  }

  ///Este widget crea el mapa completo que se vera en la pagina, para este usamos el paquete flutter map
  Widget _crearFlutterMap(ScanModel scan) {

    return FlutterMap(
      //el controlador del mapa, como por ejemplo cuando me muevo a otra posicion del mapa, usando este puedo saber volver al inicio especificado.
      mapController: map,
      //los ajustes o opciones para crear el mapa
      options: new MapOptions(
        //la posicion central inicial que se va mostrar al entrar a la pagina, para pasarle esa posicion le pasamos el metodo getLatLng
        center: scan.getLatLng(),
        //el zoom inicial del mapa
        zoom: 12.0,
      ),
      //creamos la capas que tendran el mapa, la primer capa necesariamente tendria que se el mapa principal
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );

  }

  ///creamos la primera capa para la pagina de mapas, esta primera capa sera el mapa como tal, para esto consumimos el servicio de openstreetmap.org el cual nos proveera una capa de mapa.
  _crearMapa() {
    //retornamos el mapa que se va mostrar usando el TileLayerOptions que recibe diferentes argumentos como la url del servcio del cual vamos a obtemer el mapa.
    return TileLayerOptions(
      //le pasamos la estructura para crear la url que vamos a consumir. {s}=subdominios, {z}=zoom, {x}latitud, {y}=lonitud
      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      subdomains: ['a', 'b', 'c'],
      backgroundColor: Colors.white,
      // opacity: 1.0
      // tms: false
    );

  }

  ///la segunda capa de la pagina de mapas sera un marcador, mas especificamente un icono que apunte la coordenada exacta que queremos ver
  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 80.0,
          height: 80.0,
          //el punto en el mapa en el cual va estar el marcador que en este caso le pasamos el metodo getLatLng
          point: scan.getLatLng(),
          builder: (context) => 
          Container(
            child: Icon(
              Icons.location_on,
              size: 50.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ]
    );
  }
}




  //   FlutterMap(
  //     options: MapOptions(
  //       center: scan.getLatLng(),
  //       zoom: 13,
  //     ),
  //     layers: [
  //       _crearMapa(),
  //     ],
  //   );
  // }

  // _crearMapa() {

  //   return TileLayerOptions(
  //     urlTemplate: "https://api.mapbox.com/v4/"
  //           "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
  //       additionalOptions: {
  //         'accessToken': 'pk.eyJ1IjoiZXZlcjE5OTkiLCJhIjoiY2tmMzdlYjVjMDBmNjJzbnRpcHcyMjVpeiJ9.tX39REtszuaHCaNHTd86Uw',
  //         'id': 'mapbox.streets',
  //       },
  //   );
  // }

