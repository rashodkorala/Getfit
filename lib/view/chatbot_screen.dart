import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:getfit/view/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final User? currentUser;

  const ChatPage({super.key, required this.currentUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatUser _currentUser;

  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
          seconds: 60),
    ),
    enableLog: true,
  );



  //final ChatUser _currentUser = ChatUser(id: '1',firstName: 'nick', lastName: 'collins' );

  final ChatUser _gptChatUser = ChatUser(id: '2',firstName: 'chat', lastName: 'GPT' );

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: widget.currentUser?.uid ?? 'default_id',
    firstName: widget.currentUser?.displayName ?? 'User',

    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("ChatBot",
            style: TextStyle(
              color: Colors.white,
            )
        )
    ),
      body: DashChat(currentUser: _currentUser,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.black,
            containerColor: Colors.green,
            textColor: Colors.white,
          ),
          onSend: (ChatMessage m) {
            getChatResponse(m);

          }, messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });
    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.user, content: m.text);
      }
    }).toList();
    final request = ChatCompleteText(model: GptTurbo0301ChatModel(),
      messages: _messagesHistory,
      maxToken: 1000,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(0, ChatMessage(user: _gptChatUser, createdAt: DateTime.now(), text: element.message!.content),
          );
        });
      }
    }
  }
}
