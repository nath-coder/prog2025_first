import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  SongWidget(this.song,{super.key}); 
  Map<String,dynamic> song;
  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  @override
  Widget build(BuildContext context) { 
    //Cuando se genera el widget no se requiere scaffold
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Row(
        children: [
          FadeInImage(
            placeholder: AssetImage("assets/player1.png"),
            fadeInDuration: Duration(seconds: 8),
            image: NetworkImage(widget.song["cover"]),
          ),
        ],
      ),
    );
  }
}