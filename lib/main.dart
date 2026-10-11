import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تأكد من تهيئة Firebase هنا إذا قمت بربطه بالمشروع
  runApp(AnonymousTweetApp());
}

class AnonymousTweetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تغريدات مجهولة',
      theme: ThemeData.dark(), // ثيم ليلي يناسب التطبيق
      home: FeedScreen(),
    );
  }
}

// شاشة عرض التغريدات المجهولة
class FeedScreen extends StatelessWidget {
  final TextEditingController _tweetController = TextEditingController();

  // دالة لإرسال التغريدة إلى قاعدة البيانات دون أي هوية
  void _postTweet(String text) {
    if (text.trim().isNotEmpty) {
      FirebaseFirestore.instance.collection('tweets').add({
        'content': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _tweetController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تغريدات مجهولة 🕶️')),
      body: Column(
        children: [
          // جزء كتابة التغريدة الجديدة
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tweetController,
                    decoration: InputDecoration(
                      hintText: 'اكتب تغريدة مجهولة الهوية...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () => _postTweet(_tweetController.text),
                ),
              ],
            ),
          ),
          Divider(),
          // عرض التغريدات المنشورة بشكل فوري ومتجدد
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tweets')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var tweet = docs[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person_outline),
                          backgroundColor: Colors.grey,
                        ),
                        title: Text('مستعمل مجهول'),
                        subtitle: Text(tweet['content'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
