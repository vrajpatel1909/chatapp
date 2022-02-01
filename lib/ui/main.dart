import 'package:flutter/material.dart';
import 'chat_screen.dart';


void main(){
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Chat app',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: ChatScreen(),
  );
}
}