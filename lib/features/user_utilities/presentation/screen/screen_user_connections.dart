import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/features/user_utilities/domain/service_connections.dart';
import 'package:JumpIn/features/user_utilities/presentation/widgets/screen_user_connections_widgets/user_connection_layout.dart';
import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScreenUserConnections extends StatelessWidget {
  final connectionController = ConnectionController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: connectionController.fetchUserConnections(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            // ignore: prefer_const_constructors
            appBar: JumpinAppBar(
              context,
              'Connections(${connectionController.userConnections.length})',
            ),
            drawer: const JumpinNavDrawer(),
            body: StreamBuilder(
                stream: connectionController.getConnectionsList(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return circularProgressIndicator();
                  }
                  return connectionController.userConnections.isEmpty
                      ? Container()
                      : UserConnectionLayout(
                          size: size,
                          connectionController: connectionController);
                }),
          );
        });
  }
}
