import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
//al hacer el export le estoy diciendo que en donde yo use o yo importe el db_provider.dart tambien este incluya el scan_model.dart
export 'package:qrreaderapp/src/models/scan_model.dart';

///Clase que se va encarga de manejar la base de datos, para esto usamos sqflite. Va permitir hacer un CRUD(crear, obtener, actualizar y eliminar). Voy a necesitar crear una base de datos, crear una instancia, verificar si existe y si no existe crearla y si existe pues usar la misma, etc, etc.
///
///Esta clase voy a necesitar que sea implementada mediante el patron singleton, es dicir que solo podamos tener una sola instancia de DBProvider de manera global en mi aplicación, esto es con el fin de que yo no tenga multiples instancias de dicha clase o sea que sea una sola.
class DBProvider {
  //propiedad estatica de tipo Database(Base de datos para enviar comandos sql. Crear cuando la base de datos este abieta)
  static Database _database;
  ///Instacia de la misma clase va ser igual al constructor privado. Cuando yo quiera usar la base de datos voy hacer referencia a esta propiedad y de esa manera pueda usarla.
  static final DBProvider db = DBProvider._();

  ///Constructor privado que me va servir para que la propiedad db que es estatica que no se este reinicializando
  DBProvider._();

  ///Getter database para obtener la información de la propiedad privada _database. El tipo va ser un Future que retorna un objeto de tipo Database.
  Future<Database> get database async {
    //condicion: si database es diferente de null quiere decir que hay información y que ya fue instanciada la base de datos y por ende retornamos.
    if(_database != null) return _database;
    //caso contrario quiere decir no existe, osea es nula la instancia de la base de datos, por lo cual voy tener que crear una nueva instancia.
    _database = await initDB();
    //como no hay creamos la base de datos al llamar initDB entonces retornamos la base de datos.
    return _database;

  }

  ///Método para crear la base de datos, este va ser usado cuando no haya sido instanciada la base de datos
  initDB() async {
    //documentsDirectory va contener el directorio de donde se va encontrar la base de datos o donde se encuentra la base de datos en caso de que ya fuera creado
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //path va contener la ruta completamente, osea el archivo exacto en donde va estar o esta la base de datos que en ete caso dicho archivo se va llamar ScanDB.db
    final path = join(documentsDirectory.path, 'ScanDB.db');
    //creamos la base de datos con sqflite. abrimos la base de datos en la ruta dada
    return await openDatabase(
      //le pasamos la ruta
      path,
      //maneja las versions de la base de datos, es util por ejemplo cuando hacemos algun cambio en esta base de datos entonces lo ideal es que incrementemos en 1 la version, porque cuando quiera vuelva a llamar este metodo y tiene la misma version simplemente regresa la misma base de datos, pero si la version ya es mayor y llamo dicho metedo y ta teneia la version anterior entonces va ser los cambios que fueron añadidos.
      version: 1,
      //
      onOpen: (db) {
        
      },
      //cuando se va crear la base de datos se va recibir la siguiente funcion async que recibe la instancia de la base de datos y la version de dicha base de datos.
      onCreate: (Database db, int version) async {
        //al tener simplemente el onCreate ya esta creada la base de datos, y ahora solo añadimos nuestra primera tabla de nombre Scans.
        await db.execute(//el db esta haciendo referencia a la instancia creada de la base de datos
          //enviamos la sentencia sql(sql comun y corriente) en strings. id, tipo y valor son lo mismos datos de mi modelo
          'CREATE TABLE Scans ('//nombre de la tabla
          ' id INTEGER PRIMARY KEY,'//campo id
          ' tipo TEXT,'//campo tipo
          ' valor TEXT'//campo valor
          ')'
        );
      },
    );
  }

  /// [CREAR Registros] en la base de datos, es decir poder insertar registros en la tabla Scans, recibe el ScanModel que es el que maneja el escaneo
  nuevoScanRaw(ScanModel nuevoScan) async {
    //verficamos si tenemos lista la base de datos para poder escribir en ella, para eso llamamos el getter database que es ahi en donde se verifica si la base de datos ya fue instanciada(creada) o no.
    //el await es para que espere se haga la verificacion de que si esta o no creada la base de datos, mientra no este creada no hace nada, espera a que se cree para luego seguir
    final db = await database;
    //realizamos el proceso de insertar registros usando el rawInsert(que inserta una fila)
    final resultado = await db.rawInsert(//enviamos la sentencia sql
      //Insert para insertar en la tabla Scans y ponemos los campos en donde se va gravar la información
      "INSERT Into Scans (id, tipo, valor) "
      //Values para pasar los valores del ScanModel(maneja el proceso de escaneo) a la tabla Scans a sus respectivos campos
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
    );
    //retornamos el resultado que es el numero de inserciones que se hizo que en este caso solo hicimos una insercion.
    return resultado;
  }

  //otra forma de insertar datos a la base de datos, esta es mas sencilla
  /// [CREAR Registros] en la base de datos, es decir poder insertar registros en la tabla Scans, recibe el argumento de tipo ScanModel que es el que maneja el escaneo.
  nuevoScan(ScanModel nuevoScan) async {
    //recibimos la instacia de la base da datos para saber si ya puedo escribir o añadir datos a dicha bd.
    final db = await database;
    //insertamos datos usando el insert el cual recibe el nombre de la tabla y los valores en forma de mapa, para los valores llamamos el metodo toJson
    final resultado = await db.insert('Scans', nuevoScan.toJson());
    return resultado;

  }

  /// [SELECT - Obtener información] mediante el id. Recibimos un id para poder obtener los datos segun el id que tiene cada escaneo.
  Future<ScanModel> getScanId(int id) async {
    //recibimos la instacia de la base da datos para saber si ya puedo escribir o en este caso obtener datos.
    final db = await database;
    //realizamos la consulta a la base de datos usando el método query que recibe el nombre de la tabla, la condición where(el id va ser igual a ? que significa argumetos) y el whereArgs(los argumentos para el where que en este caso el id que recibimos como argumento).
    final resultado = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    //el resultado es un listado de mapas. verificamos si resultado no esta vacio, si no esta vacio regresamos el factory constructor fromJson que recibe un mapa, pero especficamos el first elemento porque cada elemento de la lista es un mapa, pero si esta vacio regreso un null.
    return resultado.isNotEmpty ? ScanModel.fromJson(resultado.first) : null;

  }

 /// [SELECT - Obtener información] todos los datos.
  Future<List<ScanModel>> getTodosScan() async {

    final db = await database;
    //lo mismo que el anterior, pero solo que aca no envio la condicion where, porque queiro obtener todos los datos de dicha tabla.
    final resultado = await db.query('Scans');
    //como resultado es un lista de mapa entonces verifico si no esta vacio barro cada elemento y como cada elemento es un mapa entoces uso el fromJson que este recibe un mapa
    List<ScanModel> list = resultado.isNotEmpty
                                              ? resultado.map((scan) => ScanModel.fromJson(scan)).toList() 
                                              : [];//caso contrario regresa una lista vacia
    return list;

  }

 /// [SELECT - Obtener información] mediante el tipo. Recibe como argumento el tipo ya sea http o geo.
    Future<List<ScanModel>> getScanPorTipo(String tipo) async {
    //verificamos si la base de datos fue instanciada o no
    final db = await database;
    //realizamos la consulta usando el rawQuery(consulta de seleccion SQL sin procesar) y le pasamos la consulta sql
    final resultado = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");//el tipo es igual al tipo que estoy recibiendo como argumentos.
    //este proceso es igula al enterion método
    List<ScanModel> list = resultado.isNotEmpty
                                              ? resultado.map((c) => ScanModel.fromJson(c)).toList() 
                                              : [];
    return list;

  }

  /// [ACTUALIZAR Registros], recibimos la instacia 
  Future<int> updateScan(ScanModel nuevoScan) async {
    //como en los anteriores verifico si ya existe la base de datos, etc, etc.
    final db = await database;
    //actualizamos datos usando el método update al que le pasamos el nombre de la tabla, los valores que quiro actualizar(similar a insertar datos nuevos) en donde usamos el toJson, luego la condicion where donde el id = ?(argmentos) y el whereArgs el cual le paso el id del nuevo escaneo y este id tiene que coincidir con el id del scaneo que quiero actualizar.
    final resultado = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    //el resultado va ser entero, la cantidad de update(actualizaciones) que hizo
    return resultado;

  }


  /// [ELIMINAR Registros] solo uno, recibe el id del escaneo que quiero eliminar
  Future<int> deleteScan(int id) async {

    final db = await database;
    //para eliminar uso el método delete que recibe el nombre de la tabla, la condición where en donde decimos que el id debe ser igual al argumento que en este caso el wherArgs recibe el id que recibimos como argumento.
    final resultado = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    //el resultado va ser la cantidad de registros eliminados
    return resultado;
    //un drop en sqlite borra toda la tabla
  }

  /// [ELIMINAR Registros] todos los registros de la tabla
  Future<int> deleteAll() async {

    final db = await database;
    //para eliminar todos los registros usamos el método rawDelete que recibe la sentencia sql
    final resultado = await db.rawDelete('DELETE FROM Scans');
    //resultado es la cantidad de registros eliminados
    return resultado;

  }

}