import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Stream<ConnectivityResult> get connectivityStream =>
      Connectivity().onConnectivityChanged;
}
