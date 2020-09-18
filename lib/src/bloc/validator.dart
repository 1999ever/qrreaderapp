import 'dart:async';

import 'package:qrreaderapp/src/models/scan_model.dart';

///clase que se encarga de validar el tipo de scan(http o geo), donde validarGeo contiene la lsita de ScanModel pero solo de tipo geo y validarHttp de la misma manera.
class Validator {
  ///Usando el StreamTransformer tranformamos la lista de ScanModel el cual contiene scans de tipo http y geo, pero al usar el StreamTransformer solo obtnemos los de tipo geo.
  ///El StreamTransformer le especificamos lo que entrar o lo que se va transformar que es un lista de ScanModel y lo que va salir ya tranformado es una nueva lista tambien de ScanModel.
  ///Es por eso del <List<ScanModel>, List<ScanModel>> el primero es lo que recibe y el segundo el lo nuevo que va salir
  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scan, sink) {//entonces el scan recibe y el sink va añadir esa nueva transformacion, ambos solo van aceptar lista de ScanModel porque eso es lo que se le especifico
      //usando del where seleccionamos de la lista de ScanModel solo los que son de tipo geo
      final geoScan = scan.where((s) => s.tipo == 'geo').toList();
      //entonces ahora geoScan va seguir siendo una lista de ScanModel pero solo los que sean de tipo geo
      //volvemos a añadir al stream para que siga fluyendo por el StreamController, pero este ya esta transformado
      sink.add(geoScan);
    }
  );

  ///usando el StreamTransformer tranformamos la lista de ScanModel el cual contiene scans de tipo http y geo, pero al usar el StreamTransformer solo obtnemos los de tipo http y lo añadimos al stream dicha lista.
  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(//crea un StreamTransformer que delega eventos a la función dada.
    //este recive una funcion que dentro de ella tenemos el valor 
    handleData: (scan, sink) {

      final geoScan = scan.where((s) => s.tipo == 'http').toList();

      sink.add(geoScan);
    }
  );

}