import 'dart:math';

import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/model/mess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Color purple = Color(0xFFc5ce7);
  Color black = Color(0xFF191919);
  TextEditingController msgInputController = TextEditingController();

  late IO.Socket socket;
  ChatController chatController = ChatController();


  @override
  void initState() {
    socket = IO.io('http://localhost:4000', IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()

        .build());
    socket.connect();
    setUpSocketListener();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
        children: [
          Expanded(child: Obx(
           ()=> Container(
            padding: EdgeInsets.all(10),
              child: Text("Connected User ${chatController.connectedUser}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),),))),
          Expanded(flex: 9 , child: Obx(
           ()=> ListView.builder(
                itemCount: chatController.chatMessages.length,
                itemBuilder: (context, index){
                  var currentItem = chatController.chatMessages[index];
              return MessageItem(
                sentByMe: currentItem.sentByMe == socket.id,
                message: currentItem.message,
              );
            }),
          )),
          Expanded(child: Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              cursorColor: purple,
              controller: msgInputController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple,
                  ),
                  
                  child: IconButton(onPressed: (){
                    sendMessage(msgInputController.text);
                    msgInputController.text='';
                  },
                  icon: Icon(Icons.send, color: Colors.white,),
                  ),
                )
              ),
            ),
          ))
        ]
      )
    );
  }

  void sendMessage(String text) {
    var messageJson = {
      "message": text,
      "sentByMe": socket.id
    };
    socket.emit('message',messageJson);
    chatController.chatMessages.add(Message.fromJson(messageJson));

  }
  void setUpSocketListener(){
    socket.on('message-receive', (data) => (data){
      print(data);
      chatController.chatMessages.add(Message.fromJson(data));
    });
    socket.on('connected-user', (data) => (data){
      print(data);
      chatController.connectedUser.value = data;
    });
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key, required this.sentByMe, required this.message}) : super(key: key);
final bool sentByMe;
final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3,horizontal: 10),

        decoration: BoxDecoration(
          color: sentByMe?Colors.black : Colors.purple,
          borderRadius: BorderRadius.circular(5)
        ),

        
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(message, style: TextStyle(
              color: sentByMe?Colors.purple:Colors.black.withOpacity(0.7),
              fontSize: 20,
            ),),
            Text("2:00p.m",style: TextStyle(
              color: sentByMe?Colors.purple:Colors.black,
              fontSize: 10,
            ))
          ],
        ),
      ),
    );
  }
}

