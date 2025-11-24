import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/constants/my_strings.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/features_row.dart';
import 'widgets/stats_row.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _fadeController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [Color(0xFFE0E7FF), Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 12));
                    },
                    child: Column(
                      children: [
                        _buildHeroSection(),
                        const StatsRow(),
                        _buildFeaturesSection(),
                        _buildPricingSection(),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Text(
                            'B',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Transform.translate(
                              offset: Offset(_shimmerAnimation.value * 80, 0),
                              child: Container(
                                width: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.4),
                                      Colors.transparent,
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
                },
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.home_app_name.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          _buildAnimatedButton(
            text: LocaleKeys.home_login.tr(),
            onPressed: () {
              context.pushRoute(const LoginRoute());
            },
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              LocaleKeys.home_hero_title.tr(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              LocaleKeys.home_hero_subtitle.tr(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          _buildAnimatedButton(
            text: LocaleKeys.home_get_started.tr(),
            onPressed: () {
              launchUrl(Uri.parse('${MyStrings.webUrl}/register'));
            },
            isSecondary: true,
            fullWidth: true,
          ),
          const SizedBox(height: 16),

          FeaturesRow(),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
        ),
      ),
      child: Column(
        children: [
          Text(
            LocaleKeys.home_main_features.tr(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildFeatureCard(
            icon: Icons.analytics,
            title: LocaleKeys.home_feature1_title.tr(),
            description: LocaleKeys.home_feature1_desc.tr(),
            color: const Color(0xFF3B82F6),
            delay: 0,
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            icon: Icons.account_balance_wallet,
            title: LocaleKeys.home_feature2_title.tr(),
            description: LocaleKeys.home_feature2_desc.tr(),
            color: const Color(0xFF10B981),
            delay: 100,
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            icon: Icons.insights,
            title: LocaleKeys.home_feature3_title.tr(),
            description: LocaleKeys.home_feature3_desc.tr(),
            color: const Color(0xFFF59E0B),
            delay: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(
            opacity: value,
            child: _buildFeatureCardContent(icon, title, description, color),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCardContent(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE2E8F0), Color(0xFFF1F5F9)],
        ),
      ),
      child: Column(
        children: [
          Text(
            LocaleKeys.home_pricing_title.tr(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildPricingCard(
            name: LocaleKeys.home_free.tr(),
            price: '0€',
            features: [
              LocaleKeys.home_free_feature1.tr(),
              LocaleKeys.home_free_feature2.tr(),
              LocaleKeys.home_free_feature3.tr(),
              LocaleKeys.home_free_feature4.tr(),
            ],
            buttonText: LocaleKeys.home_get_started.tr(),
            isFeatured: true,
          ),
          const SizedBox(height: 40),

          _buildPricingCard(
            name: LocaleKeys.home_classic.tr(),
            price: '9.99€',
            features: [
              LocaleKeys.home_premium_feature1.tr(),
              LocaleKeys.home_premium_feature2.tr(),
              LocaleKeys.home_premium_feature3.tr(),
              LocaleKeys.home_premium_feature4.tr(),
            ],
            buttonText: LocaleKeys.home_free_trial.tr(),
            isFeatured: false,
          ),
          const SizedBox(height: 20),

          _buildPricingCard(
            name: LocaleKeys.home_premium.tr(),
            price: '19.99€',
            features: [
              LocaleKeys.home_premium_feature1.tr(),
              LocaleKeys.home_premium_feature2.tr(),
              LocaleKeys.home_premium_feature3.tr(),
              LocaleKeys.home_premium_feature4.tr(),
              LocaleKeys.home_premium_feature5.tr(),
            ],
            buttonText: LocaleKeys.home_free_trial.tr(),
            isFeatured: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required String name,
    required String price,
    required List<String> features,
    required String buttonText,
    required bool isFeatured,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: isFeatured
            ? const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              )
            : null,
        color: isFeatured ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFeatured
              ? Colors.transparent
              : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isFeatured
                ? const Color(0xFF667EEA).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isFeatured)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                LocaleKeys.home_popular.tr(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          if (isFeatured) const SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isFeatured ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: isFeatured ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              Text(
                LocaleKeys.home_per_month.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: isFeatured
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map(
                  (feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check,
                          color: isFeatured
                              ? Colors.white
                              : const Color(0xFF10B981),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 14,
                              color: isFeatured
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
          _buildAnimatedButton(
            text: buttonText,
            onPressed: () {
              launchUrl(Uri.parse('${MyStrings.webUrl}/register'));
            },
            isPrimary: !isFeatured,
            isSecondary: isFeatured,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.home_app_name.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.home_footer_slogan.tr(),
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(height: 1, color: Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.home_footer_copyright.tr(),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isSecondary = false,
    bool fullWidth = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: isPrimary
              ? const Color(0xFF667EEA)
              : isSecondary
              ? Colors.white.withValues(alpha: 0.95)
              : Colors.white,
          foregroundColor: isPrimary
              ? Colors.white
              : isSecondary
              ? const Color(0xFF1E293B)
              : const Color(0xFF667EEA),
          elevation: isPrimary ? 8 : 4,
          shadowColor: isPrimary
              ? const Color(0xFF667EEA).withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.1),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fullWidth ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
