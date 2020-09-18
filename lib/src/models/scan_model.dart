import 'package:latlong/latlong.dart';


///Clase que me va permitir manejar la información de un escaneo, es decir yo escaneo un codigo QR y tengo que asignarle un id, saber que tipo es y saber el valor o resultado de ese escaneo.
class ScanModel {
  //id unico para cada escaneo
  int id;
  //el tipo de dato o informacion que se va manejar, como ser una url, una geolocalizacion, etc.
  String tipo;//para esta aplicación solo se va permitir escanear dos tipos: url's y geolocalizaciones
  //el valor del scan, es decir el producto del escaneo
  String valor;

  ///Construnctor el que recibe las propiedades, a este constructor le añadimos una determinacion automatica, es decir una condición que verifica dependiendo al valor que reciba, si recibe una url es de tipo http, y si es una geolocalizaciòn es de tipo geo.
  ScanModel({
    this.id,
    this.tipo,
    this.valor,
  }){//agregamos una condicion que me va permitir diferenciar cuando abrir una pagina web o abrir el mapa con la geolocalización.
    //si el valor contiene la palabra http. .contains() retorna true si contiene el string que se le especifique.
    if(this.valor.contains('http')) {
      //si contiene eso entonces voy a decir que el tipo es igual a http, quiere decir que el tipo una pagina web
      this.tipo = 'http';
    } else {
      //caso contrario el tipo va ser igual a geo(de geolocalización).
      this.tipo = 'geo';
    }
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
    id   : json["id"],
    tipo : json["tipo"],
    valor: json["valor"],
  );

  ///Método que lo que hace es transformar el modelo y regresar un mapa.
  ///
  ///Ejm: la clave id recibe como valor la propiedad id, clave tipo recibe como valor la propiedad tipo
  Map<String, dynamic> toJson() => {
    "id"   : id,//id recibe como valor la propiedad id
    "tipo" : tipo,//tipo recive como valor la propiedad tipo
    "valor": valor,
  };

  ///Método que se encarga obtener la latitud y longitud. esta latitud y longitud venian unidos, por ende abria que separarlos para que puedan ser usadas como coordenadas en un mapa.
  LatLng getLatLng() {
    //geo:-17.384339,-63.981002
    //haciendo uso del substring eliminamos los primero 4 caracteres del string valor, luego usando el split cortamos o separamos donde haya una [,], todo esto va retornar una lista de string porque cada parte que fue separado seran los elementos de dicha lista y esta lista de string se almacenara en la variable latlon.
    final List<String> latlon = valor.substring(4).split(',');

    //como sabemos que aunque latlon es una lista de string, lo que contiene son valores double que estan como strign
    //entonces usando el parse obtnemos los elementos de la lista converitidos a double.
    final lat = double.parse(latlon[0]);
    final lon = double.parse(latlon[1]);

    //el retorno sera de tipo LatLng que este recibe valores doubles que seran la Latitud y Longitud
    return LatLng(lat, lon);
  }
  
}
