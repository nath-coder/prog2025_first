import 'package:flutter/material.dart';
import 'package:prog2025_firtst/components/attribute_widget.dart';
import 'package:prog2025_firtst/screens/players_screen.dart';
import 'package:prog2025_firtst/utils/value_listener.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color navigationBarColor = Colors.pink[100]!;
  int selectedIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 207, 217),
        actions: [
          ValueListenableBuilder(valueListenable: ValueListener.updTheme, 
          builder: (context, value, _) {
            return !value 
            ? IconButton(icon: Icon(Icons.nightlight), onPressed: () {
              ValueListener.updTheme.value = !ValueListener.updTheme.value;
            })

            :IconButton(icon: Icon(Icons.sunny), onPressed: () {
              ValueListener.updTheme.value = !ValueListener.updTheme.value;
            });
          })
        ],
      ),
      drawer:Drawer(),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: const [
          PlayersScreen(),
          //Center(child: Text("Página 2 - Favoritos")),
          AttributeWidget(
            progress: 5.0, // <-- con decimal
            image: 'assets/gato.png',
            //child: Image.asset( 'assets/gato.png'),
          ),

          //AttributeWidget(progress: 0.7, child: Image.network('https://flutter4fun.com/wp-content/uploads/2020/11/speed.png')),
          Center(child: Text("Página 3 - Email")),
          Center(child: Text("Página 4 - Carpeta")),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
          backgroundColor: navigationBarColor,
          waterDropColor: Colors.pink,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              filledIcon: Icons.bookmark_rounded,
              outlinedIcon: Icons.bookmark_border_rounded,
            ),
            BarItem(
                filledIcon: Icons.favorite_rounded,
                outlinedIcon: Icons.favorite_border_rounded),
            BarItem(
              filledIcon: Icons.email_rounded,
              outlinedIcon: Icons.email_outlined,
            ),
            BarItem(
              filledIcon: Icons.folder_rounded,
              outlinedIcon: Icons.folder_outlined,
            ),
          ],
        ),
    );
  }
}