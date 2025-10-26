import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:prog2025_firtst/firebase/fire_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  FireAuth? fireAuth;
  File? _avatar;
  bool isRegistering = false;

  @override
  void initState() {
    super.initState();
    fireAuth = FireAuth();
    
  }
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _avatar = File(picked.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isRegistering = true;
      });

      fireAuth!.registerWithEmailAndPassword(
        _emailCtrl.text.trim(), 
        _pwdCtrl.text.trim()
      ).then((user) {
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registro exitoso! Verifica tu correo."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // vuelve al LoginScreen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error en el registro"),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          isRegistering = false;
        });
      });
      /*Future.delayed(const Duration(milliseconds: 3000)).then((_) {
        setState(() {
          isRegistering = false;
        });

        Navigator.pop(context); // vuelve al LoginScreen
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtName = TextFormField(
      controller: _nameCtrl,
      decoration: const InputDecoration(
        hintText: "Ingresa tu nombre completo",
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        errorStyle: const TextStyle(
          color: Colors.black, // color deseado
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? "Campo requerido" : null,
    );

    final txtEmail = TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: "Correo electrónico",
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        errorStyle: const TextStyle(
          color: Colors.black, // color deseado
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Campo requerido";
        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!regex.hasMatch(v)) return "Correo inválido";
        return null;
      },
    );

    final txtPwd = TextFormField(
      obscureText: true,
      controller: _pwdCtrl,
      decoration: const InputDecoration(
        hintText: "Ingresa una contraseña segura",
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        errorStyle: const TextStyle(
          color: Colors.black, // color deseado
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? "Campo requerido" : null,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
              Color(0xFFF8BBD0), // rosa claro
              Color.fromARGB(255, 88, 34, 81), // negro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 120,
              child: Hero(
                tag: "welcomeText",
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    "CREAR CUENTA",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: "Sewer",
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pinkAccent[100],
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: _avatar != null
                                    ? FileImage(_avatar!)
                                    : const AssetImage("assets/avatar_placeholder.png")
                                        as ImageProvider,
                              ),
                              PopupMenuButton<ImageSource>(
                                icon: const Icon(Icons.camera_alt, color: Colors.black),
                                onSelected: _pickImage,
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: ImageSource.gallery,
                                    child: Text("Galería"),
                                  ),
                                  const PopupMenuItem(
                                    value: ImageSource.camera,
                                    child: Text("Cámara"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        txtName,
                        const SizedBox(height: 15),
                        txtEmail,
                        const SizedBox(height: 15),
                        txtPwd,
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: _submit,
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.white, size: 40),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Ya tengo cuenta",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 300,
              child: isRegistering 
                ? Lottie.asset('assets/ok.json') 
                : Container(),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
