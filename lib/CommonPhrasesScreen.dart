import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/app_theme.dart';

class CommonPhrasesScreen extends StatefulWidget {
  @override
  _CommonPhrasesScreenState createState() => _CommonPhrasesScreenState();
}

class _CommonPhrasesScreenState extends State<CommonPhrasesScreen> {
  List<String> phrases = [];
  final String _prefsKey = 'common_phrases_list';
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phrases = prefs.getStringList(_prefsKey) ??
          [
            'I like your photos, you look really great!',
            'Say hello, I hope we can become good friends.',
            'Saw your status, think very interesting, want to talk to you.',
            'It\'s an honor to be friends with you and I look forward to communicating with you',
          ];
    });
  }

  Future<void> _savePhrases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, phrases);
  }

  void _showPhraseDialog({String? initialText, int? editIndex}) {
    TextEditingController controller = TextEditingController(text: initialText);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 3,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Please enter',
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(color: Colors.black)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String text = controller.text.trim();
                          if (text.isNotEmpty) {
                            setState(() {
                              if (editIndex != null) {
                                phrases[editIndex] = text;
                              } else {
                                phrases.add(text);
                              }
                            });
                            await _savePhrases();
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Save',
                            style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deletePhrase(int index) async {
    setState(() {
      phrases.removeAt(index);
    });
    await _savePhrases();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Common Phrases',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: phrases.isEmpty
                ? Center(
                    child: Text(
                      'No phrases yet. Add one!',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: phrases.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedIndex == index;
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        elevation: isSelected ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    phrases[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: AppTheme.primaryColor),
                                  onPressed: () => _showPhraseDialog(
                                      initialText: phrases[index],
                                      editIndex: index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () => _deletePhrase(index),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle,
                                      color: AppTheme.primaryColor),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => _showPhraseDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Add Common phrases',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
