import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:amebo/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages ({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    // Alice: Hey, Bob and Charlie! I've been reading a lot about cryptocurrencies lately. Have you guys invested in any?
// Bob: Hi, Alice! Yeah, I bought some Bitcoin a while ago. It's been doing well so far. How about you, Charlie?
// Charlie: Hey, guys! I'm more into altcoins. Ethereum and Binance Coin have caught my attention. Diversification is key!
// Alice: Interesting! I've been considering Ethereum too. Smart contracts seem like a game-changer. Bob, what made you go for Bitcoin?
// Bob: Well, Bitcoin is the OG, you know? It's seen as a store of value. Plus, the limited supply makes it intriguing.
// Charlie: Absolutely, Bob! But don't you think the volatility is a concern?

   return StreamBuilder(
    stream: FirebaseFirestore.instance
    .collection('chat')
    .orderBy('createdAt', descending: true)
    .snapshots(), 
    builder: (context, chatSnapshots){
      if (chatSnapshots.connectionState == ConnectionState.waiting){
        return const Center(
          child: CircularProgressIndicator()
        );
      }
      if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty){
        return const Center(
          child: Text('No message found'),
        );
      }
      if (chatSnapshots.hasError){
        return const Center(
          child: Text('Something went wrong'),
        );
      }
      final loadedMessages = chatSnapshots.data!.docs;
      return ListView.builder(
        padding: const EdgeInsets.only(
          bottom: 40,
          left: 13,
          right: 13,
        ),
        reverse: true,
        itemCount: loadedMessages.length,
        itemBuilder: (ctx, index) {
          final chatMessage = loadedMessages[index].data();
          final nextChatMessage = index + 1 < loadedMessages.length 
          ? loadedMessages[index + 1].data() : null;
          
          final currentMessageUserId = chatMessage['userID'];
          final nextMessageUserId = nextChatMessage != null 
          ? nextChatMessage['userIDcharlie@gmail.com'] : null;
          final nextUserIsSame = nextMessageUserId == currentMessageUserId;

          if (nextUserIsSame){
            return MessageBubble.next(
              message: chatMessage['text'], 
              isMe: authenticatedUser.uid == currentMessageUserId,
              );
          } else {
            return MessageBubble.first(
              userImage: chatMessage['userImage'], 
              username: chatMessage['username'], 
              message: chatMessage['text'], 
              isMe: authenticatedUser.uid == currentMessageUserId)
              ;
          }

        }
         );
    }
    );
   
   
  }
}


