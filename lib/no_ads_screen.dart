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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text('Go Premium',
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0),
                        child: Transform.rotate(
                          angle: 90 * 3.1415926535 / 180,
                          child: Image.asset(
                            'assets/images/inapp_design.png',
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                      Text('Unlock Everything',
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                      Transform.rotate(
                        angle: 90 * 3.1415926535 / 180, // 90 degrees in radians
                        child: Image.asset(
                          'assets/images/inapp_design.png',
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _FeatureList(),
                  SizedBox(height: 30),
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
                        Icon(Icons.check_circle, color: Colors.green, size: 36),
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
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              textStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: _buy,
                            child: Text('CONTINUE'),
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
        _FeatureRow('No Ads'),
        _FeatureRow('No limit on whatsapp web'),
        _FeatureRow('No limit on direct message'),
        _FeatureRow('Unlimited number of commonly used words'),
        _FeatureRow('Unrestricted font selection'),
        _FeatureRow('Get all access'),
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
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white)),
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
          highlight: false,
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
          padding: EdgeInsets.only(bottom: 14, left: 14, right: 14),
          child: Column(
            children: [
              highlight
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text('Save 88%',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.white)),
                        )
                      ],
                    )
                  : SizedBox(height: 14),
              Row(
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
                                fontSize: 14,
                                color: selected ? Colors.black : Colors.white)),
                        Text(price,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: selected ? Colors.black : Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
