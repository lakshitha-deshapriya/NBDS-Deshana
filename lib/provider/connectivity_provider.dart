import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectivityProvider with ChangeNotifier {
  Connectivity _connectivity;

  Connection _connection = Connection.CONNECTED;

  ConnectivityProvider() {
    _connectivity = Connectivity();
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnection);
  }

  initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    _updateConnection(result);
  }

  _updateConnection(ConnectivityResult result) {
    if (result != null && ConnectivityResult.none != result) {
      if (_connection != Connection.CONNECTED) {
        setConnection(Connection.CONNECTED);
      }
    } else {
      if (_connection != Connection.DISCONNECTED) {
        setConnection(Connection.DISCONNECTED);
      }
    }
  }

  bool get isConnected => _connection == Connection.CONNECTED;
  setConnection(Connection connection) {
    _connection = connection;
    notifyListeners();
  }
}

enum Connection {
  CONNECTED,
  DISCONNECTED,
}
