import 'package:cloud_firestore/cloud_firestore.dart';


class SongsFirebase {
  FirebaseFirestore firebaseFirestore= FirebaseFirestore.instance;

  CollectionReference? songsCollection;

  SongsFirebase(){
    songsCollection = firebaseFirestore.collection("songs");
  }

  Future<void> songInsert (Map<String, dynamic> song)async{
    return await songsCollection!.doc().set(song); 
    //El doc() crea un id automatico, una cadena un poco larga, si se
    //requiere un id personalizado, se pone doc("idpersonalizado"), en ese caso controlar que no se repita
  }
  Future<void> songUpdate (String id, Map<String, dynamic> song)async{ //aqui en el map no puede ir en el mapa por que esta un nivel arriba
    //se manda el id aparte, por que esta un nivel arriba
    return await songsCollection!.doc(id).update(song); 
  }
  Future<void> songDelete (String id)async{
    return await songsCollection!.doc(id).delete(); 
  }

  //Suscription a un flujo, el flujo es constante y se subcripbe al flujo se puede escuchar cualquier cambio
  //en lugar de un Future se usa Stream, se contruye el widget a traves de la escuha del Stream
  //El querySnapshot es una lista de documentos
  Stream<QuerySnapshot> songSelectAll(){
    return songsCollection!.snapshots(); //devuelve un flujo de datos, con la coleccion 
  }
  
}