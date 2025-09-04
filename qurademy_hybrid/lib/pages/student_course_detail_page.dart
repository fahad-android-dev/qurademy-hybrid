import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/utils/colors.dart';

class StudentCourseDetailPage extends StatelessWidget {
  final String title;
  final String category;
  final double rating;
  final String lessons;
  final bool enrolled;
  final double progress; // for self-paced
  final String? typeLabel; // Self-Paced / Scheduled
  final String? scheduleBrief; // optional brief schedule text

  const StudentCourseDetailPage({
    super.key,
    required this.title,
    required this.category,
    required this.rating,
    required this.lessons,
    required this.enrolled,
    required this.progress,
    this.typeLabel,
    this.scheduleBrief,
  });

  //

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
            'Course Details',
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
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryColor),
          ),
        ),
        actions: const [SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.1),
                      AppColors.secondaryColor.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: AppColors.primaryColor, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondaryTextColor,
                                fontSize: 18,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (typeLabel != null) _badge(typeLabel!),
                                _badge(category, icon: Icons.category_rounded),
                              ],
                            ),
                            if (scheduleBrief != null && scheduleBrief!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primaryColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      scheduleBrief!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Stats grid (responsive)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxW = constraints.maxWidth;
                    final cols = maxW < 360 ? 2 : 3;
                    const spacing = 12.0;
                    final itemW = (maxW - spacing * (cols - 1)) / cols;
                    final lessonsNum = _extractDigits(lessons);
                    final tiles = <Widget>[
                      _statTile(icon: Icons.menu_book_rounded, label: 'Lessons', value: lessonsNum.isEmpty ? lessons : lessonsNum),
                      _statTile(icon: Icons.star_rounded, label: 'Rating', value: rating.toStringAsFixed(1)),
                      _statTile(icon: Icons.verified_rounded, label: 'Enrolled', value: enrolled ? 'Yes' : 'No'),
                    ];
                    return Wrap(
                      spacing: spacing,
                      runSpacing: 12,
                      children: tiles.map((t) => SizedBox(width: itemW, child: t)).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Overview card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Overview'),
                    const SizedBox(height: 12),
                    _kv('Category', category),
                    _kv('Type', typeLabel ?? '—'),
                    _kv('Lessons', lessons),
                    _kv('Rating', rating.toStringAsFixed(1)),
                    _kv('Enrolled', enrolled ? 'Yes' : 'No'),
                    if (enrolled && progress > 0) _kv('Progress', '${(progress * 100).toInt()}%'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // CTA button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    shadowColor: AppColors.primaryColor.withOpacity(0.3),
                    elevation: 4,
                  ),
                  child: Text(
                    enrolled
                        ? (typeLabel == 'Scheduled' ? 'Join' : 'Continue')
                        : 'Enroll',
                    style: const TextStyle(
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
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(k, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600))),
          const SizedBox(width: 6),
          Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Widget _badge(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE9FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.primaryColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile({required IconData icon, required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: AppColors.primaryColor),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                color: AppColors.secondaryTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _extractDigits(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w800,
        color: AppColors.secondaryTextColor,
        fontSize: 16,
      ),
    );
  }
}
