import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prog2025_firtst/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController conUser=TextEditingController();
  TextEditingController conPwd=TextEditingController();
  bool isValidating=false;
  @override
  Widget build(BuildContext context) {
    
    final txtUser=TextField(
      keyboardType: TextInputType.emailAddress,
      controller: conUser,
      decoration: InputDecoration(
        hintText: 'Correo electronico'
      ),
    );
    final txtPwd= TextField(
      obscureText: true,
      controller: conPwd,
      decoration: InputDecoration(
        hintText: 'Contraseña',
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover, //sirve para ampliar la imgen
            image: AssetImage('assets/gato.png'),
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 150,
              child: Hero(
                tag: "welcomeText",
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'BIENVENIDO',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'Sewer',
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 225,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pinkAccent[100],
                ),
                child: ListView(
                  children: [
                    txtUser,
                    txtPwd,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                         IconButton(
                          onPressed: (){
                            isValidating=true;
                            setState(() {});
                            Future.delayed(Duration(milliseconds: 3000)).then(
                              (value) {
                                Navigator.pushNamed(context, "/home");
                                isValidating=false;
                                setState(() {});
                              },
                              );
                            
                          }, 
                          icon: Icon(Icons.login,size:40)
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 700),
                                pageBuilder: (_, __, ___) =>
                                    const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Crear cuenta",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ]
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 100,
              child: isValidating 
                ? Lottie.asset('assets/paws.json') 
                : Container(),
            ),
          ],
        ),
      ),
    );
  }
}