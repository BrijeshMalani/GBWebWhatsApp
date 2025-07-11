import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Utils/app_theme.dart';
import 'DirectMessageScreen.dart';
import 'SettingsScreen.dart';
import 'TextRepeaterScreen.dart';
import 'Utils/common.dart';
import 'WebShow.dart';
import 'WebViewScreen.dart';
import 'chat_background_screen.dart';
import 'native_ad_widget.dart';
import 'whatscaption_screen.dart';
import 'whatscroping_screen.dart';
import 'CommonPhrasesScreen.dart';
import 'FancyFontsScreen.dart';
import 'services/api_service.dart';
import 'no_ads_screen.dart';
import 'services/app_open_ad_manager.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _noAds = false;

  @override
  void initState() {
    super.initState();
    _initNoAds();
    PurchaseService().init();
  }

  Future<void> _initNoAds() async {
    final purchased = await PurchaseService().isNoAdsPurchased();
    setState(() {
      _noAds = purchased;
    });
    AppOpenAdManager.disableAds = purchased;
    if (!purchased) {
      _loadBannerAd();
      _loadInterstitialAd();
    }
  }

  void _loadBannerAd() {
    if (_noAds) return;
    _bannerAd = BannerAd(
      adUnitId: Common.bannar_ad_id,
      // Android test banner ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    if (_noAds) return;
    InterstitialAd.load(
      adUnitId: Common.interstitial_ad_id,
      // Android test interstitial ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitialAd(VoidCallback onAdClosed) {
    if (_noAds) {
      onAdClosed();
      return;
    }
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      onAdClosed();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          // leading: Icon(Icons.arrow_back, color: Colors.white),
          title: Text(
            "GB Web Latest Version",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _HomeButton(
                        imagePath: 'assets/images/web.png',
                        label: "Whats Web",
                        padding: EdgeInsets.symmetric(vertical: 40),
                        onTap: () {
                          Common.interstitial_ad_id.isEmpty
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebShowScreen(),
                                  ),
                                )
                              : _showInterstitialAd(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebShowScreen(),
                                    ),
                                  );
                                });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _HomeButton(
                        icon: Icons.message,
                        label: "Direct Message",
                        padding: EdgeInsets.symmetric(vertical: 40),
                        onTap: () {
                          Common.interstitial_ad_id.isEmpty
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DirectMessageScreen(),
                                  ),
                                )
                              : _showInterstitialAd(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DirectMessageScreen(),
                                    ),
                                  );
                                });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (!_noAds)
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: NativeAdWidget()),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _HomeButton(
                      icon: Icons.refresh,
                      label: "Whats Repeat",
                      onTap: () {
                        Common.interstitial_ad_id.isEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TextRepeaterScreen(),
                                ),
                              )
                            : _showInterstitialAd(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TextRepeaterScreen(),
                                  ),
                                );
                              });
                      },
                    ),
                    _HomeButton(
                      icon: Icons.sticky_note_2,
                      label: "Whats Caption",
                      onTap: () {
                        Common.interstitial_ad_id.isEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WhatscaptionScreen()),
                              )
                            : _showInterstitialAd(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WhatscaptionScreen()),
                                );
                              });
                      },
                    ),
                    _HomeButton(
                      icon: Icons.language,
                      label: "Private Browser",
                      onTap: () {
                        Common.interstitial_ad_id.isEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    url: 'https://www.google.com/',
                                    title: 'Private Browser',
                                  ),
                                ),
                              )
                            : _showInterstitialAd(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                      url: 'https://www.google.com/',
                                      title: 'Private Browser',
                                    ),
                                  ),
                                );
                              });
                      },
                    ),
                    _HomeButton(
                      icon: Icons.image,
                      label: "Chat Background",
                      onTap: () {
                        Common.interstitial_ad_id.isEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatBackgroundScreen(),
                                ),
                              )
                            : _showInterstitialAd(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatBackgroundScreen(),
                                  ),
                                );
                              });
                      },
                    ),
                    _HomeButton(
                      icon: Icons.crop,
                      label: "Whats Cropping",
                      onTap: () {
                        Common.interstitial_ad_id.isEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WhatscropingScreen()),
                              )
                            : _showInterstitialAd(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WhatscropingScreen()),
                                );
                              });
                      },
                    ),
                    _HomeButton(
                      icon: Icons.list,
                      label: 'Common Phrases',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommonPhrasesScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeButton(
                      icon: Icons.font_download,
                      label: 'Fancy Fonts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FancyFontsScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeButton(
                      icon: Icons.settings,
                      label: "Settings",
                      onTap: () {
                        Common.interstitial_ad_id.isEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              )
                            : _showInterstitialAd(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(),
                                  ),
                                );
                              });
                      },
                    ),
                    _HomeButton(
                      icon: Icons.workspace_premium,
                      label: 'No Ads',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoAdsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buyNoAds(BuildContext context) async {
    try {
      await PurchaseService().buyNoAds();
      Navigator.pop(context); // Close the sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Thank you for your purchase! Ads are now removed.')),
      );
      setState(() {
        _noAds = true;
        _bannerAd?.dispose();
        _interstitialAd?.dispose();
        _bannerAd = null;
        _interstitialAd = null;
      });
      AppOpenAdManager.disableAds = true;
      await updateNoAdsState();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: \\${e.toString()}')),
      );
    }
  }
}

class _HomeButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const _HomeButton({
    this.icon,
    this.imagePath,
    required this.label,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [Colors.teal.shade700, Colors.teal.shade900]
                  : [Colors.teal.shade400, Colors.teal.shade600],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        width: 32,
                        height: 32,
                        color: Colors.white,
                      )
                    : Icon(icon, color: Colors.white, size: 32),
              ),
              SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoAdsPurchaseSheet extends StatelessWidget {
  final VoidCallback onBuy;
  const _NoAdsPurchaseSheet({required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium, size: 48, color: Colors.amber),
          SizedBox(height: 16),
          Text(
            'Remove All Ads',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Enjoy an ad-free experience forever!\nOne-time payment, no subscription.',
            style: GoogleFonts.poppins(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 18),
              elevation: 2,
            ),
            icon: Icon(Icons.lock_open),
            label: Text('Buy for \$1.99'),
            onPressed: onBuy,
          ),
          SizedBox(height: 12),
          Text(
            'Secure payment via Google Play / App Store',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
