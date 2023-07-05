import 'package:cotacao/constants/constants.dart';
import 'package:cotacao/firebase_options.dart';
import 'package:cotacao/pages/auth_or_home_page.dart';
import 'package:cotacao/pages/base_screen.dart';
import 'package:cotacao/repository/login.dart';
import 'package:cotacao/utils/firebase_api.dart';
import 'package:cotacao/utils/internet_status_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'repository/service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Constants.verde));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Login(),
        ),
        ChangeNotifierProvider(
          create: (_) => Services(),
        ),
        ChangeNotifierProvider<InternetStatusProvider>(
          create: (_) => InternetStatusProvider(),
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cotação',
        theme: ThemeData(
          scaffoldBackgroundColor: Constants.cinza,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.verde,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
            iconColor: MaterialStateProperty.all(Colors.white),
          )),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            elevation: 0,
            color: Constants.verde,
          ),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Constants.verde)
              .copyWith(error: Colors.redAccent),
        ),
        navigatorKey: navigatorKey,
        home: const IndexPage(),
        routes: {
          BaseScreen.route: (context) => const BaseScreen(),
        },
      ),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreen(),
    );
  }
}
