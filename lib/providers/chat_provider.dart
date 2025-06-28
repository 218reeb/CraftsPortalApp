import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crafts_portal/models/chat_model.dart';
import 'package:crafts_portal/models/user_model.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChats(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('chats')
          .where('participant1Id', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      final snapshot2 = await _firestore
          .collection('chats')
          .where('participant2Id', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      final allChats = <ChatModel>[];
      
      allChats.addAll(snapshot.docs
          .map((doc) => ChatModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})));
      
      allChats.addAll(snapshot2.docs
          .map((doc) => ChatModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})));

      // Sort by last message time
      allChats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      
      _chats = allChats;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load chats: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String chatId) async {
    _messages = [];
    _error = null;
    notifyListeners();

    // Cancel previous subscription
    await _messagesSubscription?.cancel();

    try {
      _messagesSubscription = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots()
          .listen((snapshot) {
        _messages = snapshot.docs
            .map((doc) => MessageModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList();
        
        // Sort by timestamp (oldest first)
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        
        notifyListeners();
      });
    } catch (e) {
      _error = 'Failed to load messages: $e';
      notifyListeners();
    }
  }

  Future<String?> createChat(String participant1Id, String participant2Id) async {
    try {
      // Check if chat already exists
      final existingChat = await _firestore
          .collection('chats')
          .where('participant1Id', whereIn: [participant1Id, participant2Id])
          .where('participant2Id', whereIn: [participant1Id, participant2Id])
          .get();

      if (existingChat.docs.isNotEmpty) {
        return existingChat.docs.first.id;
      }

      // Create new chat
      final chat = ChatModel(
        id: '',
        participant1Id: participant1Id,
        participant2Id: participant2Id,
        createdAt: DateTime.now(),
        lastMessageTime: DateTime.now(),
        lastMessage: '',
        lastMessageSenderId: '',
      );

      final docRef = await _firestore.collection('chats').add(chat.toMap());
      return docRef.id;
    } catch (e) {
      _error = 'Failed to create chat: $e';
      notifyListeners();
      return null;
    }
  }

  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    try {
      final message = MessageModel(
        id: '',
        chatId: chatId,
        senderId: senderId,
        content: content,
        timestamp: DateTime.now(),
        type: type,
      );

      // Add message to chat
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());

      // Update chat's last message
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': content,
        'lastMessageTime': Timestamp.fromDate(DateTime.now()),
        'lastMessageSenderId': senderId,
        'isRead': false,
      });

      return true;
    } catch (e) {
      _error = 'Failed to send message: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> markChatAsRead(String chatId, String currentUserId) async {
    try {
      final chat = _chats.firstWhere((c) => c.id == chatId);
      if (chat.lastMessageSenderId != currentUserId) {
        await _firestore.collection('chats').doc(chatId).update({
          'isRead': true,
        });

        // Update local chat
        final index = _chats.indexWhere((c) => c.id == chatId);
        if (index != -1) {
          _chats[index] = chat.copyWith(isRead: true);
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Failed to mark chat as read: $e';
      notifyListeners();
    }
  }

  Future<UserModel?> getChatParticipant(String chatId, String currentUserId) async {
    try {
      final chat = _chats.firstWhere((c) => c.id == chatId);
      final otherUserId = chat.getOtherParticipantId(currentUserId);
      
      final doc = await _firestore.collection('users').doc(otherUserId).get();
      if (doc.exists) {
        return UserModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      _error = 'Failed to get chat participant: $e';
      notifyListeners();
      return null;
    }
  }

  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 