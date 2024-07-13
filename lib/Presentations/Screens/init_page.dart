import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_analytics/Presentations/Screens/BNB_Screens/home_page.dart';
import 'package:flutter_application_analytics/Presentations/Screens/BNB_Screens/business_page.dart';
import 'package:flutter_application_analytics/Presentations/Screens/BNB_Screens/profile_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int selectedIndex = 0;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static List pageNames =['HomePage','BusinessPage','ProfilePage'];

  static const List<Widget> widgetOptions = <Widget>[
    HomePage(),
    BusinessPage(),
    ProfilePage(),
  ];

  @override
  void initState(){
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Analytics')),
      body: Center(child: widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) async {
          await analytics.logEvent(
            name: 'pages_tracked',
            parameters: {
              "page_name": pageNames[index],
              "page_index": index,
            },
          );
          setState(() =>selectedIndex = index);
        }),

    );
  }
}