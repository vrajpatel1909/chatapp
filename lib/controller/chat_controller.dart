import 'package:chatapp/model/mess.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  var chatMessages = <Message>[].obs;
  RxInt connectedUser = 0.obs;
}