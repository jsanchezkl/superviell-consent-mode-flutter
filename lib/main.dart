import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'ConsentManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Firebase Analytics instance
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _showConsentFlow();
  }

  Future<void> _showConsentFlow() async {
    bool consentGiven = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Consentimiento de Datos"),
          content: Text("Esta aplicación recopila datos para mejorar su experiencia. ¿Acepta el uso de sus datos?"),
          actions: [
            TextButton(
              child: Text("Rechazar"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (consentGiven != null && consentGiven) {
      _proceedWithUserConsent();
    } else {
      _handleConsentDeclined();
    }
  }

  void _proceedWithUserConsent() {
    // Habilitar la recopilación de datos de Firebase Analytics
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    ConsentManager.storeConsentStatus(true);
    
    print("El usuario ha aceptado el consentimiento.");
  }

  void _handleConsentDeclined() {
    // Deshabilitar la recopilación de datos de Firebase Analytics
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
    ConsentManager.storeConsentStatus(false);
    print("El usuario ha rechazado el consentimiento.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Consent Flow Example"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showConsentFlow,
          child: Text("Mostrar Diálogo de Consentimiento"),
        ),
      ),
    );
  }
}
