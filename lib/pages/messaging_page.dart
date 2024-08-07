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

  