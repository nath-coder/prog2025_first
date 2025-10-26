//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prog2025_firtst/firebase_options.dart';
import 'package:prog2025_firtst/screens/add_song_screen.dart';
import 'package:prog2025_firtst/screens/calendar_purchase.dart';
import 'package:prog2025_firtst/screens/clothes/add_category.dart';
import 'package:prog2025_firtst/screens/clothes/add_product.dart';
import 'package:prog2025_firtst/screens/clothes/list_category.dart';
import 'package:prog2025_firtst/screens/clothes/list_product.dart';
import 'package:prog2025_firtst/screens/details_screen.dart';
import 'package:prog2025_firtst/screens/home_screen.dart';
import 'package:prog2025_firtst/screens/list_api_movie.dart';
import 'package:prog2025_firtst/screens/list_songs.dart';
import 'package:prog2025_firtst/screens/login_screen.dart';
import 'package:prog2025_firtst/utils/theme_app.dart';
import 'package:prog2025_firtst/utils/value_listener.dart';

import 'screens/add_movie_screen.dart';
import 'screens/list_movies.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //El firebase es asincrono, por eso se utiliza con await
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

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
            "/listdb" : (context) => const ListMovies(),
            "/songdb" : (context) => const ListSongs(), 
            "/listCategory" : (context) => const ListCategory(),
            "/listProduct" : (context) => const ListProduct(),
            "/add_product" : (context) => const AddProduct(),
            "/add_category" : (context) => const AddCategory(),
            "/add" : (context) => const AddMovieScreen(),
            "/listApiMovie" : (context) => const ListApiMovie(),
            "/calendar":(context) => const CalendarPurchasesPage(),
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