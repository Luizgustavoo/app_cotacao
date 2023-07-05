import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cotacao/constants/constants.dart';
import 'package:cotacao/pages/nav_screens/home_page.dart';
import 'package:cotacao/pages/login_page.dart';
import 'package:cotacao/pages/nav_screens/recuse_buy.dart';
import 'package:cotacao/pages/nav_screens/waiting_buy.dart';
import 'package:cotacao/repository/login.dart';
import 'package:cotacao/utils/connective_service.dart';
import 'package:cotacao/utils/internet_status_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  static const route = '/base-screen';
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  InternetStatusProvider? _statusProvider;
  int pageIndex = 1;
  List pages = [
    const OrderPage(),
    const HomePage(),
    const RecuseOrderPage(),
  ];

  @override
  void initState() {
    super.initState();
    _statusProvider =
        Provider.of<InternetStatusProvider>(context, listen: false);
    ConnectivityService().connectivityStream.listen(_updateStatus);
  }

  void _updateStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _statusProvider?.setStatus(InternetStatus.disconnected);
    } else {
      _statusProvider?.setStatus(InternetStatus.connected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('COTAÇÕES'),
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<Login>(context, listen: false).logout();
                  Get.offAll(() => const LoginPage());
                },
                icon: const Icon(Icons.exit_to_app_rounded))
          ],
        ),
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          backgroundColor: Colors.transparent,
          color: Constants.verde,
          animationCurve: Curves.easeInOut,
          index: pageIndex,
          items: const [
            Icon(
              Icons.price_check_rounded,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.all_inbox_rounded,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.remove_shopping_cart_rounded,
              size: 30,
              color: Colors.white,
            ),
          ],
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
        ),
        body: Consumer<InternetStatusProvider>(
          builder: (context, statusProvider, _) {
            if (statusProvider.status == InternetStatus.disconnected) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Sem conexão com a internet, conecte-se novamente!',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator()
                ],
              );
            } else {
              return pages[pageIndex];
            }
          },
        ));
  }
}
