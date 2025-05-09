import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'Utils/app_theme.dart';

import 'native_ad_widget.dart';

class TextRepeaterScreen extends StatefulWidget {
  @override
  _TextRepeaterScreenState createState() => _TextRepeaterScreenState();
}

class _TextRepeaterScreenState extends State<TextRepeaterScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _separatorController = TextEditingController();
  String _repeatedText = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _countController.dispose();
    _separatorController.dispose();
    super.dispose();
  }

  void _repeatText() {
    setState(() {
      _isLoading = true;
    });

    if (_textController.text.isEmpty) {
      _showSnackBar('Please enter text to repeat');
      setState(() => _isLoading = false);
      return;
    }

    if (_countController.text.isEmpty) {
      _showSnackBar('Please enter number of repetitions');
      setState(() => _isLoading = false);
      return;
    }

    int count = int.tryParse(_countController.text) ?? 0;
    if (count <= 0) {
      _showSnackBar('Please enter a valid number');
      setState(() => _isLoading = false);
      return;
    }

    String separator = _separatorController.text;
    List<String> repeatedList = List.filled(count, _textController.text);
    _repeatedText = repeatedList.join(separator);

    setState(() {
      _isLoading = false;
    });
  }

  void _copyToClipboard() {
    if (_repeatedText.isEmpty) {
      _showSnackBar('Generate repeated text first');
      return;
    }
    Clipboard.setData(ClipboardData(text: _repeatedText));
    _showSnackBar('Text copied to clipboard');
  }

  void _shareText() {
    if (_repeatedText.isEmpty) {
      _showSnackBar('Generate repeated text first');
      return;
    }
    Share.share(_repeatedText);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _textController.clear();
      _countController.clear();
      _separatorController.clear();
      _repeatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Text Repeater',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Enter Text',
              child: TextField(
                controller: _textController,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: 'Type text to repeat...',
                  hintStyle: TextStyle(color: theme.hintColor),
                  prefixIcon:
                      Icon(Icons.text_fields, color: AppTheme.primaryColor),
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
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildSection(
                    title: 'Repetitions',
                    child: TextField(
                      controller: _countController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: 'Number of times',
                        hintStyle: TextStyle(color: theme.hintColor),
                        prefixIcon:
                            Icon(Icons.repeat, color: AppTheme.primaryColor),
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
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: _buildSection(
                    title: 'Separator',
                    child: TextField(
                      controller: _separatorController,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: 'Add separator (optional)',
                        hintStyle: TextStyle(color: theme.hintColor),
                        prefixIcon:
                            Icon(Icons.space_bar, color: AppTheme.primaryColor),
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
                ),
              ],
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _repeatText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
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
                          Icon(Icons.repeat, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Generate',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (_repeatedText.isNotEmpty) ...[
              SizedBox(height: 32),
              _buildSection(
                title: 'Result',
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _repeatedText,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon:
                                Icon(Icons.copy, color: AppTheme.primaryColor),
                            onPressed: _copyToClipboard,
                            tooltip: 'Copy to Clipboard',
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon:
                                Icon(Icons.share, color: AppTheme.primaryColor),
                            onPressed: _shareText,
                            tooltip: 'Share',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: NativeAdWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    final theme = Theme.of(context);
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
}
