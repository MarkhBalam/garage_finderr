import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingPage extends StatefulWidget {
  final String chatId;
  final String userId;

  MessagingPage({required this.chatId, required this.userId});

  @override
  _MessagingPageState createState() => _MessagingPageState();
}
class _MessagingPageState extends State<MessagingPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  void _sendMessage() async {
    if (_controller.text.isNotEmpty && !_isSending) {
      String messageText = _controller.text;
      setState(() {
        _isSending = true;
        _controller.clear(); // Clear the text field immediately
      });

      try {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .collection('messages')
            .add({
          'senderId': widget.userId,
          'text': messageText,
          'timestamp': FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .update({
          'lastMessage': messageText,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Failed to send message: $e');
        setState(() {
          _controller.text = messageText; // Restore text if sending fails
        });
      } finally {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

 