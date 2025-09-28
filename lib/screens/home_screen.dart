import 'package:flutter/material.dart';
import 'package:prog2025_firtst/widgets/attribute_widget.dart';
import 'package:prog2025_firtst/screens/check_out_screen.dart';
import 'package:prog2025_firtst/screens/players_screen.dart';
import 'package:prog2025_firtst/utils/value_listener.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import 'catalog_screen.dart';
import 'rewards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color navigationBarColor = Colors.black;
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
         
          //AttributeWidget(progress: 0.7, child: Image.network('https://flutter4fun.com/wp-content/uploads/2020/11/speed.png'))
          CatalogScreen(),
          CheckoutScreen(),
           RewardScreen(),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
          backgroundColor: navigationBarColor,
          waterDropColor: Colors.grey.shade200,
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
              filledIcon: Icons.shopping_bag_rounded,
              outlinedIcon: Icons.shopping_bag_outlined,
            ),
            BarItem(
              filledIcon: Icons.shopping_cart_rounded,
              outlinedIcon: Icons.shopping_cart_outlined,
            ),
            BarItem(
              filledIcon: Icons.emoji_events,
              outlinedIcon: Icons.emoji_events_outlined,
            ),

          ],
        ),
    );
  }
}