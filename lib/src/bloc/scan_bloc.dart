import 'dart:async';
//dentro de esta importación tambien esta el scan_model.dart, asi que no es necesario importar dicho archivo
import 'package:qrreaderapp/src/bloc/validator.dart';

import 'package:qrreaderapp/src/providers/db_provider.dart';

///Esta clase va manejar los stream usando el patron singleton y un contructor factory.
///Tambien usamos los Mixins para que la clase ScanBloc disponga de las 2 propiedades de la clase Validator
class ScansBloc with Validator {

  ///instanciamos la misma clase usando el contructor privado
  static final ScansBloc _singleton = new ScansBloc._internal();
  ///factoy constructor
  factory ScansBloc() {
    return _singleton;
  }

  ///Contructor privado que va obtener los Scans de la base de datos
  ScansBloc._internal() {
    // Obtener Scans de la Base de datos
    obtenerScans();
  }

  //Para crear Streams necesito crear o tener un controlador del Stram y este sera de tipo StreamController
  ///Creamos el StramController que dentro de ella van fluir lista de tipo ScanModel
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  ///scansController es el encargado de escuchar la información que fluye atravez del mismo. Este es un Stream de una lista que maneja ScanModel.
  ///Adicionalmete le añadimos el transform el cual va transformar la informacion que fluye en el stream, entonces lo que inicialmente con el sink añadimos al stram una lista de ScanModel sin importar el tipo(http o geo) lo que hacemos con el transform es seleccionar o separar en listas diferentes donde cada lista tendra solor de un tipo(http o geo) dicho resultado del trasnfor lo volvemos a añadir al streamController para que siga fluyendo y al final pueda salir dos listas de ScanModel que seran usados por seraparado, por ejemplo la lista de ScanModel de tipo geo sera utilizada en la pagina de Mapa.
  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validarGeo);//al usar los mixin podemos disponer de forma directa la propiedad validarGeo
  Stream<List<ScanModel>> get scansStreamhttp => _scansController.stream.transform(validarHttp);

  ///Cuando creamos un StreamController necesito tambien de un metodo que cierre dicho Stram para que ya no fluya mas información dentro de ella.
  dispose() {
    //es importante validar usado el ?, porque si el _scansController no tuviera ningun objeto esto me fallaria
    _scansController?.close();
  }

  ///obtnemos todos los scans de la base de datos.
  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getTodosScan());
  }

  ///Método que recibe un argumeto de tipo ScanModel, dicho método que encarga de agregar a la base de datos el valor del argumento que recibe.
  agregarScan(ScanModel scan) async {
    //Llamamos el DBProvider usando su método nuevoScan para pasarle como argumento el argumeto que recibimos y este pueda realizar lo que es el insertado en la base de datos.
    await DBProvider.db.nuevoScan(scan);
    //luego de insertar el resultado del escaneo en la bd procedemos a obtener todos los resultado de la base de datos para que sean mostrados
    obtenerScans();
  }

  ///se encarga de borrar los scans de la base de datos y de la pagina
  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  ///borra todo los datos  
  borrarScanTodos() async {
    DBProvider.db.deleteAll();
    obtenerScans();
  }

}