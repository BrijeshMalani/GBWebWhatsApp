import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_whatsapp_clone/Utils/app_theme.dart';
import 'package:share_plus/share_plus.dart';

import 'native_ad_widget.dart';

class WhatscaptionScreen extends StatelessWidget {
  final List<String> captions = [
    "Life is short. Smile while you still have teeth!",
    "Weekend, please stay a little longer.",
    "I'm not lazy, I'm just on my energy-saving mode.",
    "Be yourself; everyone else is already taken.",
    "Dream big. Work hard. Stay focused.",
    "Don't watch the clock; do what it does. Keep going.",
    "Stay strong. Make them wonder how you're still smiling.",
    "Hustle until your haters ask if you're hiring.",
    "Good vibes only!",
    "Slay them with success.",
    "I'm not special. I'm just a limited edition.",
    "Friday is proof that we survived the week.",
    "Collect moments, not things.",
    "Less perfection, more authenticity.",
    "Escape the ordinary.",
    "Do more things that make you forget to check your phone.",
    "Start each day with a grateful heart.",
    "Smiles are contagious, spread them.",
    "Kind people are my kinda people.",
    "Make today so awesome, yesterday gets jealous."
  ];

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  void shareCaption(String text) {
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WhatsCaptions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: captions.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          captions[index],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2.50,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    copyToClipboard(context, captions[index]),
                                icon: Icon(Icons.copy, size: 18),
                                label: Text('Copy'),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2.50,
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.share, size: 18),
                                label: Text('Share'),
                                onPressed: () => shareCaption(captions[index]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          NativeAdWidget(),
        ],
      ),
    );
  }
}
