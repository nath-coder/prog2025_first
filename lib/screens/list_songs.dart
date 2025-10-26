import 'package:flutter/material.dart';
import 'package:prog2025_firtst/firebase/songs_firebase.dart';
import 'package:prog2025_firtst/screens/add_song_screen.dart';
import 'package:prog2025_firtst/widgets/song_widget.dart';

class ListSongs extends StatefulWidget {
  const ListSongs({super.key});

  @override
  State<ListSongs> createState() => _ListSongsState();
}

SongsFirebase songsFirebase=SongsFirebase();
class _ListSongsState extends State<ListSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de canciones"),
      ),
      //Aqui ya es StreamBuilder el que vamos a estar usando
      body: StreamBuilder(
        stream: songsFirebase.songSelectAll(),
        builder: (context, snapshot){
          if(snapshot.hasData){ //ya regreso la informacion
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                return SongWidget(snapshot.data!.docs[index].data() as Map<String,dynamic>);
              },
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text("Ocurrio un error"),
            );
          }
          else{ //Significa que hubo un error
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSongScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar canción',
      ),
    );
  }
}