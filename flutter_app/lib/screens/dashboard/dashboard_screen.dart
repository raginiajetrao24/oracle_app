import 'package:flutter/material.dart';
import 'package:flutter_app/screens/person_search/person_search_screen.dart';
import 'package:flutter_app/screens/core_hr/person_information/person_information_screen.dart';
import 'package:flutter_app/screens/my_team/my_team_personal_details_screen.dart';
import 'package:flutter_app/screens/organization_trees/organization_trees_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = const ['Me', 'My Team', 'My Client Groups'];

  List<_DashboardAction> get _currentActions {
    switch (_selectedTabIndex) {
      case 0:
        return const [
          _DashboardAction(
            label: 'Personal Details',
            icon: Icons.account_circle_outlined,
            color: Color(0xFF1F4E8C),
            screen: PersonInformationScreen(),
          ),
        ];
      case 1:
        return const [
          _DashboardAction(
            label: 'Personal Details',
            icon: Icons.badge_outlined,
            color: Color(0xFF1F4E8C),
            screen: MyTeamPersonalDetailsScreen(),
          ),
          _DashboardAction(
            label: 'Person Management',
            icon: Icons.people_alt_outlined,
            color: Color(0xFF4DB6AC),
            screen: PersonSearchScreen(),
          ),
          _DashboardAction(
            label: 'Assignment',
            icon: Icons.assignment_outlined,
            color: Color(0xFFFFC83D),
          ),
          _DashboardAction(
            label: 'Hiring',
            icon: Icons.work_outline_rounded,
            color: Color(0xFF8B5CF6),
          ),
        ];
      default:
        return const [
          _DashboardAction(
            label: 'Person Management',
            icon: Icons.person_rounded,
            color: Color(0xFF4DB6AC),
            screen: PersonSearchScreen(),
          ),
          _DashboardAction(
            label: 'Organization Trees',
            icon: Icons.account_tree_outlined,
            color: Color(0xFF1F4ED8),
            screen: OrganizationTreesScreen(),
          ),
          _DashboardAction(
            label: 'New Person',
            icon: Icons.person_add_alt_1_rounded,
            color: Color(0xFF2E7D32),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting and curved background
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFC9DFF6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 32,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  // Logo from assets
                  Image.asset(
                    'assets/images/mannai_logo.jpeg',
                    height: 48,
                    fit: BoxFit.contain,
                    color: const Color(0xFFC9DFF6),
                    colorBlendMode: BlendMode.multiply,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F4E8C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Curtis Feitty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F4E8C),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Welcome to your digital workspace',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7B8B9B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Plan Balance Summary Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 3,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: 3,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: 3,
                          height: 13,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5722),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Balance Summary',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F4E8C),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Your current leave status',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7B8B9B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Plan Balance Summary Cards Grid (3 Columns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
                padding: EdgeInsets.zero,
                children: [
                  _buildBalanceCard(_buildExitIcon(), '-40', 'Carryover ex...'),
                  _buildBalanceCard(
                    _buildPeriodicAccrualIcon(),
                    '56',
                    'Periodic accr...',
                  ),
                  _buildBalanceCard(_buildCarryoverIcon(), '304', 'Carryover'),
                  _buildBalanceCard(_buildBalanceIcon(), '320', 'Balance'),
                ],
              ),
            ),

            // Horizontal Scrolling Menu Bar
            _buildHorizontalTabBar(),

            // Quick Actions Section Title
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFFFBBF24),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F4E8C),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Access frequently used services',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF7B8B9B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F4E8C),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Quick Actions Cards Grid (2 Columns)
            Builder(
              builder: (context) {
                final actions = _currentActions;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.35,
                    padding: EdgeInsets.zero,
                    children: actions
                        .map(
                          (action) => _buildActionCard(
                            context,
                            action.label,
                            action.icon,
                            action.color,
                            action.screen,
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            // Version Indicator
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF7B8B9B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: 1, // Home is selected (middle)
          selectedItemColor: const Color(0xFF1F4E8C),
          unselectedItemColor: const Color(0xFF9CA3AF),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExitIcon() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 2,
            child: Icon(
              Icons.meeting_room_rounded,
              color: Color(0xFF5E7A8C),
              size: 22,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 2,
            child: Icon(
              Icons.directions_walk_rounded,
              color: Color(0xFF1E88E5),
              size: 16,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 2,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFFFFB300),
              size: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodicAccrualIcon() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Icon(
              Icons.directions_run_rounded,
              color: Color(0xFF1E88E5),
              size: 20,
            ),
          ),
          Positioned(
            right: 0,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFFFFB300),
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarryoverIcon() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(Icons.person_pin_rounded, color: Color(0xFF1E88E5), size: 20),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.add_circle_rounded,
              color: Color(0xFF4CAF50),
              size: 10,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(
              Icons.settings_suggest_rounded,
              color: Color(0xFFFFB300),
              size: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceIcon() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.calendar_month_rounded,
            color: Color(0xFF1E88E5),
            size: 22,
          ),
          Positioned(
            top: 10,
            left: 5,
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFFFFB300),
              size: 8,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 5,
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFFFFB300),
              size: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(Widget iconWidget, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF5FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: iconWidget,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F4E8C),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7B8B9B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    Widget? screen,
  ) {
    return GestureDetector(
      onTap: screen == null
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4E8C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon,';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }

  Widget _buildHorizontalTabBar() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _tabs[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF7B8B9B),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    width: isSelected ? 48 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F4E8C),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(1.5),
                        topRight: Radius.circular(1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardAction {
  final String label;
  final IconData icon;
  final Color color;
  final Widget? screen;

  const _DashboardAction({
    required this.label,
    required this.icon,
    required this.color,
    this.screen,
  });
}
