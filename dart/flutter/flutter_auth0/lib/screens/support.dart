import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../models/auth0_permissions.dart';
import '../models/auth0_user.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/coffee_router.dart';
import '../widgets/button.dart';
import 'menu.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String? availableCustomerServiceId;

  Auth0User? profile = AuthService.instance.profile;
  Channel? channel;

  @override
  void initState() {
    super.initState();

    createChannel();

    /// -----------------------------------
    ///  getProfile from auth service
    /// -----------------------------------

    /// -----------------------------------
    /// get an available customer service agent
    /// -----------------------------------
  }

  createChannel() async {
    if (profile != null) {
      final _channel = await ChatService.instance.createSupportChat();
      setState(() {
        channel = _channel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return channel == null
        ? const Center(
            child: Text('You are in the queue!, please wait...'),
          )

        /// -----------------------------------
        /// implement chat
        /// -----------------------------------
        : Scaffold(
            body: SafeArea(
              child: StreamChannel(
                channel: channel!,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: MessageListView(),
                    ),
                    MessageInput(
                      disableAttachments: !profile!.can(UserPermissions.upload),
                      sendButtonLocation: SendButtonLocation.inside,
                      actionsLocation: ActionsLocation.leftInside,
                      showCommandsButton: !profile?.isInternal,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  CommonButton _closeChat() {
    return CommonButton(
      onPressed: () {
        // todo(mhadaily): do alertDialog to confirm
        ChatService.instance.archiveSupportChat();
        CoffeeRouter.instance.push(MenuScreen.route());
      },
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }
}
