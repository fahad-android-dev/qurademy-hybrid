import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/utils/colors.dart';
import 'package:qurademy_hybrid/pages/student_course_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qurademy_hybrid/pages/role_selection_page.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _currentIndex = 0;
  int _selectedFilter = 0;
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _page = 0;

  // 🔹 Show logout confirmation dialog
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout? You will need to login again to access your account.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _performLogout();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Actual logout function
  Future<void> _performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 44),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _filters(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _sectionHeader(title: 'Featured Courses'),
              ),
              const SizedBox(height: 16),
              _featuredCarousel(),
              const SizedBox(height: 16),
              _dots(),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _sectionHeader(
                  title: 'Categories',
                  actionText: 'View All',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentCourseListPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _categoriesGrid(),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _sectionHeader(
                  title: 'Continue Learning',
                  actionText: 'See All',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentCourseListPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _continuelearningList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _header() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hello Carlos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Let's upgrade your skills today!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _showLogoutDialog, // 🔥 Changed to show dialog
                  tooltip: 'Logout',
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(left: 20, right: 20, bottom: -32, child: _searchBar()),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses, topics...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 22,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _filters() {
    final chips = ['All', 'Popular', 'New', 'Top Rated'];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final selected = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: selected
                    ? null
                    : Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                chips[i],
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: chips.length,
      ),
    );
  }

  Widget _featuredCarousel() {
    final items = [
      _Feature(
        'UI/UX Design Basics',
        'Learn design fundamentals',
        Icons.brush_rounded,
        const Color(0xFFE0E7FF),
        '4.8',
        '120 lessons',
      ),
      _Feature(
        'Flutter Mastery',
        'Build amazing mobile apps',
        Icons.flutter_dash,
        const Color(0xFFB2F2D3),
        '4.9',
        '85 lessons',
      ),
      _Feature(
        'Data Science Pro',
        'Master data analytics',
        Icons.bubble_chart_outlined,
        const Color(0xFFFFE1D5),
        '4.7',
        '95 lessons',
      ),
    ];
    return SizedBox(
      height: 190,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _page = i),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double scale = 1.0;
              if (_pageController.position.haveDimensions) {
                scale = 1 - ((_pageController.page ?? 0) - i).abs() * 0.06;
              }
              return Transform.scale(scale: scale, child: child);
            },
            child: _FeatureCard(item: item),
          );
        },
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _page == i ? 24 : 8,
          decoration: BoxDecoration(
            color: _page == i ? AppColors.primaryColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
            color: AppColors.secondaryTextColor,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionText,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primaryColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _categoriesGrid() {
    final items = [
      _CategoryCardData(
        'Programming',
        '24 Courses',
        Icons.code_rounded,
        const Color(0xFFE0E7FF),
      ),
      _CategoryCardData(
        'Business',
        '18 Courses',
        Icons.business_center_rounded,
        const Color(0xFFB2F2D3),
      ),
      _CategoryCardData(
        'Design',
        '15 Courses',
        Icons.palette_rounded,
        const Color(0xFFFFE1D5),
      ),
      _CategoryCardData(
        'Marketing',
        '12 Courses',
        Icons.campaign_rounded,
        const Color(0xFFFFF2B2),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (_, i) => _CategoryCard(data: items[i]),
    );
  }

  Widget _continuelearningList() {
    final items = [
      _LearningItem(
        'Advanced Flutter',
        'Mobile Development',
        0.7,
        '12/18 lessons',
        Icons.flutter_dash,
      ),
      _LearningItem(
        'React Fundamentals',
        'Web Development',
        0.4,
        '8/20 lessons',
        Icons.web_rounded,
      ),
    ];

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _LearningCard(item: item),
            ),
          )
          .toList(),
    );
  }

  Widget _bottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey.shade500,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded, size: 24),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_rounded, size: 24),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// All the helper classes remain the same
class _Feature {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;
  final String rating;
  final String lessons;

  _Feature(
    this.title,
    this.subtitle,
    this.icon,
    this.bg,
    this.rating,
    this.lessons,
  );
}

class _FeatureCard extends StatelessWidget {
  final _Feature item;
  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [item.bg.withOpacity(0.3), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                item.icon,
                size: 120,
                color: AppColors.primaryColor.withOpacity(0.06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryTextColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.amber.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.play_circle_rounded,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.lessons,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;
  _CategoryCardData(this.title, this.subtitle, this.icon, this.bg);
}

class _CategoryCard extends StatelessWidget {
  final _CategoryCardData data;
  const _CategoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: data.bg.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: data.bg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      data.icon,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Explore →',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningItem {
  final String title;
  final String category;
  final double progress;
  final String progressText;
  final IconData icon;

  _LearningItem(
    this.title,
    this.category,
    this.progress,
    this.progressText,
    this.icon,
  );
}

class _LearningCard extends StatelessWidget {
  final _LearningItem item;
  const _LearningCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.2),
                    AppColors.secondaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: AppColors.primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.progressText,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${(item.progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 20,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
