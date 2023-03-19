import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'dart:math';
import '../helpers/constants.dart';
import '../helpers/is_debug.dart';
import '../models/auth0_user.dart';

/// -----------------------------------
///  DEfine STREAM_API_KEY
/// -----------------------------------

/// -----------------------------------
///  Chat Service Singleton
/// -----------------------------------
class ChatService {
  static final ChatService instance = ChatService._internal();

  factory ChatService() {
    return instance;
  }

  ChatService._internal();

  String? _currentChannelId;
  String? _currentEmployeeId;

  /// -----------------------------------
  ///  1- Chat Client
  /// -----------------------------------
  final StreamChatClient client = StreamChatClient(
    STREAM_API_KEY,
    logLevel: isInDebugMode ? Level.INFO : Level.OFF,
  );

  /// -----------------------------------
  ///  2- disconnect
  /// -----------------------------------

  /// -----------------------------------
  ///  3- connectUser
  /// -----------------------------------
  Future<Auth0User?> connectUser(Auth0User? user) async {
    try {
      if (user == null) {
        throw Exception('User was not received');
      }

      await client.connectUser(
        User(
          id: user.id,
          extraData: {
            'image': user.picture,
            'name': user.name,
          },
        ),
        //client.devToken(user.id).rawValue,
        user.streamChatUserToken,
      );
      return user;
    } catch (e, s) {
      print('ConnectUser $e, $s');
    }
  }

  /// -----------------------------------
  ///  4- shouldCreateChat
  /// -----------------------------------

  /// -----------------------------------
  ///  5- shouldReconnectChat
  /// -----------------------------------

  /// -----------------------------------
  ///  6- createSupportChat
  /// -----------------------------------
  Future<Channel> createSupportChat() async {
    // skip if the chat is still open with current employeeId
    /*if (_currentEmployeeId == null) {
      final random = Random();
      final randomNumber = 0 + random.nextInt(availableAgents.length - 0);
      final String employeeId =
          availableAgents[randomNumber].split('|').join('');
      _currentEmployeeId = employeeId;
    }*/

    final _currentEmployeeId = 'rootEmployeeId';

    final channel = client.channel(
      'support',
      //id: _currentChannelId,
      extraData: {
        'name': 'FlutterAuth0 Support',
        'members': [
          'rootEmployeeId',
          client.state.currentUser!.id,
        ]
      },
    );
    await channel.watch();
    _currentChannelId = channel.id;
    return channel;
  }

  Future<void> archiveSupportChat() async {
    await client.hideChannel(
      _currentChannelId!,
      'support',
      clearHistory: true,
    );
    client.channel('support', id: _currentChannelId).dispose();
    _currentChannelId = null;
    _currentEmployeeId = null;
  }

  /// -----------------------------------
  ///  7- createCommunityChat
  /// -----------------------------------

}
