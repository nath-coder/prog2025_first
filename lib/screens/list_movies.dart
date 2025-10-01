import 'package:flutter/material.dart';

import '../database/movies_database.dart';

class ListMovies extends StatefulWidget {
  const ListMovies({super.key});

  @override
  State<ListMovies> createState() => _ListMoviesState();
}

class _ListMoviesState extends State<ListMovies> {

  MoviesDatabase? moviesDB;

  @override
  void initState() {
    super.initState();
    moviesDB = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Peliculas :)"),
        actions: [
          IconButton(
            onPressed: ()=>Navigator.pushNamed(context,"/add").then(  (value){setState(() {
              
            });}), //Con rutas nombradas
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: FutureBuilder(
        future: moviesDB!.SELECT(), 
        builder: (context, snapshot) {
          if( snapshot.hasError ){
            return Center(child: Text('Something was wrong!'),);
          }else{
            if(snapshot.hasData){
              return snapshot.data!.isNotEmpty 
              ? ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final objM = snapshot.data![index];
                  return Container(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(objM.nameMovie!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              Navigator.pushNamed(context,"/add",arguments: objM ).then((value){setState(() {
                                
                              });}); //Con rutas nombradas
                            }, icon: Icon(Icons.edit)),
                          //  Expanded(child: Container()),
                            IconButton(
                              onPressed: () async{
                                return showDialog(
                                  context: context,
                                  builder: (context) => _builAlertDialog(objM.idMovie!)
                                );
                              }, 
                              icon: Icon(Icons.delete)
                            )
                          ],
                        )
                      ],
                    ),
                    
                  
                  );
                },
              )
              : Center(child: Text('No existen registros'),);
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
  Widget _builAlertDialog(int idMovie){
    return AlertDialog(
      title: Text("Atencion :)"),
      content: Text("¿Estas seguro de eliminar este registro?"),
      actions: [
        //Para IOs es tener cuidado con los botones y politicas ya que pide sombreado como boton
        TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Cancelar")),
        TextButton(onPressed: (){
          moviesDB!.DELETE("tblMovies",idMovie).then( (value) {
            String msj="";
            if(value > 0){
              msj="Registro borrado exitosamente";
              setState(() {
                
              });
            }else{
              msj="No se pudo borrar el registro";
            }
            final snackBar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);

          });
        }, child: Text("Aceptar"))
      ],
    );
  }
}