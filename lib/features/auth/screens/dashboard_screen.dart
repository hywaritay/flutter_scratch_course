import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../../core/widgets/bar_chart_widget.dart';
import '../../../core/widgets/dashboard_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pie_chart_widget.dart';
import 'market_screen.dart';
import 'prediction_screen.dart';
import 'video_tutorial_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _Activity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const _Activity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style1,
    );
  }

  List<Widget> _buildScreens() {
    return [
      _buildDashboardScreen(),
      _buildMarketScreen(),
      _buildSettingsScreen(),
      _buildVideoTutorialScreen(),
      _buildPredictionScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.dashboard),
        title: "Dashboard",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.hint,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_bag),
        title: "Market",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.hint,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: "Settings",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.hint,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.video_library),
        title: "Video Tutorial",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.hint,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.analytics),
        title: "Prediction",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.hint,
      ),
    ];
  }

  Widget _buildDashboardScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive breakpoints
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Responsive padding
          final padding = screenWidth < 300 ? 12.0 : 16.0;

          // Responsive spacing
          final spacing = screenWidth < 300 ? 12.0 : 16.0;
          final sectionSpacing = screenHeight < 300 ? 16.0 : 32.0;

          // Responsive chart height (adapts to available space)
          final chartHeight = screenHeight < 600
              ? 150.0
              : screenHeight < 800
              ? 180.0
              : 200.0;

          // Responsive font sizes
          final titleFontSize = screenWidth < 600 ? 16.0 : 18.0;

          return Padding(
            padding: EdgeInsets.all(padding),
            child: ListView(
              children: [
                // Swipe hint text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.swipe, size: 16, color: AppColors.hint),
                    const SizedBox(width: 8),
                    Text(
                      "Swipe to see more cards",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.hint,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final cards = [
                        const DashboardCard(
                          title: "Users",
                          value: "1,245",
                          icon: Icons.people,
                          color: Colors.blue,
                        ),
                        const DashboardCard(
                          title: "Revenue",
                          value: "\$8,320",
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                        const DashboardCard(
                          title: "Orders",
                          value: "320",
                          icon: Icons.shopping_cart,
                          color: Colors.orange,
                        ),
                        const DashboardCard(
                          title: "Growth",
                          value: "18%",
                          icon: Icons.trending_up,
                          color: Colors.purple,
                        ),
                      ];

                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                          }

                          return Center(
                            child: Transform.scale(
                              scale: value,
                              child: Opacity(opacity: value, child: child),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing / 2,
                          ),
                          child: cards[index],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary
                            : AppColors.hint.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: sectionSpacing),

                Text(
                  "Monthly Performance",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing),
                SizedBox(height: chartHeight, child: BarChartWidget()),

                SizedBox(height: sectionSpacing),

                Text(
                  "User Distribution",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing),
                SizedBox(height: chartHeight, child: PieChartWidget()),
                SizedBox(height: sectionSpacing),

                Text(
                  "Recent Activity",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _activities.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _activities[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.color.withOpacity(0.15),
                        child: Icon(item.icon, color: item.color),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: titleFontSize - 2,
                        ),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: const TextStyle(color: AppColors.hint),
                      ),
                      trailing: Text(
                        item.time,
                        style: const TextStyle(
                          color: AppColors.hint,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarketScreen() {
    return const MarketScreen();
  }

  Widget _buildSettingsScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text("Settings Screen")),
    );
  }

  Widget _buildVideoTutorialScreen() {
    return const VideoTutorialScreen();
  }

  Widget _buildPredictionScreen() {
    return const PredictionScreen();
  }

  static const _activities = [
    _Activity(
      title: "New user signed up",
      subtitle: "jane.doe@example.com",
      time: "2m ago",
      icon: Icons.person_add,
      color: Colors.blue,
    ),
    _Activity(
      title: "Order completed",
      subtitle: "#ORD-1042 • \$240",
      time: "12m ago",
      icon: Icons.shopping_bag,
      color: Colors.orange,
    ),
    _Activity(
      title: "Payment received",
      subtitle: "Stripe • \$1,200",
      time: "30m ago",
      icon: Icons.attach_money,
      color: Colors.green,
    ),
    _Activity(
      title: "Server health",
      subtitle: "API latency normal",
      time: "1h ago",
      icon: Icons.health_and_safety,
      color: Colors.purple,
    ),
  ];
}
