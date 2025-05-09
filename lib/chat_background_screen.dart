import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'Utils/app_theme.dart';

import 'Utils/common.dart';

class ChatBackgroundScreen extends StatefulWidget {
  @override
  _ChatBackgroundScreenState createState() => _ChatBackgroundScreenState();
}

class _ChatBackgroundScreenState extends State<ChatBackgroundScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  final List<String> imageAssets = List.generate(
    12,
    (index) => 'assets/images/${index + 1}.jpg',
  );

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    if (Common.bannar_ad_id.isEmpty) return;

    _bannerAd = BannerAd(
      adUnitId: Common.bannar_ad_id,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> downloadAssetImage(
      String assetPath, BuildContext context) async {
    try {
      if (Platform.isIOS) {
        // Request photo library permission for iOS
        var status = await Permission.photos.request();
        if (!status.isGranted) {
          if (mounted) {
            _showSnackBar('Photo library permission is required to save images',
                isSuccess: false);
          }
          return;
        }
      } else {
        // Request storage permission for Android
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          if (mounted) {
            _showSnackBar('Storage permission is required to save images',
                isSuccess: false);
          }
          return;
        }
      }

      // Load image bytes from assets
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List bytes = byteData.buffer.asUint8List();

      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: "chat_background_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        if (mounted) {
          _showSnackBar('Image saved to gallery!', isSuccess: true);
        }
      } else {
        if (mounted) {
          _showSnackBar('Failed to save image', isSuccess: false);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to save image: $e', isSuccess: false);
      }
    }
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: isSuccess ? AppTheme.primaryColor : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Text(
          'Chat Backgrounds',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: imageAssets.length,
        itemBuilder: (context, index) {
          return _buildBackgroundCard(imageAssets[index]);
        },
      ),
    );
  }

  Widget _buildBackgroundCard(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: ElevatedButton.icon(
              onPressed: () => downloadAssetImage(imagePath, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                elevation: 0,
              ),
              icon: Icon(Icons.download, color: Colors.white),
              label: Text(
                'Download',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
