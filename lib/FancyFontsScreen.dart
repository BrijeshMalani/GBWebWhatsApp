import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'DirectMessageScreen.dart';

class FancyFontsScreen extends StatefulWidget {
  @override
  State<FancyFontsScreen> createState() => _FancyFontsScreenState();
}

class _FancyFontsScreenState extends State<FancyFontsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _controller = TextEditingController();
  ScrollController _textScrollController = ScrollController();
  String get inputText => _controller.text;
  String _originalInput = '';

  final List<String> fancyFonts = [
    'Ÿöü Ţȩẍẗ', // Fancy accents
    'YOU TEXT', // Uppercase
    'YØU ŦɆӾŦ', // Nordic style
    'ʏoᴜ ᴛᴇxᴛ', // Small caps
    'You Text', // Normal
    'Y🄾🅄 T🄴🅇🅃', // Enclosed bold
    'ʎon ʇǝxʇ', // Upside down
    'ʎoʇ ʇǝxʇ', // Weird flipped
    'үoυ тeхт', // Slavic touch
    'Ｙｏｕ Ｔｅｘｔ', // Fullwidth
    'ʸᵒᵘ ᵗᵉˣᵗ', // Superscript
    '🄨🄾🅄 🄏🄴🅇🅃', // Fancy enclosed
  ];

  final List<String> symbols = [
    '༄',
    '༅',
    '≋',
    '✧',
    '༆',
    '☞',
    '☜',
    '☛',
    '☚',
    '♥',
    '❥',
    'ღ',
    '❦',
    '❧',
    '❣',
    '“',
    '”',
    '«',
    '»',
    '★',
    '☆',
    '✪',
    '✯',
    '✰',
    '✶',
    '✷',
    '✸',
    '✹',
    '✺',
    '✻',
    '✼',
    '✽',
    '✾',
    '✿',
    '❀',
    '❁',
    '❂',
    '❃',
    '❄',
    '❅',
    '❆',
    '❇',
    '❈',
    '❉',
    '❊',
    '❋',
    '❌',
    '✔',
    '✖',
    '✗',
    '✘',
    '✙',
    '✚',
    '✛',
    '✜',
    '✝',
    '✞',
    '✟',
    '✠',
    '✡',
    '✢',
    '✣',
    '✤',
    '✥',
    '✦',
    '✧',
    '✩',
    '✪',
    '✫',
    '✬',
    '✭',
    '✮',
    '✯',
    '✰',
    '✱',
    '✲',
    '✳',
    '✴',
    '✵',
    '✶',
    '✷',
    '✸',
    '✹',
    '✺',
    '✻',
    '✼',
    '✽',
    '✾',
    '✿',
    '❀',
    '❁',
    '❂',
    '❃',
    '❄',
    '❅',
    '❆',
    '❇',
    '❈',
    '❉',
    '❊',
    '❋',
  ];

  final List<String> happyEmojis = [
    '(^▽^)',
    '(*^▽^*)',
    '(´ ∀ ` *)',
    '(⌒‿⌒)',
    '(´｡• ω •｡`)',
    '(￣ω￣)',
    '(o^▽^o)',
    '(*≧ω≦*)',
    '(☆▽☆)',
    '(⌒▽⌒)☆',
    '｡ﾟ( ﾟ^∀^ﾟ)ﾟ｡',
    '( ´ ▽ ` )',
    '(￣▽￣)',
    '(=^･^=)',
    '(=^･ω･^=)',
    '(=^･ｪ･^=)',
    '(*^‿^*)',
    '(✯◡✯)',
    '(◕‿◕)',
    '(◕ᴗ◕✿)',
    '(✿◠‿◠)',
    '(❁´◡`❁)',
    '(｡•̀ᴗ-)✧',
    '( ͡° ͜ʖ ͡°)',
    '( ͡ᵔ ͜ʖ ͡ᵔ )',
    '( ͡~ ͜ʖ ͡°)',
    '( ͡o ͜ʖ ͡o)',
    '( ͡◉ ͜ʖ ͡◉)',
    '(¬‿¬)',
    '(¬_¬)',
    '(¬‿¬ )',
    '(¬_¬ )',
  ];

  // List of conversion functions matching fancyFonts order
  late final List<String Function(String)?> fontConverters;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fontConverters = [
      _toDoubleDot, // for 'Ÿöü Ţȩẍẗ'
      (s) => s.toUpperCase(), // for 'YOU TEXT'
      _toLeet, // for 'YØU ŦɆӾŦ'
      _toSmallCaps, // for 'ʏoᴜ ᴛᴇxᴛ'
      (s) => s, // for 'You Text'
      _toBoxed, // for 'Y🄾🅄 T🄴🅇🅃'
      _toUpsideDown, // for 'ʎon ʇǝxʇ'
      _toUpsideDown, // for 'ʎoʇ ʇǝxʇ'
      (s) => s, // for 'үoυ тeхт'
      _toFullwidth, // for 'Ｙｏｕ Ｔｅｘｔ'
      _toSuperscript, // for 'ʸᵒᵘ ᵗᵉˣᵗ'
      _toBoxed, // for '🄨🄾🅄 🄏🄴🅇🅃'
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    _textScrollController.dispose();
    super.dispose();
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied!', style: GoogleFonts.poppins()),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _deleteText() {
    setState(() {
      _controller.clear();
    });
  }

  void _insertAtCursor(String value) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      value,
    );
    final newSelectionIndex = selection.start + value.length;
    setState(() {
      _controller.text = newText;
      _controller.selection =
          TextSelection.collapsed(offset: newSelectionIndex);
    });
  }

  // Font conversion functions for each style
  List<String> getConvertedFonts(String text) {
    return [
      // Example conversions, you can expand with more advanced logic or packages
      _toDoubleDot(text),
      text.toUpperCase(),
      _toLeet(text),
      _toCircled(text),
      _toSmallCaps(text),
      _toTitleCase(text),
      _toBoxed(text),
    ];
  }

  String _toDoubleDot(String text) {
    // Simple example: add umlauts to each vowel
    return text.replaceAllMapped(
        RegExp(r'[aeiouAEIOU]'), (m) => m.group(0)! + '\u0308');
  }

  String _toLeet(String text) {
    return text
        .replaceAll('A', 'Å')
        .replaceAll('a', 'å')
        .replaceAll('E', 'Ξ')
        .replaceAll('e', 'ξ')
        .replaceAll('I', 'ɪ')
        .replaceAll('i', 'ɪ')
        .replaceAll('O', 'Ø')
        .replaceAll('o', 'ø')
        .replaceAll('U', 'Ʊ')
        .replaceAll('u', 'ʉ')
        .replaceAll('T', 'Ŧ')
        .replaceAll('t', 'ŧ')
        .replaceAll('X', 'Ӿ')
        .replaceAll('x', 'Ӿ');
  }

  String _toCircled(String text) {
    // Only works for a-z
    return text.split('').map((c) {
      if (RegExp(r'[a-z]').hasMatch(c)) {
        return String.fromCharCode(c.codeUnitAt(0) + 0x246F - 0x61);
      } else if (RegExp(r'[A-Z]').hasMatch(c)) {
        return String.fromCharCode(c.codeUnitAt(0) + 0x24B6 - 0x41);
      } else if (c == ' ') {
        return ' ';
      } else {
        return c;
      }
    }).join();
  }

  String _toSmallCaps(String text) {
    // Only works for a-z
    return text.toLowerCase().split('').map((c) {
      if (RegExp(r'[a-z]').hasMatch(c)) {
        return String.fromCharCode(c.codeUnitAt(0) + 0x1D00 - 0x61);
      } else {
        return c;
      }
    }).join();
  }

  String _toTitleCase(String text) {
    return text
        .split(' ')
        .map((w) => w.isNotEmpty
            ? w[0].toUpperCase() + w.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  String _toBoxed(String text) {
    // Only works for A-Z
    return text.toUpperCase().split('').map((c) {
      if (RegExp(r'[A-Z]').hasMatch(c)) {
        return String.fromCharCode(c.codeUnitAt(0) + 0x1F130 - 0x41);
      } else if (c == ' ') {
        return ' ';
      } else {
        return c;
      }
    }).join();
  }

  // Add more Unicode font conversion functions
  String _toCursive(String text) {
    const normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const cursive =
        '𝒜𝐵𝒞𝒟𝐸𝐹𝒢𝐻𝐼𝒥𝒦𝐿𝑀𝒩𝒪𝒫𝒬𝑅𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵𝒶𝒷𝒸𝒹𝑒𝒻𝑔𝒽𝒾𝒿𝓀𝓁𝓂𝓃𝑜𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏';
    return text.split('').map((c) {
      final i = normal.indexOf(c);
      return i != -1 ? cursive[i] : c;
    }).join();
  }

  String _toDoubleStruck(String text) {
    const normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const doubleStruck =
        '𝔸𝔹ℂ𝔻𝔼𝔽𝔾ℍ𝕀𝕁𝕂𝕃𝕄ℕ𝕆ℙℚℝ𝕊𝕋𝕌𝕍𝕎𝕏𝕐ℤ𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫';
    return text.split('').map((c) {
      final i = normal.indexOf(c);
      return i != -1 ? doubleStruck[i] : c;
    }).join();
  }

  String _toMonospace(String text) {
    const normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const mono =
        '𝙰𝙱𝙲𝙳𝙴𝙵𝙶𝙷𝙸𝙹𝙺𝙻𝙼𝙽𝙾𝙿𝚀𝚁𝚂𝚃𝚄𝚅𝚆𝚇𝚈𝚉𝚊𝚋𝚌𝚍𝚎𝚏𝚐𝚑𝚒𝚓𝚔𝚕𝚖𝚗𝚘𝚙𝚚𝚛𝚜𝚝𝚞𝚟𝚠𝚡𝚢𝚣';
    return text.split('').map((c) {
      final i = normal.indexOf(c);
      return i != -1 ? mono[i] : c;
    }).join();
  }

  String _toGothic(String text) {
    const normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const gothic =
        '𝕬𝕭𝕮𝕯𝕰𝕱𝕲𝕳𝕴𝕵𝕶𝕷𝕸𝕹𝕺𝕻𝕼𝕽𝕾𝕿𝖀𝖁𝖂𝖃𝖄𝖅𝖆𝖇𝖈𝖉𝖊𝖋𝖌𝖍𝖎𝖏𝖐𝖑𝖒𝖓𝖔𝖕𝖖𝖗𝖘𝖙𝖚𝖛𝖜𝖝𝖞𝖟';
    return text.split('').map((c) {
      final i = normal.indexOf(c);
      return i != -1 ? gothic[i] : c;
    }).join();
  }

  String _toFullwidth(String text) {
    return text.split('').map((c) {
      if (c == ' ') return ' ';
      final code = c.codeUnitAt(0);
      if (code >= 33 && code <= 126) {
        return String.fromCharCode(code + 0xFF00 - 0x20);
      }
      return c;
    }).join();
  }

  String _toSuperscript(String text) {
    const normal =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const superScript =
        'ᴬᴮᶜᴰᴱᶠᴳᴴᴵᴶᴷᴸᴹᴺᴼᴾᵠᴿˢᵀᵁⱽᵂˣʸᶻᵃᵇᶜᵈᵉᶠᵍʰᶦʲᵏˡᵐⁿᵒᵖᑫʳˢᵗᵘᵛʷˣʸᶻ⁰¹²³⁴⁵⁶⁷⁸⁹';
    return text.split('').map((c) {
      final i = normal.indexOf(c);
      return i != -1 ? superScript[i] : c;
    }).join();
  }

  String _toSquared(String text) {
    const normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const squared =
        '🄰🄱🄲🄳🄴🄵🄶🄷🄸🄹🄺🄻🄼🄽🄾🄿🅀🅁🅂🅃🅄🅅🅆🅇🅈🅉🄰🄱🄲🄳🄴🄵🄶🄷🄸🄹🄺🄻🄼🄽🄾🄿🅀🅁🅂🅃🅄🅅🅆🅇🅈🅉';
    return text.split('').map((c) {
      final i = normal.indexOf(c);
      return i != -1 ? squared[i] : c;
    }).join();
  }

  String _toOldEnglish(String text) {
    const normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const oldEnglish = '𝔄𝔅ℭ𝔇𝔈𝔉𝔊ℌℑ𝔍𝔎𝔏𝔐𝔑𝔒𝔓𝔔ℜ𝔖𝔗𝔘𝔙𝔚𝔛𝔜ℨ'
        '𝔞𝔟𝔠𝔡𝔢𝔣𝔤𝔥𝔦𝔧𝔨𝔩𝔪𝔫𝔬𝔭𝔮𝔯𝔰𝔱𝔲𝔳𝔴𝔵𝔶𝔷'; // For demo, fallback to static as full mapping is not available
    return oldEnglish;
  }

  String _toUpsideDown(String text) {
    const normal =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    const upside =
        'ɐqɔpǝɟƃɥᴉɾʞʃɯuodbɹsʇnʌʍxʎz∀𐐒ƆᗡƎℲפHIſʞ˥WNOԀΌᴚS⊥ՈΛMXʎZ⇂ᘔᘔƐᘔ9ㄥ860';
    return text
        .split('')
        .map((c) {
          final i = normal.indexOf(c);
          return i != -1 ? upside[i] : c;
        })
        .toList()
        .reversed
        .join();
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
          'Status Maker',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      scrollController: _textScrollController,
                      maxLines: 6,
                      style: GoogleFonts.poppins(fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your text...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        isCollapsed: true,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _originalInput = val;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_textScrollController.hasClients) {
                            _textScrollController.jumpTo(
                                _textScrollController.position.maxScrollExtent);
                          }
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: inputText.isNotEmpty
                              ? () => _copyText(inputText)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            elevation: 0,
                          ),
                          child: Text('Copy',
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: inputText.isNotEmpty ? _deleteText : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            elevation: 0,
                          ),
                          child: Text('Delete',
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.send,
                                            color: AppTheme.primaryColor),
                                        title: Text('Quick Send',
                                            style: GoogleFonts.poppins()),
                                        onTap: () {
                                          Navigator.pop(context);
                                          if (_controller.text
                                              .trim()
                                              .isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DirectMessageScreen(
                                                  initialMessage:
                                                      _controller.text.trim(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.share,
                                            color: AppTheme.primaryColor),
                                        title: Text('Share',
                                            style: GoogleFonts.poppins()),
                                        onTap: () {
                                          Navigator.pop(context);
                                          if (_controller.text
                                              .trim()
                                              .isNotEmpty) {
                                            Share.share(
                                                _controller.text.trim());
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            elevation: 0,
                          ),
                          child: Icon(Icons.more_horiz, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Fonts'),
              Tab(text: 'Symbols'),
              Tab(text: 'Emoji'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Fonts Tab
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  itemCount: fancyFonts.length,
                  itemBuilder: (context, index) {
                    final fontText = fancyFonts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Material(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            if (_originalInput.isEmpty) return;
                            final converter = index < fontConverters.length
                                ? fontConverters[index]
                                : null;
                            final converted = converter != null
                                ? converter(_originalInput)
                                : _originalInput;
                            setState(() {
                              _controller.text = converted;
                              _controller.selection = TextSelection.collapsed(
                                  offset: converted.length);
                            });
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_textScrollController.hasClients) {
                                _textScrollController.jumpTo(
                                    _textScrollController
                                        .position.maxScrollExtent);
                              }
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            child: Center(
                              child: Text(
                                fontText,
                                style: GoogleFonts.poppins(fontSize: 22),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Symbols Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 8,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: symbols.map((symbol) {
                      return Material(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _insertAtCursor(symbol),
                          child: Center(
                            child: Text(
                              symbol,
                              style: GoogleFonts.poppins(fontSize: 22),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Emoji Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Happy',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: happyEmojis.map((emoji) {
                            return Material(
                              color:
                                  isDarkMode ? Colors.grey[800] : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _insertAtCursor(emoji),
                                child: Center(
                                  child: Text(
                                    emoji,
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
