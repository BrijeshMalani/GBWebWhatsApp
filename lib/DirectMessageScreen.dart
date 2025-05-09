import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils/app_theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'native_ad_widget.dart';

class DirectMessageScreen extends StatefulWidget {
  final String? initialMessage;
  const DirectMessageScreen({this.initialMessage, Key? key}) : super(key: key);

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String _selectedMessage = '';
  bool _isLoading = false;
  String _selectedCountryCode = '+91'; // Default country code

  final List<String> _predefinedMessages = [
    'Hello! How are you?',
    'Can we talk?',
    'I need to discuss something important.',
    'Are you available for a quick chat?',
    'Let\'s catch up soon!',
  ];

  List<String> _commonPhrases = [];
  final String _prefsKey = 'common_phrases_list';

  @override
  void initState() {
    super.initState();
    _loadCommonPhrases();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _messageController.text = widget.initialMessage!;
    }
  }

  Future<void> _loadCommonPhrases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _commonPhrases = prefs.getStringList(_prefsKey) ?? [];
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_numberController.text.isEmpty) {
      _showSnackBar('Please enter a phone number');
      return;
    }

    if (_messageController.text.isEmpty && _selectedMessage.isEmpty) {
      _showSnackBar('Please enter a message');
      return;
    }

    final message = _messageController.text.isNotEmpty
        ? _messageController.text
        : _selectedMessage;

    // Remove any spaces or special characters from the phone number
    String phoneNumber =
        _numberController.text.replaceAll(RegExp(r'[^\d]'), '');

    // Combine country code and phone number
    String fullNumber = _selectedCountryCode + phoneNumber;

    final whatsappUrl =
        'https://wa.me/$fullNumber?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        _showSnackBar('Could not launch WhatsApp');
      }
    } catch (e) {
      _showSnackBar('Error launching WhatsApp: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showCommonPhrasesDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(maxHeight: 400, minWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Common Phrases',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _commonPhrases.isEmpty
                      ? Center(
                          child: Text(
                            'No common phrases found.',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _commonPhrases.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  setState(() {
                                    _messageController.text =
                                        _commonPhrases[index];
                                    _selectedMessage = '';
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    _commonPhrases[index],
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Direct Message'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Enter Phone Number',
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            _selectedCountryCode = '+${country.phoneCode}';
                          });
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCountryCode,
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        hintStyle: TextStyle(color: theme.hintColor),
                        prefixIcon:
                            Icon(Icons.phone, color: AppTheme.primaryColor),
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.primaryColor.withOpacity(0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.primaryColor.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildSection(
              title: 'Write Your Message',
              child: Column(
                children: [
                  TextField(
                    controller: _messageController,
                    maxLines: 4,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      alignLabelWithHint: true,
                      hintStyle: TextStyle(color: theme.hintColor),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      icon: Icon(Icons.list, color: Colors.white, size: 20),
                      label: Text(
                        'Common Phrases',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: _showCommonPhrasesDialog,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Send Message',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildMessageCard(String message) {
    final isSelected = message == _selectedMessage;
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMessage = message;
            _messageController.clear();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
