// ignore_for_file: unused_field, deprecated_member_use

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/HouseRent/HouseEditor/ShowInfo.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  final String? apartmentId;
  _ChatMessage({required this.text, required this.isUser, this.apartmentId});
}

class AIChatPage extends StatefulWidget {
  const AIChatPage({Key? key}) : super(key: key);

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isSending = false;

  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
    _messages.add(_ChatMessage(text: '202'.tr, isUser: false));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isSending = true;
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('apartments').get();

      final listings = snapshot.docs.map((doc) {
        final data = doc.data();
        final house = (data['house'] ?? '').toString();
        final district = (data['district'] ?? '').toString();
        return {
          'id': doc.id,
          'city': data['city'],
          'district': district.contains('.') ? district.split('.')[1] : district,
          'house': house.contains('.') ? house.split('.')[1] : house,
          'price': data['price'],
          'rooms': data['rooms'],
          'floor': data['floar'],
          'explain': data['explain'],
        };
      }).toList();

      final prompt = '''
You are a helpful rental assistant for a real-estate app called BestRent.
Answer the user's question conversationally and give useful renting advice.
Here is the current list of available apartment listings as JSON:
${jsonEncode(listings)}

If one listing from the list above is a good match for the user's request, include its "id" value.
Respond with ONLY valid JSON, no markdown formatting, no extra commentary, in exactly this shape:
{"reply": "<your conversational reply>", "apartmentId": "<the matching listing id, or null if none matches>"}

User's message: $text
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      String raw = (response.text ?? '').trim();
      if (raw.startsWith('```')) {
        raw = raw
            .replaceAll(RegExp(r'^```[a-zA-Z]*\n?'), '')
            .replaceAll(RegExp(r'```$'), '')
            .trim();
      }

      String replyText = '203'.tr;
      String? apartmentId;
      try {
        final parsed = jsonDecode(raw) as Map<String, dynamic>;
        replyText = (parsed['reply'] ?? '203'.tr).toString();
        final aid = parsed['apartmentId'];
        if (aid != null &&
            aid.toString().toLowerCase() != 'null' &&
            aid.toString().isNotEmpty) {
          apartmentId = aid.toString();
        }
      } catch (_) {
        if (raw.isNotEmpty) replyText = raw;
      }

      if (apartmentId != null &&
          !listings.any((l) => l['id'] == apartmentId)) {
        apartmentId = null;
      }

      setState(() {
        _messages.add(_ChatMessage(
            text: replyText, isUser: false, apartmentId: apartmentId));
      });
    } catch (e) {
      print('AI chat error: $e');
      setState(() {
        _messages.add(_ChatMessage(text: '203'.tr, isUser: false));
      });
    } finally {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  void _openListing(String apartmentId) {
    contentId = apartmentId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.63,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ShowInfo(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('200'.tr),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              itemCount: _messages.length + (_isSending ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return _buildBubble(_messages[index]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '201'.tr,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _send,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: msg.isUser ? const Color(0xFF0D47A1) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              msg.text,
              style: GoogleFonts.lato(
                color: msg.isUser ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
          if (msg.apartmentId != null) _buildListingCard(msg.apartmentId!),
        ],
      ),
    );
  }

  Widget _buildListingCard(String apartmentId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('apartments')
          .doc(apartmentId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final house = (data['house'] ?? '').toString();
        final district = (data['district'] ?? '').toString();
        return Container(
          margin: const EdgeInsets.only(bottom: 8, top: 2),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 8),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                house.contains('.') ? house.split('.')[1] : house,
                style: GoogleFonts.lato(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                '${data['city']} - ${district.contains('.') ? district.split('.')[1] : district}',
                style: GoogleFonts.lato(fontSize: 12.5, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 6),
              Text(
                '${data['price']} ₪ ${'197'.tr}',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _openListing(apartmentId),
                      child: Center(
                        child: Text(
                          '129'.tr,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
