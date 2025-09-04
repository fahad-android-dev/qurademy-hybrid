import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/utils/colors.dart';
import 'package:qurademy_hybrid/pages/student_course_detail_page.dart';

class StudentCourseListPage extends StatefulWidget {
  const StudentCourseListPage({super.key});

  @override
  State<StudentCourseListPage> createState() => _StudentCourseListPageState();
}

class _StudentCourseListPageState extends State<StudentCourseListPage> {
  int _selectedFilter = 0;
  String _selectedSort = 'Most Popular';

  final List<_Course> _allCourses = [
    _Course(
      title: 'Flutter Development Masterclass',
      category: 'Mobile Development',
      rating: 4.8,
      lessons: '85 lessons',
      icon: Icons.flutter_dash,
      bg: const Color(0xFFB2F2D3),
      enrolled: true,
      progress: 0.45,
      type: CourseType.selfPaced,
    ),
    _Course(
      title: 'UI/UX Design Basics',
      category: 'Design',
      rating: 4.7,
      lessons: '60 lessons',
      icon: Icons.brush_rounded,
      bg: const Color(0xFFE0E7FF),
      type: CourseType.selfPaced,
    ),
    _Course(
      title: 'React Fundamentals (Evening Batch)',
      category: 'Web Development',
      rating: 4.6,
      lessons: '72 lessons',
      icon: Icons.web_rounded,
      bg: const Color(0xFFFFE1D5),
      type: CourseType.scheduled,
      enrolled: true,
      schedule: const {
        'startDate': '2025-09-01',
        'endDate': '2025-09-30',
        'startTime': '18:00',
        'endTime': '19:30',
        'meetingLink': 'https://meet.example/react',
      },
    ),
    _Course(
      title: 'Data Science Pro',
      category: 'Data & AI',
      rating: 4.9,
      lessons: '95 lessons',
      icon: Icons.bubble_chart_outlined,
      bg: const Color(0xFFFFF2B2),
      enrolled: true,
      progress: 0.72,
      type: CourseType.selfPaced,
    ),
  ];

  List<_Course> get _filteredCourses {
    // Basic demo filters. Expand with real logic when backend/params are ready.
    switch (_selectedFilter) {
      case 1: // Popular
        return [..._allCourses]..sort((a, b) => b.rating.compareTo(a.rating));
      case 2: // New
        return _allCourses.reversed.toList();
      case 3: // Top Rated
        return [..._allCourses]..sort((a, b) => b.rating.compareTo(a.rating));
      default:
        return _allCourses;
    }
  }

  List<_Course> get _sorted {
    final list = [..._filteredCourses];
    switch (_selectedSort) {
      case 'Highest Rated':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
        // Placeholder: reverse order as a stand-in for "newest"
        list.reversed;
        break;
      case 'Most Popular':
      default:
        // Keep as-is for demo
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Courses',
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _filters(),
            const SizedBox(height: 8),
            _sortRow(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: _sorted.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _CourseCard(course: _sorted[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filters() {
    final chips = ['All', 'Popular', 'New', 'Top Rated'];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final selected = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: chips.length,
      ),
    );
  }

  Widget _sortRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Icon(
            Icons.tune_rounded,
            color: AppColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            'Sort by',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSort,
                borderRadius: BorderRadius.circular(12),
                items: const [
                  DropdownMenuItem(
                    value: 'Most Popular',
                    child: Text('Most Popular'),
                  ),
                  DropdownMenuItem(
                    value: 'Highest Rated',
                    child: Text('Highest Rated'),
                  ),
                  DropdownMenuItem(value: 'Newest', child: Text('Newest')),
                ],
                onChanged: (v) =>
                    setState(() => _selectedSort = v ?? _selectedSort),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum CourseType { selfPaced, scheduled }

String _briefSchedule(Map<String, String> s) {
  final sd = (s['startDate'] ?? '').trim();
  final ed = (s['endDate'] ?? '').trim();
  final st = (s['startTime'] ?? '').trim();
  final et = (s['endTime'] ?? '').trim();
  if (sd.isEmpty && ed.isEmpty && st.isEmpty && et.isEmpty) return '';
  final datePart = sd.isNotEmpty || ed.isNotEmpty ? '$sd${ed.isNotEmpty ? ' - $ed' : ''}' : '';
  final timePart = st.isNotEmpty || et.isNotEmpty ? '$st${et.isNotEmpty ? ' - $et' : ''}' : '';
  if (datePart.isNotEmpty && timePart.isNotEmpty) return '$datePart · $timePart';
  return datePart.isNotEmpty ? datePart : timePart;
}

class _Course {
  final String title;
  final String category;
  final double rating;
  final String lessons;
  final IconData icon;
  final Color bg;
  final bool enrolled;
  final double progress;
  final CourseType type;
  final Map<String, String>? schedule;

  _Course({
    required this.title,
    required this.category,
    required this.rating,
    required this.lessons,
    required this.icon,
    required this.bg,
    this.enrolled = false,
    this.progress = 0.0,
    this.type = CourseType.selfPaced,
    this.schedule,
  });
}

class _CourseCard extends StatelessWidget {
  final _Course course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final typeLabel = course.type == CourseType.scheduled ? 'Scheduled' : 'Self-Paced';
        final scheduleBrief = course.schedule == null ? null : _briefSchedule(course.schedule!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentCourseDetailPage(
              title: course.title,
              category: course.category,
              rating: course.rating,
              lessons: course.lessons,
              enrolled: course.enrolled,
              progress: course.progress,
              typeLabel: typeLabel,
              scheduleBrief: scheduleBrief,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: course.bg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(course.icon, color: AppColors.primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryTextColor,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.category,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Type badge and optional schedule snippet
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: course.type == CourseType.scheduled
                              ? const Color(0xFFDCE9FF)
                              : const Color(0xFFE6F7EF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              course.type == CourseType.scheduled ? Icons.schedule_rounded : Icons.self_improvement_rounded,
                              size: 14,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.type == CourseType.scheduled ? 'Scheduled' : 'Self-Paced',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (course.type == CourseType.scheduled && course.schedule != null) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _briefSchedule(course.schedule!),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.amber.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.play_circle_rounded,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.lessons,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  if (course.type == CourseType.selfPaced && course.enrolled) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${(course.progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: course.progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                  if (course.type == CourseType.scheduled && course.enrolled && course.schedule != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.event_available_rounded, size: 16, color: AppColors.primaryColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Next class: ${_briefSchedule(course.schedule!)}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _ctaButton(course: course),
          ],
        ),
      ),
    );
  }

  Widget _ctaButton({required _Course course}) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: course.enrolled
            ? AppColors.primaryColor.withOpacity(0.1)
            : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        () {
          if (course.type == CourseType.scheduled) {
            return course.enrolled ? 'Join' : 'Enroll';
          } else {
            return course.enrolled ? 'Continue' : 'Enroll';
          }
        }(),
        style: TextStyle(
          color: course.enrolled ? AppColors.primaryColor : Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
