import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart'; // سنضيفه لاحقاً

void main() {
  runApp(const AnonymousTweetApp());
}

class AnonymousTweetApp extends StatelessWidget {
  const AnonymousTweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تغريدات مجهولة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const TweetScreen(),
    );
  }
}

class TweetScreen extends StatefulWidget {
  const TweetScreen({super.key});

  @override
  State<TweetScreen> createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  final TextEditingController _controller = TextEditingController();
  final int maxChars = 280;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتب شيئاً أولاً')),
      );
      return;
    }
    Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ التغريدة')),
    );
  }

  void _shareTweet() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتب شيئاً أولاً')),
      );
      return;
    }
    Share.share(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final remaining = maxChars - _controller.text.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء تغريدة مجهولة'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                maxLength: maxChars,
                decoration: const InputDecoration(
                  hintText: 'اكتب تغريدتك هنا...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              remaining >= 0
                  ? 'متبقي: $remaining حرف'
                  : 'تجاوزت الحد بـ ${-remaining} حرف',
              style: TextStyle(
                color: remaining < 0 ? Colors.red : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('نسخ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareTweet,
                    icon: const Icon(Icons.share),
                    label: const Text('مشاركة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}