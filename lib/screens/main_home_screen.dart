import 'package:carousel_slider/carousel_slider.dart';
import 'package:delarship/screens/favourites_page.dart';
import 'package:delarship/screens/home_page.dart';
import 'package:delarship/screens/profile_page.dart';
import 'package:delarship/screens/search_page.dart';
import 'package:delarship/state/appState/cubit/app_logic.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'mainhome';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;
  final PageController _pageController = PageController();

  final List<Widget> Pages = [
    const HomePage(),
    const FavouritesPage(),
    const SearchPage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppCLogic.get(context).getCars();
  }

  void onTabChange(int index) {
    setState(() {
      selectedPage = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.jpg',
          scale: 2,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            selectedIndex: selectedPage,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabBackgroundGradient: LinearGradient(
              colors: [
                Colors.brown.shade100,
                Colors.brown.shade200,
                Colors.brown.shade300,
              ],
            ),
            onTabChange: onTabChange,
            haptic: true,
            gap: 7,
            tabActiveBorder: Border.all(color: Colors.black, width: 1),
            tabBorderRadius: 30,
            color: Colors.brown.shade100,
            backgroundColor: Colors.black,
            hoverColor: Colors.brown.shade900,
            rippleColor: Colors.brown.shade900,
            curve: Curves.easeInOutQuart,
            padding: const EdgeInsets.all(20),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favourite',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                iconSize: 28,
                icon: Icons.person_4_rounded,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          return PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedPage = index;
              });
            },
            itemBuilder: (context, index) {
              double scale = 1.0;
              double opacity = 1.0;

              if (_pageController.position.haveDimensions) {
                double pageOffset = _pageController.page! - index;
                scale = (1 - (pageOffset.abs() * 0.3)).clamp(0.8, 1.0);
                opacity = (1 - pageOffset.abs()).clamp(0.5, 1.0);
              }

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Pages[index],
                ),
              );
            },
            itemCount: Pages.length,
          );
        },
      ),
    );
  }
}
