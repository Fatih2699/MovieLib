import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movielib/locator.dart';
import 'package:movielib/onboarding.dart';
import 'package:movielib/screens/home_screen.dart';
import 'package:movielib/view_models/movie_view_models.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(
    showHome: showHome,
  ));
}

class MyApp extends StatefulWidget {
  final bool showHome;
  const MyApp({Key? key, required this.showHome}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MovieViewModel(),
        ),
      ],
      child: MaterialApp(
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   const Locale('tr', 'TR'),
        // ],
        title: 'movieLibs',
        home: widget.showHome ? const HomeScreen() : const OnboardingPage(),
      ),
    );
  }
}
