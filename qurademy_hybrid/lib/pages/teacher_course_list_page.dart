import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/utils/colors.dart';
import 'package:qurademy_hybrid/pages/teacher_create_course_page.dart';
import 'package:qurademy_hybrid/pages/teacher_course_detail_page.dart';

class TeacherCourseListPage extends StatefulWidget {
  final bool openAddOnStart;
  const TeacherCourseListPage({super.key, this.openAddOnStart = false});

  @override
  State<TeacherCourseListPage> createState() => _TeacherCourseListPageState();
}

class _TeacherCourseListPageState extends State<TeacherCourseListPage> {
  int _selectedFilter = 0; // 0: All, 1: Active, 2: Drafts, 3: Archived
  String _selectedSort = 'Recently Updated';

  final List<_TCourse> _all = [
    _TCourse(
      title: 'Flutter Development Masterclass',
      category: 'Mobile Development',
      status: CourseStatus.active,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      students: 48,
      lessons: 85,
      rating: 4.8,
    ),
    _TCourse(
      title: 'UI/UX Design Basics',
      category: 'Design',
      status: CourseStatus.draft,
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      students: 0,
      lessons: 60,
      rating: 0,
    ),
    _TCourse(
      title: 'Data Science Pro',
      category: 'Data & AI',
      status: CourseStatus.archived,
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      students: 210,
      lessons: 95,
      rating: 4.7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.openAddOnStart) {
      // Allow first frame to render before opening the sheet
      WidgetsBinding.instance.addPostFrameCallback((_) => _openCreatePage());
    }
  }

  List<_TCourse> get _filtered {
    switch (_selectedFilter) {
      case 1:
        return _all.where((c) => c.status == CourseStatus.active).toList();
      case 2:
        return _all.where((c) => c.status == CourseStatus.draft).toList();
      case 3:
        return _all.where((c) => c.status == CourseStatus.archived).toList();
      default:
        return _all;
    }
  }

  List<_TCourse> get _sorted {
    final list = [..._filtered];
    switch (_selectedSort) {
      case 'A-Z':
        list.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case 'Recently Updated':
      default:
        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }
    return list;
  }

  Future<void> _openCreatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TeacherCreateCoursePage()),
    );
    if (result is Map) {
      final title = (result['title'] as String?)?.trim();
      final category = (result['category'] as String?)?.trim() ?? '';
      final lessons = (result['lessons'] as int?) ?? 0;
      final statusStr = result['status'] as String?;
      final typeStr = result['type'] as String?;
      final schedule = result['schedule'] as Map?;
      final status = CourseStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => CourseStatus.draft,
      );
      final type = CourseTypeExt.fromName(typeStr);
      if (title != null && title.isNotEmpty) {
        setState(() {
          _all.add(
            _TCourse(
              title: title,
              category: category,
              lessons: lessons,
              status: status,
              updatedAt: DateTime.now(),
              students: 0,
              rating: 0,
              type: type,
              schedule: schedule?.map((k, v) => MapEntry(k.toString(), (v ?? '').toString())),
            ),
          );
        });
      }
    }
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
            'Your Courses',
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
        actions: [
          IconButton(
            onPressed: _openCreatePage,
            icon: const Icon(Icons.add_rounded, color: AppColors.primaryColor),
            tooltip: 'Add Course',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePage,
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Course',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
              child: _sorted.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No courses yet.\nTap “New Course” to create your first course.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: _sorted.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _TeacherCourseTile(course: _sorted[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filters() {
    final chips = ['All', 'Active', 'Drafts', 'Archived'];
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
                    : Border.all(color: Colors.grey.shade300),
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
                    value: 'Recently Updated',
                    child: Text('Recently Updated'),
                  ),
                  DropdownMenuItem(value: 'A-Z', child: Text('A-Z')),
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

enum CourseStatus { active, draft, archived }
enum CourseType { selfPaced, scheduled }

extension CourseTypeExt on CourseType {
  static CourseType fromName(String? name) {
    switch (name) {
      case 'scheduled':
        return CourseType.scheduled;
      case 'selfPaced':
      default:
        return CourseType.selfPaced;
    }
  }

  String get label => this == CourseType.scheduled ? 'Scheduled' : 'Self-Paced';
}

class _TCourse {
  final String title;
  final String category;
  final int lessons;
  final int students;
  final double rating;
  final CourseStatus status;
  final DateTime updatedAt;
  final CourseType type;
  final Map<String, String>? schedule; // keys: startDate, endDate, startTime, endTime, meetingLink

  _TCourse({
    required this.title,
    required this.category,
    required this.lessons,
    required this.students,
    required this.rating,
    required this.status,
    required this.updatedAt,
    this.type = CourseType.selfPaced,
    this.schedule,
  });
}

class _TeacherCourseTile extends StatelessWidget {
  final _TCourse course;
  const _TeacherCourseTile({required this.course});

  Color _statusColor(CourseStatus s) {
    switch (s) {
      case CourseStatus.active:
        return const Color(0xFFB2F2D3);
      case CourseStatus.draft:
        return const Color(0xFFFFF2B2);
      case CourseStatus.archived:
        return const Color(0xFFFFE1D5);
    }
  }

  String _statusText(CourseStatus s) {
    switch (s) {
      case CourseStatus.active:
        return 'Active';
      case CourseStatus.draft:
        return 'Draft';
      case CourseStatus.archived:
        return 'Archived';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final statusText = _statusText(course.status);
        final typeLabel = course.type.label;
        final scheduleBrief = course.schedule == null ? null : _briefSchedule(course.schedule!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeacherCourseDetailPage(
              title: course.title,
              category: course.category,
              lessons: course.lessons,
              students: course.students,
              rating: course.rating,
              status: statusText,
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
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.secondaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.play_circle_fill_rounded,
                color: AppColors.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryTextColor,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Type badge and optional brief schedule info
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
                              course.type.label,
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
                        const SizedBox(width: 10),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.lessons} lessons',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.people_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.students} students',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
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
                        course.rating == 0
                            ? '—'
                            : course.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(course.status).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _statusText(course.status),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                            fontSize: 12,
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
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCourseData {
  final String title;
  final String category;
  final int lessons;
  final CourseStatus status;

  _AddCourseData({
    required this.title,
    required this.category,
    required this.lessons,
    required this.status,
  });
}

class _AddCourseSheet extends StatefulWidget {
  final void Function(_AddCourseData) onSubmit;
  const _AddCourseSheet({required this.onSubmit});

  @override
  State<_AddCourseSheet> createState() => _AddCourseSheetState();
}

class _AddCourseSheetState extends State<_AddCourseSheet> {
  final _title = TextEditingController();
  final _category = TextEditingController();
  final _lessons = TextEditingController();
  CourseStatus _status = CourseStatus.draft;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _title.dispose();
    _category.dispose();
    _lessons.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(
      _AddCourseData(
        title: _title.text.trim(),
        category: _category.text.trim(),
        lessons: int.tryParse(_lessons.text.trim()) ?? 0,
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Create New Course',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryTextColor,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lessons,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Lessons count'),
                ),
                const SizedBox(height: 12),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CourseStatus>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(
                          value: CourseStatus.draft,
                          child: Text('Draft'),
                        ),
                        DropdownMenuItem(
                          value: CourseStatus.active,
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: CourseStatus.archived,
                          child: Text('Archived'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? _status),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
