import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/recommendation_model.dart';
import '../models/weather_alert_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userModel = await FirestoreService().getUser(currentUser.uid);
        setState(() {
          _user = userModel;
        });
      }
    } catch (e) {
      // Silently handle error - user can still use app
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xCC8BBD6C).withValues(alpha: 0.8),
                  const Color(0x99556B2F).withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          if (_selectedNavIndex == 0)
            _HomeTabContent(user: _user)
          else if (_selectedNavIndex == 1)
            _DiscoverTabContent(user: _user)
          else if (_selectedNavIndex == 2)
            _PlanTabContent(user: _user)
          else if (_selectedNavIndex == 3)
            _AlertsTabContent(user: _user)
          else
            _MeTabContent(user: _user),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
        },
      ),
    );
  }
}

// ============= TAB: HOME =============
class _HomeTabContent extends StatelessWidget {
  final UserModel? user;
  const _HomeTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Morning ${user?.name ?? 'Farm Owner'} ',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const Text('✨', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.location ?? 'Western Cape, 22°C',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1DC578),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Online',
                                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _TopRecommendationCard(
                    recommendation: RecommendationModel(
                      cropName: 'Pinotage',
                      matchPercentage: 92,
                      yieldIncrease: 28,
                      profitIncrease: 142000,
                      reason: 'Perfect soil and climate match',
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Your Crops', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CropYieldCard(name: 'Chenin\nBlanc', yieldValue: 0.65),
                      _CropYieldCard(name: 'Cabernet\nSauvignon', yieldValue: 0.45),
                      _CropYieldCard(name: 'Vegetables', yieldValue: 0.80),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _WeatherAlertCard(
                    alert: WeatherAlertModel(
                      alertType: 'Heat Wave',
                      description: 'High temperatures expected in the next 9 days',
                      severity: 'High',
                      daysUntil: 9,
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: DISCOVER =============
class _DiscoverTabContent extends StatelessWidget {
  final UserModel? user;
  const _DiscoverTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Discover New Crops', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  _DiscoverCard(
                    icon: '🍇',
                    name: 'Merlot Grapes',
                    match: 88,
                    yield: '+35%',
                    info: 'Premium wine variety\nHigh demand market',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CropDetailScreen(cropName: 'Merlot Grapes', yield: '+35%', price: 'R450/kg', harvest: '6 months'))),
                  ),
                  const SizedBox(height: 12),
                  _DiscoverCard(
                    icon: '🍏',
                    name: 'Honeycrisp Apples',
                    match: 79,
                    yield: '+22%',
                    info: 'Sweet & crispy\nExport grade quality',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CropDetailScreen(cropName: 'Honeycrisp Apples', yield: '+22%', price: 'R380/kg', harvest: '5 months'))),
                  ),
                  const SizedBox(height: 12),
                  _DiscoverCard(
                    icon: '🫒',
                    name: 'Olive Trees',
                    match: 85,
                    yield: '+18%',
                    info: 'Oil production\nLow maintenance crop',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CropDetailScreen(cropName: 'Olive Trees', yield: '+18%', price: 'R520/kg oil', harvest: '8 months'))),
                  ),
                  const SizedBox(height: 12),
                  _DiscoverCard(
                    icon: '🥕',
                    name: 'Heritage Carrots',
                    match: 92,
                    yield: '+40%',
                    info: 'Organic certified\nPremium pricing',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CropDetailScreen(cropName: 'Heritage Carrots', yield: '+40%', price: 'R220/kg', harvest: '4 months'))),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: PLAN =============
class _PlanTabContent extends StatelessWidget {
  final UserModel? user;
  const _PlanTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Crop Schedule', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  _ScheduleCard(
                    month: 'April',
                    crops: ['Plant Pinotage', 'Prepare irrigation', 'Soil testing'],
                    stage: 'Preparation',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleDetailScreen(month: 'April', stage: 'Preparation', taskCount: 3, cropFocus: 'Pinotage')));
                    },
                  ),
                  const SizedBox(height: 12),
                  _ScheduleCard(
                    month: 'May - June',
                    crops: ['Growth monitoring', 'Pest management', 'Pruning'],
                    stage: 'Growing',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleDetailScreen(month: 'May - June', stage: 'Growing', taskCount: 3, cropFocus: 'All Crops')));
                    },
                  ),
                  const SizedBox(height: 12),
                  _ScheduleCard(
                    month: 'July - August',
                    crops: ['Flowering phase', 'Nutrient boost', 'Weather watch'],
                    stage: 'Blooming',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleDetailScreen(month: 'July - August', stage: 'Blooming', taskCount: 3, cropFocus: 'Flowering Crops')));
                    },
                  ),
                  const SizedBox(height: 12),
                  _ScheduleCard(
                    month: 'September',
                    crops: ['Harvest preparation', 'Equipment check', 'Labor planning'],
                    stage: 'Pre-Harvest',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleDetailScreen(month: 'September', stage: 'Pre-Harvest', taskCount: 3, cropFocus: 'Ready to Harvest')));
                    },
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: ALERTS =============
class _AlertsTabContent extends StatelessWidget {
  final UserModel? user;
  const _AlertsTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Alerts', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  _AlertTile(icon: '🌡️', type: 'Temperature', message: 'High heat expected (35°C)', severity: 'Critical', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertDetailScreen(type: 'Temperature', severity: 'Critical', message: 'High heat expected (35°C)', recommendation: 'Increase irrigation frequency and apply shade cloth')));
                  }),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '🐛', type: 'Pest Alert', message: 'Whitefly detected on Chenin Blanc', severity: 'High', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertDetailScreen(type: 'Pest Alert', severity: 'High', message: 'Whitefly detected on Chenin Blanc', recommendation: 'Apply organic pesticide and monitor affected plants')));
                  }),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '💧', type: 'Water Level', message: 'Irrigation recommended tomorrow', severity: 'Medium', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertDetailScreen(type: 'Water Level', severity: 'Medium', message: 'Irrigation recommended tomorrow', recommendation: 'Schedule irrigation for early morning (6-8 AM)')));
                  }),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '📊', type: 'Soil pH', message: 'pH level optimal (6.8)', severity: 'Good', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertDetailScreen(type: 'Soil pH', severity: 'Good', message: 'pH level optimal (6.8)', recommendation: 'Maintain current soil management practices')));
                  }),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '☁️', type: 'Rain Forecast', message: '60% chance of rain Friday', severity: 'Info', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertDetailScreen(type: 'Rain Forecast', severity: 'Info', message: '60% chance of rain Friday', recommendation: 'Prepare to adjust watering schedule accordingly')));
                  }),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: ME =============
class _MeTabContent extends StatelessWidget {
  final UserModel? user;
  const _MeTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Farm Owner', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 12),
                        Text('📍 ${user?.location ?? 'Stellenbosch, Western Cape'}', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 8),
                        Text('📧 ${user?.email ?? 'email@farm.com'}', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 8),
                        Text('🏞️ Land: ${user?.landSize?.toStringAsFixed(1) ?? '15'} hectares', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 8),
                        Text('🌱 Soil: ${user?.soilType ?? 'Clay Loam'}', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SettingsTile(icon: Icons.settings_rounded, title: 'Settings', subtitle: 'App preferences', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                  }),
                  const SizedBox(height: 12),
                  _SettingsTile(icon: Icons.help_rounded, title: 'Help & Support', subtitle: 'Get assistance', onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help & Support coming soon!'),
                        backgroundColor: Color(0xFF1DC578),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  _SettingsTile(icon: Icons.logout_rounded, title: 'Log Out', subtitle: 'Sign out from account', onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF0A1F15),
                        title: const Text('Log Out?', style: TextStyle(color: Colors.white)),
                        content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white70)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel', style: TextStyle(color: Color(0xFF1DC578))),
                          ),
                          TextButton(
                            onPressed: () {
                              // Sign out logic
                              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                            },
                            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= COMPONENT WIDGETS =============

class _DiscoverCard extends StatelessWidget {
  final String icon, name, info;
  final int match;
  final String yield;
  final VoidCallback? onTap;

  const _DiscoverCard({
    required this.icon,
    required this.name,
    required this.match,
    required this.yield,
    required this.info,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text(info, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)), maxLines: 2),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DC578).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('$match%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
                ),
                Text(yield, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String month, stage;
  final List<String> crops;
  final VoidCallback? onTap;

  const _ScheduleCard({
    required this.month,
    required this.crops,
    required this.stage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(month, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DC578).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(stage, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: crops.map((crop) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('✓ $crop', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final String icon, type, message, severity;
  final VoidCallback? onTap;

  const _AlertTile({
    required this.icon,
    required this.type,
    required this.message,
    required this.severity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = severity == 'Critical' ? Colors.red : severity == 'High' ? Colors.orange : severity == 'Good' ? const Color(0xFF1DC578) : Colors.blue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text(message, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                ],
              ),
            ),
            Text(severity, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1DC578), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: 0.4), size: 20),
          ],
        ),
      ),
    );
  }
}

class _TopRecommendationCard extends StatelessWidget {
  final RecommendationModel recommendation;

  const _TopRecommendationCard({
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1DC578).withValues(alpha: 0.9),
            const Color(0xFF0F6B4D).withValues(alpha: 0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your top\nrecommendation\nthis season: ${recommendation.cropName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${recommendation.matchPercentage}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'match',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  icon: '📈',
                  label: '+${recommendation.yieldIncrease}% yield',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatPill(
                  icon: '💰',
                  label: 'R${(recommendation.profitIncrease / 1000).toStringAsFixed(0)}k profit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String icon;
  final String label;

  const _StatPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CropYieldCard extends StatelessWidget {
  final String name;
  final double yieldValue;

  const _CropYieldCard({
    required this.name,
    required this.yieldValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
          color: Colors.white.withValues(alpha: 0.05),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 6,
                    height: 60 * yieldValue,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DC578),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1w',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Mo',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '2tb',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Yiele',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherAlertCard extends StatelessWidget {
  final WeatherAlertModel alert;

  const _WeatherAlertCard({
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFEAB308).withValues(alpha: 0.15),
        border: Border.all(
          color: const Color(0xFFEAB308).withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            '☀️',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.alertType} expected in ${alert.daysUntil} days',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }
}

// ============= CROP DETAIL SCREEN =============
class CropDetailScreen extends StatelessWidget {
  final String cropName, yield, price, harvest;

  const CropDetailScreen({
    required this.cropName,
    required this.yield,
    required this.price,
    required this.harvest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xCC8BBD6C).withValues(alpha: 0.8),
                  const Color(0x99556B2F).withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          cropName,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            children: [
                              _DataRow(label: 'Yield Increase', value: yield),
                              const SizedBox(height: 16),
                              _DataRow(label: 'Market Price', value: price),
                              const SizedBox(height: 16),
                              _DataRow(label: 'Harvest Time', value: harvest),
                              const SizedBox(height: 16),
                              _DataRow(label: 'Soil Type', value: 'Clay Loam'),
                              const SizedBox(height: 16),
                              _DataRow(label: 'Water Needs', value: 'Moderate'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$cropName added to your plan!'),
                                  backgroundColor: const Color(0xFF1DC578),
                                ),
                              );
                              Future.delayed(const Duration(milliseconds: 500), () => Navigator.pop(context));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1DC578),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Add to My Farm',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
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

// ============= DETAIL SCREENS =============

class ScheduleDetailScreen extends StatelessWidget {
  final String month, stage, cropFocus;
  final int taskCount;

  const ScheduleDetailScreen({
    required this.month,
    required this.stage,
    required this.taskCount,
    required this.cropFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F15),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF0A1F15), const Color(0xFF0F3B2F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back_rounded, color: const Color(0xFF1DC578), size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(month, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                                Text(stage, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Stage Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1DC578).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('${(taskCount * 33).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: taskCount * 0.33,
                                minHeight: 8,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1DC578)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _DataRow(label: 'Focus Crop(s)', value: cropFocus),
                      const SizedBox(height: 16),
                      _DataRow(label: 'Tasks Scheduled', value: '$taskCount activities'),
                      const SizedBox(height: 16),
                      _DataRow(label: 'Estimated Duration', value: stage == 'Growing' ? '2 months' : stage == 'Blooming' ? '2 months' : '1 month'),
                      const SizedBox(height: 16),
                      _DataRow(label: 'Labor Required', value: stage == 'Pre-Harvest' ? 'High' : 'Medium'),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$month schedule added to calendar!'),
                                backgroundColor: const Color(0xFF1DC578),
                              ),
                            );
                            Future.delayed(const Duration(milliseconds: 500), () => Navigator.pop(context));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1DC578),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Add to Calendar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlertDetailScreen extends StatelessWidget {
  final String type, severity, message, recommendation;

  const AlertDetailScreen({
    required this.type,
    required this.severity,
    required this.message,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final color = severity == 'Critical' ? Colors.red : severity == 'High' ? Colors.orange : severity == 'Good' ? const Color(0xFF1DC578) : Colors.blue;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1F15),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF0A1F15), const Color(0xFF0F3B2F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back_rounded, color: const Color(0xFF1DC578), size: 28),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: color.withValues(alpha: 0.3)),
                            ),
                            child: Text(severity, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(type, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(message, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6))),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: color.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recommended Action', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
                            const SizedBox(height: 12),
                            Text(recommendation, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8), height: 1.6)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _DataRow(label: 'Priority', value: severity),
                      const SizedBox(height: 16),
                      _DataRow(label: 'Detection Time', value: 'Today'),
                      const SizedBox(height: 16),
                      _DataRow(label: 'Farm Impact', value: severity == 'Critical' ? 'High' : 'Medium'),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$type alert recorded!'),
                                backgroundColor: color,
                              ),
                            );
                            Future.delayed(const Duration(milliseconds: 500), () => Navigator.pop(context));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Acknowledge Alert',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F15),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF0A1F15), const Color(0xFF0F3B2F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back_rounded, color: const Color(0xFF1DC578), size: 28),
                          ),
                          const SizedBox(width: 16),
                          const Text('Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Alert Notifications', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9))),
                                Switch(
                                  value: true,
                                  onChanged: (value) {},
                                  activeColor: const Color(0xFF1DC578),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Weather Updates', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9))),
                                Switch(
                                  value: true,
                                  onChanged: (value) {},
                                  activeColor: const Color(0xFF1DC578),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('App Version', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
                            const SizedBox(height: 12),
                            Text('HarvesterAI v1.0.0', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                            const SizedBox(height: 12),
                            Text('© 2025 HarvesterAI. All rights reserved.', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label, value;

  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7))),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      ('Home', Icons.home_rounded),
      ('Discover', Icons.auto_awesome_rounded),
      ('Plan', Icons.calendar_today_rounded),
      ('Alerts', Icons.notifications_rounded),
      ('Me', Icons.person_rounded),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        color: const Color(0xFF0A1F15).withValues(alpha: 0.8),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navItems.length,
              (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        navItems[index].$2,
                        color: isSelected
                            ? const Color(0xFF1DC578)
                            : Colors.white.withValues(alpha: 0.5),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        navItems[index].$1,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF1DC578)
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
