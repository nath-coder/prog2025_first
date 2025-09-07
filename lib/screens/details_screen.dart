import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final String url;
  const DetailsScreen({super.key, required this.url});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE0F0), 
              Color(0xFFFFC1E3), 
              Color(0xFFFFA3D6),
            ],
            begin: Alignment(0.3, -1),
            end: Alignment(-0.8, 1),
          ),
        ),
        child: ListView(
          children: [
            // Barra superior dentro de SafeArea
            SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                'Overview',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                  child: Container(
                height: 80,
              )),
              Container(
                width: 80,
                height: 80,
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  child: Stack(
                    children: [
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                      Align(
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                      Align(
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Image.asset( widget.url),
                            ),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Whiskas",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 42,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Text(
                      "Whiskas",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.1),
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                      ),
                    ),
                  ),
                )
      
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
              child: Text(
                "Super smash bros ultimate villagers from the animal crossing series. This troops fight most effectively in large group",
                style:
                    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 28,),
            Row(
              children: [
                SizedBox(
                  width: 28,
                ),
                Expanded(
                  child: Container(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {},
  style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.black, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  ),
  child: const Text(
    'Add Favourite',
    style: TextStyle(color: Colors.black, fontSize: 12),
  ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Container(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFF29758),
                              Color(0xFFEF5D67),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                          // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}