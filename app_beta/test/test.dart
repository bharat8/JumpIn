import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';

class ConnectionTest extends StatefulWidget {
  @override
  _ConnectionTestState createState() => _ConnectionTestState();
}

class _ConnectionTestState extends State<ConnectionTest> {
  ConnectionChecker cc = ConnectionChecker();
  @override
  void initState() {
    super.initState();
    cc.checkConnection(context);
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
