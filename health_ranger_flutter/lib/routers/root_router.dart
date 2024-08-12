import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/utils/global_variable.dart';

class NavigationRouter extends StatefulWidget {
  const NavigationRouter({super.key});

  @override
  State<NavigationRouter> createState() => _NavigationRouterState();
}

class _NavigationRouterState extends State<NavigationRouter> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 64,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.25),
            ),
            label: '',
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              color: (_page == 1)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.25),
            ),
            label: '',
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notification_important,
              color: (_page == 2)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.25),
            ),
            label: '',
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
