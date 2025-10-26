import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword( //devuelve un objeto de tipo User o null
      String email, String password) async { 
        //recibe email y password(2para) 
    try {
      //creacion de un objeto con las credenciales, si es correcto devuelve un objeto User
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user; //extraemos el usuario del objeto UserCredential
      user!.sendEmailVerification(); //enviamos correo de verificacion
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<User?> signInWithEmailAndPassword( //devuelve un objeto de tipo User o null
      String email, String password) async { 
        //recibe email y password(2para) 
    try {
      //creacion de un objeto con las credenciales, si es correcto devuelve un objeto User
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user; //extraemos el usuario del objeto UserCredential
      if(user != null && !user.emailVerified){
        await _auth.signOut(); //cerramos sesion
        throw FirebaseAuthException(code: "email-not-verified", message: "Por favor verifique su correo electronico");
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}