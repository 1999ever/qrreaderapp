import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scan_bloc.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      //le pasamos el método que trae todos los resuldados del escaneo, y esto sera mostrado en la pantalla
      stream: scansBloc.scansStreamhttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        //si no hay data, osea si el snapshot no tiene data(!=no) retornamos el circularProgres, no hay data porque aun esta cargando.
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        //scans contiene la data del snapshot
        final scans = snapshot.data;
        // print(scans[1].getLatLng());
        //caso contrario, no puse el else porque el return anterior lo va detener hasta que tenga data
        //como ya hay data digo que si noy registros escaneados en el momento que se carga la pagina
        if(scans.length == 0) {
          //retorno que no hay info porque esa base de datos esta creada pero no hay registros
          return Center(child: Text('No hay información'));
        }
        //pero si hay informacion, osea hay registros del escaneo muestro dichos resultados usando el ListView.builder para construir esos resultados en la pagina.
        return ListView.builder(
          //recibe la cantidad de items, en este caso la cantidad de registro escaneados
          itemCount: scans.length,
          //va dibujar los items(registros del escaneo)
          itemBuilder: (context, index) => Dismissible(//crea un widget que puede ser despedido(quitar)
            key: UniqueKey(),//llave unica para cada item, esto lo usa el Dismissible para quitar el elemento de la pagina
            background: Container(color: Colors.red),
            // direction: DismissDirection.startToEnd,
            //recibe el metodo cuando se haga el Dismis, esea cuando se quite dicho registro de la pagina que llame este metodo para que lo elemine completamente y no se vuelva a mostrar cuando carguemos la pagina de nuevo.
            onDismissed: (direction) => scansBloc.borrarScan(scans[index].id),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),
              //el titulo del ListView va ser el valor del escaneo
              title: Text(scans[index].valor),
              //para mostrar el id del escaneo que es unico, y que cuando se elemina su valor, el id igula es eliminado, estos id son autoincrementables
              subtitle: Text('ID: ${scans[index].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () {
                utils.abrirScan(context, scans[index]);
              },
            ),
          ),
        );
      },
    );
  }
}