//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:prog2025_firtst/screens/details_screen.dart';
import 'package:prog2025_firtst/screens/home_screen.dart';
import 'package:prog2025_firtst/screens/login_screen.dart';
import 'package:prog2025_firtst/utils/theme_app.dart';
import 'package:prog2025_firtst/utils/value_listener.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ValueListener.updTheme,
      builder: (context, value, _) {
        return MaterialApp(
          theme: value ? ThemeApp.darkTheme() : ThemeApp.lightTheme(),
          routes: {
            "/home": (context) => HomeScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == "/details") {
              final url = settings.arguments as String; // recibimos el argumento
              return MaterialPageRoute(
                builder: (context) => DetailsScreen(url: url),
              );
            }
            return null;
          },
          title:' Material App',
          home:LoginScreen(),
        );
      }
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:prog2025_firtst/utils/colors_app.dart' show ColorsApp;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador=0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Practica 1'),
          backgroundColor: Colors.pink,
        ),
        body: Container(
          child:Center(
             child: Text('Contador $contador', style:TextStyle(fontSize: 25,fontFamily: 'Sewer',color: ColorsApp.txtColor))
            ),
          
        ),
        floatingActionButton:
        FloatingActionButton(
          child: Icon(Icons.ads_click),
        onPressed: (){
          contador++;
          print(contador);
          setState(() {
            
          });
        },),
      ),
      
    );
  }

  miEvento(){

  }
}*/
//con scaffold
/*class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  int contador=0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Practica 1'),
          backgroundColor: Colors.pink,
        ),
        body: Container(
          child:Center(
             child: Text('Contador $contador', style:TextStyle(fontSize: 25,fontFamily: 'Sewer',color: ColorsApp.txtColor))
            ),
          
        ),
        floatingActionButton:
        FloatingActionButton(
          child: Icon(Icons.ads_click),
        onPressed: (){
          contador++;
          print(contador);
        },),
      ),
      
    );
  }
  miEvento(){

  }
}*/