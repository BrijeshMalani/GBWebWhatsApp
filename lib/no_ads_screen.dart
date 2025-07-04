import 'package:flutter/material.dart';
import 'package:gb_whatsapp_clone/Utils/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';

class NoAdsScreen extends StatefulWidget {
  const NoAdsScreen({Key? key}) : super(key: key);

  @override
  State<NoAdsScreen> createState() => _NoAdsScreenState();
}

class _NoAdsScreenState extends State<NoAdsScreen> {
  bool _loading = false;
  bool _purchased = false;
  String? _error;
  int _selectedPlan = 0; // 0 = annual, 1 = weekly

  // Example product IDs (replace with your real ones)
  static const String annualProductId = 'premium_yearly';
  static const String weeklyProductId = 'premium_weekly';

  @override
  void initState() {
    super.initState();
    _checkPurchased();
  }

  Future<void> _checkPurchased() async {
    setState(() => _loading = true);
    try {
      final purchased = await PurchaseService().isNoAdsPurchased();
      setState(() {
        _purchased = purchased;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to check purchase status.';
        _loading = false;
      });
    }
  }

  Future<void> _buy() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final productId = _selectedPlan == 0 ? annualProductId : weeklyProductId;
      await PurchaseService().buyProduct(productId);
      setState(() {
        _purchased = true;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thank you for subscribing!')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _restore() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await PurchaseService().restorePurchases();
      await _checkPurchased();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchases restored!')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _restore,
            child: Text('Restore',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image overlay (replace with your own or use a blurred effect)
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/web.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 24),
                      Text('Go Premium',
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 4),
                      Text('Unlock Everything',
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                      SizedBox(height: 24),
                      _FeatureList(),
                      SizedBox(height: 32),
                      _PlanSelector(
                        selected: _selectedPlan,
                        onSelect: (i) => setState(() => _selectedPlan = i),
                      ),
                      SizedBox(height: 16),
                      if (_loading)
                        CircularProgressIndicator(color: Colors.white)
                      else if (_purchased)
                        Column(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 36),
                            SizedBox(height: 8),
                            Text('You are Premium!',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Text('Auto-renews. Cancel Anytime!',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.green)),
                            SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  textStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                onPressed: _buy,
                                child: Text('SUBSCRIBE'),
                              ),
                            ),
                          ],
                        ),
                      if (_error != null) ...[
                        SizedBox(height: 16),
                        Text(_error!, style: TextStyle(color: Colors.red)),
                      ],
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text.rich(
                          TextSpan(
                            text: 'Continuing indicates that you agree to our ',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white70),
                            children: [
                              TextSpan(
                                text: 'Service Policy',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 18),
                    ],
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

class _FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeatureRow('Infinite sticker pack'),
        _FeatureRow('Number of 30 stickers'),
        _FeatureRow('Unlimited number of commonly used words'),
        _FeatureRow('Unrestricted font selection'),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _PlanSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _PlanSelector({required this.selected, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlanTile(
          selected: selected == 0,
          title: 'Annual Access Permissions',
          price: '\$59.99/year',
          highlight: true,
          onTap: () => onSelect(0),
        ),
        SizedBox(height: 12),
        _PlanTile(
          selected: selected == 1,
          title: '3-day free trial',
          price: '\$9.99/week',
          highlight: true,
          onTap: () => onSelect(1),
        ),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  final bool selected;
  final String title;
  final String price;
  final bool highlight;
  final VoidCallback onTap;
  const _PlanTile({
    required this.selected,
    required this.title,
    required this.price,
    required this.highlight,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white10,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.white24,
            width: selected ? 2.5 : 1.0,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Row(
          children: [
            if (selected)
              Icon(Icons.check_circle, color: AppTheme.primaryColor),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              selected ? AppTheme.primaryColor : Colors.white)),
                  Text(price,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              selected ? AppTheme.primaryColor : Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
