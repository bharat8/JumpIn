import 'package:JumpIn/features/user_utilities/domain/service_connections.dart';
import 'package:JumpIn/features/user_utilities/presentation/widgets/screen_user_connections_widgets/user_connection_card.dart';
import 'package:flutter/material.dart';

class UserConnectionLayout extends StatelessWidget {
  const UserConnectionLayout({
    Key key,
    @required this.size,
    @required this.connectionController,
  }) : super(key: key);

  final Size size;
  final ConnectionController connectionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 9,
          // ignore: sized_box_for_whitespace
          child: Container(
              width: size.width,
              child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  primary: true,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 12,
                  crossAxisCount: 3,
                  children: List.generate(
                      connectionController.userConnections.length,
                      (index) => UserConnectionCard(
                            connectionUser:
                                connectionController.userConnections[index],
                          )))),
        )
      ],
    );
  }
}
