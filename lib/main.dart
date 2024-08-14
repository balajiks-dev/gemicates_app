import 'package:gemicates_flutter_app/presentation/widget/login_page.dart';
import 'package:gemicates_flutter_app/provider/auth_provider.dart';
import 'package:gemicates_flutter_app/provider/provider_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: 'AIzaSyB08yNzN61RbwH29nPtTUoPNGyhl2qaXwQ', appId: '1:518338146731:android:27f1b0f4f657b275fde2ee', messagingSenderId: '518338146731', projectId: 'gemicates-60960')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>  AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>  ProductListProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
