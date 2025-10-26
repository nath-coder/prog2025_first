import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prog2025_firtst/firebase/songs_firebase.dart';

class AddSongScreen extends StatefulWidget {
  @override
  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  SongsFirebase? songFirebase = SongsFirebase();

  String title = '';
  String duration = '';
  String lyrics = '';

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F5F2),
      appBar: AppBar(
        backgroundColor: Color(0xFF3E2C41),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.music_note_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Agregar Canción', style: TextStyle(fontFamily: 'Georgia')),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFF3E2C41), width: 1.5),
                  ),
                  child: _image == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined, size: 40, color: Color(0xFF3E2C41)),
                              SizedBox(height: 8),
                              Text('Selecciona una imagen', style: TextStyle(color: Color(0xFF3E2C41))),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),
              SizedBox(height: 24),
              _buildField(
                icon: Icons.title,
                label: 'Título de la canción',
                onChanged: (val) => title = val,
              ),
              SizedBox(height: 16),
              _buildField(
                icon: Icons.timer,
                label: 'Duración (mm:ss)',
                onChanged: (val) => duration = val,
              ),
              SizedBox(height: 16),
              _buildField(
                icon: Icons.lyrics,
                label: 'Letra',
                onChanged: (val) => lyrics = val,
                maxLines: 6,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E2C41),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.save_alt),
                label: Text('Guardar Canción', style: TextStyle(fontSize: 16, fontFamily: 'Georgia')),
                onPressed: () {

                  if (_formKey.currentState!.validate()) {
                    songFirebase!.songInsert(
                      {
                        "title":title,
                        "duration":duration,
                        "lyrics":lyrics,
                        "cover":"https://img.mlbstatic.com/mlb-images/image/upload/t_16x9/t_w1024/mlb/dpjxrchafbtf27moxbqu"
                      }
                    ).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Canción guardada 🎶'))
                      );
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF3E2C41)),
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Georgia'),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3E2C41)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
      maxLines: maxLines,
      validator: (val) => val!.isEmpty ? 'Este campo es obligatorio' : null,
    );
  }
}
