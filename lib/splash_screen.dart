import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils/app_theme.dart';
import 'home_page.dart';
import 'main.dart';
import 'services/api_service.dart';
import 'models/app_data_model.dart';
import 'Utils/common.dart';
import 'services/app_lifecycle_reactor.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  AppDataModel? appData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    _initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      print('Fetching app data from API...');
      final data = await ApiService.fetchAppData();
      print('API Response: $data');

      if (data != null) {
        if (data.rewardedFull.isNotEmpty) {
          print('Setting privacy policy: ${data.rewardedFull}');
          Common.privacy_policy = data.rewardedFull;
        }
        if (data.rewardedFull2.isNotEmpty) {
          print('Setting terms and conditions: ${data.rewardedFull2}');
          Common.terms_conditions = data.rewardedFull2;
        }

        if (data.admobId.isNotEmpty) {
          print('Setting banner ad ID: ${data.admobId}');
          Common.bannar_ad_id = data.admobId;
        }
        if (data.admobFull.isNotEmpty) {
          print('Setting interstitial ad ID: ${data.admobFull}');
          Common.interstitial_ad_id = data.admobFull;
        }
        if (data.admobNative.isNotEmpty) {
          print('Setting native ad ID: ${data.admobNative}');
          Common.native_ad_id = data.admobNative;
        }
        if (data.rewardedInt.isNotEmpty) {
          print('Setting native ad ID: ${data.rewardedInt}');
          Common.app_open_ad_id = data.rewardedInt;
        }
        if (data.startAppFull.isNotEmpty) {
          print('Setting native ad ID: ${data.startAppFull}');
          Common.playstore_link = data.startAppFull;
        }

        setState(() {
          appData = data;
          isLoading = false;
        });
        final appLifecycleReactor =
            AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
        appLifecycleReactor.listenToAppStateChanges();

        // Preload the app open ad
        await appOpenAdManager.loadAd();
        print('App data set successfully');
        _showSplashAndAd();
      } else {
        print('Failed to load app data - data is null');
        setState(() {
          errorMessage = 'Failed to load app data';
          isLoading = false;
        });
        _navigateToHome();
      }
    } catch (e) {
      print('Error in _initializeApp: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      _navigateToHome();
    }
  }

  Future<void> _showSplashAndAd() async {
    // Show splash screen for 2 seconds
    // await Future.delayed(Duration(seconds: 2));

    if (!mounted) return;

    // Try to show the app open ad
    print('Attempting to show app open ad...');
    try {
      await appOpenAdManager.showAdIfAvailable();
      print('App open ad shown successfully');
    } catch (e) {
      print('Error showing app open ad: $e');
    }

    if (!mounted) return;
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'GB WhatsApp',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
