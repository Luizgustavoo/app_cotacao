import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cotacao/constants/constants.dart';
import 'package:cotacao/pages/login_page.dart';
import 'package:cotacao/pages/nav_screens/home_page.dart';
import 'package:cotacao/pages/nav_screens/recuse_buy.dart';
import 'package:cotacao/pages/nav_screens/waiting_buy.dart';
import 'package:cotacao/repository/login.dart';
import 'package:cotacao/utils/connective_service.dart';
import 'package:cotacao/utils/internet_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BaseScreen extends StatefulWidget {
  static const route = '/base-screen';
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  InternetStatusProvider? _statusProvider;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  int pageIndex = 1;
  int tituloIndex = 1;
  String searchQuery = '';
  List pages = [
    const OrderPage(),
    const HomePage(),
    const RecuseOrderPage(),
  ];

  List<String> titulos = [
    "COTAÇÕES APROVADAS",
    "COTAÇÕES",
    "COTAÇÕES RECUSADAS"
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
      _statusProvider!.setStatus(InternetStatus.disconnected);
      mostrarSnackBar();
    } else {
      _statusProvider!.setStatus(InternetStatus.connected);
    }
  }

  void mostrarSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Você está sem conexão com a internet.'),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.shade400,
      elevation: 3,
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () => Get.back(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titulos[tituloIndex]),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(
                            'SAIR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 17,
                              color: Constants.verde,
                            ),
                          ),
                          content: const Text(
                            'Deseja realmente sair do aplicativo?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  Get.back();
                                });
                              },
                              child: const Text(
                                'CANCELAR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                Provider.of<Login>(context, listen: false)
                                    .logout();
                                Get.offAll(() => const LoginPage());
                              },
                              child: const Text(
                                'CONFIRMAR',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.exit_to_app_rounded))
          ],
        ),
        extendBody: true,
        bottomNavigationBar: GNav(
          backgroundColor: Constants.verde,
          color: Colors.white,
          activeColor: Colors.black,
          curve: Curves.easeInOut,
          iconSize: 30,
          gap: 5,
          duration: const Duration(milliseconds: 150),
          rippleColor:
              Constants.verdeclaro, // tab button ripple color when pressed
          hoverColor: Constants.verdeclaro, // ta
          tabBorderRadius: 30,
          tabs: const [
            GButton(
              icon: Icons.thumb_up_off_alt_outlined,
              text: 'APROVADAS',
            ),
            GButton(
              icon: Icons.receipt_long_outlined,
              text: 'PENDENTES',
            ),
            GButton(
              icon: Icons.thumb_down_alt_outlined,
              text: 'RECUSADAS',
            ),
          ],
          selectedIndex: pageIndex,
          onTabChange: (index) {
            setState(() {
              pageIndex = index;
              tituloIndex = index;
            });
          },
        ),
        body: Consumer<InternetStatusProvider>(
          builder: (context, statusProvider, _) {
            if (statusProvider.status == InternetStatus.disconnected) {
              return Stack(
                children: [
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: const SizedBox(
                          width: double.infinity,
                          height: 120,
                          child: Card(
                            child: ListTile(),
                          ),
                        ),
                      );
                    },
                    itemCount:
                        15, // substitua pelo número de itens na sua lista
                  ),
                ],
              );
            } else {
              return pages[pageIndex];
            }
          },
        ));
  }
}
