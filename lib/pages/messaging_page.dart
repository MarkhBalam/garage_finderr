import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingPage extends StatefulWidget {
  final String chatId;
  final String userId;

  MessagingPage({required this.chatId, required this.userId});

  @override
  _MessagingPageState createState() => _MessagingPageState();
}
