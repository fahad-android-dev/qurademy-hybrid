import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/utils/colors.dart';

enum CourseStatus { active, draft, archived }

enum CourseType { selfPaced, scheduled }

class TeacherCreateCoursePage extends StatefulWidget {
  const TeacherCreateCoursePage({super.key});

  @override
  State<TeacherCreateCoursePage> createState() =>
      _TeacherCreateCoursePageState();
}

class _TeacherCreateCoursePageState extends State<TeacherCreateCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _category = TextEditingController();
  final _lessons = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _durationHours = TextEditingController();
  CourseStatus _status = CourseStatus.draft;
  String _language = 'English';
  bool _isPaid = false;
  CourseType _type = CourseType.selfPaced;
  // Simple schedule fields (text for demo). Could be hooked to pickers later.
  final _startDate = TextEditingController(); // e.g. 2025-09-01
  final _endDate = TextEditingController(); // e.g. 2025-09-30
  final _startTime = TextEditingController(); // e.g. 18:00
  final _endTime = TextEditingController(); // e.g. 19:30
  final _meetingLink = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _category.dispose();
    _lessons.dispose();
    _description.dispose();
    _price.dispose();
    _durationHours.dispose();
    _startDate.dispose();
    _endDate.dispose();
    _startTime.dispose();
    _endTime.dispose();
    _meetingLink.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    // Return the created course data (optional consumer can use it)
    Navigator.pop(context, {
      'title': _title.text.trim(),
      'category': _category.text.trim(),
      'lessons': int.tryParse(_lessons.text.trim()) ?? 0,
      'status': _status.name,
      'type': _type.name,
      // Extended fields (optional consumers)
      'description': _description.text.trim(),
      'language': _language,
      'isPaid': _isPaid,
      'price': _isPaid ? double.tryParse(_price.text.trim()) ?? 0.0 : 0.0,
      'durationHours': int.tryParse(_durationHours.text.trim()) ?? 0,
      'schedule': _type == CourseType.scheduled
          ? {
              'startDate': _startDate.text.trim(),
              'endDate': _endDate.text.trim(),
              'startTime': _startTime.text.trim(),
              'endTime': _endTime.text.trim(),
              'meetingLink': _meetingLink.text.trim(),
            }
          : null,
    });
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
            'Create Course',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pageHeader(),
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Basic Info',
                  child: Column(
                    children: [
                      _fieldTitle(),
                      const SizedBox(height: 12),
                      _fieldCategory(),
                      const SizedBox(height: 12),
                      _fieldLanguage(),
                      const SizedBox(height: 12),
                      _courseTypeChips(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (_type == CourseType.scheduled)
                  _sectionCard(
                    title: 'Schedule',
                    child: Column(
                      children: [
                        _row2(
                          _textField(
                            _startDate,
                            'Start date (YYYY-MM-DD)',
                            hint: '2025-09-01',
                          ),
                          _textField(
                            _endDate,
                            'End date (YYYY-MM-DD)',
                            hint: '2025-09-30',
                          ),
                        ),
                        const SizedBox(height: 12),
                        _row2(
                          _textField(
                            _startTime,
                            'Start time (24h)',
                            hint: '18:00',
                          ),
                          _textField(_endTime, 'End time (24h)', hint: '19:30'),
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          _meetingLink,
                          'Meeting link',
                          hint: 'https://meet...',
                        ),
                      ],
                    ),
                  ),
                if (_type == CourseType.scheduled) const SizedBox(height: 12),
                _sectionCard(
                  title: 'Content',
                  child: Column(
                    children: [
                      _fieldDescription(),
                      const SizedBox(height: 12),
                      _row2(_fieldLessons(), _fieldDurationHours()),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Pricing',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldPaidSwitch(),
                      if (_isPaid) const SizedBox(height: 12),
                      if (_isPaid) _fieldPrice(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _sectionCard(title: 'Status', child: _fieldStatus()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: _submitButton(),
        ),
      ),
    );
  }

  Widget _pageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Course Details',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.secondaryTextColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Fill in the information below to create your course.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  InputDecoration _dec(String label, {String? hint, Widget? prefix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefix,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _courseTypeChips() {
    final items = const [
      {'label': 'Self-Paced', 'value': CourseType.selfPaced},
      {'label': 'Scheduled Class', 'value': CourseType.scheduled},
    ];
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        children: [
          for (final it in items)
            ChoiceChip(
              label: Text(it['label'] as String),
              selected: _type == it['value'],
              selectedColor: AppColors.primaryColor.withOpacity(0.15),
              labelStyle: TextStyle(
                color: _type == it['value']
                    ? AppColors.primaryColor
                    : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) =>
                  setState(() => _type = it['value'] as CourseType),
            ),
        ],
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _dec(label, hint: hint),
    );
  }

  Widget _fieldTitle() {
    return TextFormField(
      controller: _title,
      decoration: _dec('Title', hint: 'e.g. Flutter for Beginners'),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Title is required' : null,
    );
  }

  Widget _fieldCategory() {
    return TextFormField(
      controller: _category,
      decoration: _dec('Category', hint: 'e.g. Mobile Development'),
    );
  }

  Widget _fieldLanguage() {
    const languages = ['English', 'Hindi', 'Urdu', 'Spanish'];
    return DropdownButtonFormField<String>(
      value: _language,
      decoration: _dec('Language'),
      items: languages
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => setState(() => _language = v ?? _language),
    );
  }

  Widget _fieldLessons() {
    return TextFormField(
      controller: _lessons,
      keyboardType: TextInputType.number,
      decoration: _dec('Lessons count', hint: 'e.g. 24'),
    );
  }

  Widget _fieldDurationHours() {
    return TextFormField(
      controller: _durationHours,
      keyboardType: TextInputType.number,
      decoration: _dec('Estimated duration (hrs)', hint: 'e.g. 12'),
    );
  }

  Widget _fieldDescription() {
    return TextFormField(
      controller: _description,
      maxLines: 4,
      decoration: _dec('Description', hint: 'Short summary of your course'),
    );
  }

  Widget _fieldPaidSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Paid course',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Switch(
          value: _isPaid,
          activeColor: AppColors.primaryColor,
          onChanged: (v) => setState(() => _isPaid = v),
        ),
      ],
    );
  }

  Widget _fieldPrice() {
    return TextFormField(
      controller: _price,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _dec(
        'Price',
        hint: 'e.g. 49.99',
        prefix: const Icon(Icons.currency_rupee_rounded),
      ),
      validator: (v) {
        if (!_isPaid) return null;
        final val = double.tryParse((v ?? '').trim());
        if (val == null || val < 0) return 'Enter a valid price';
        return null;
      },
    );
  }

  Widget _fieldStatus() {
    final items = const [
      {'label': 'Draft', 'value': CourseStatus.draft},
      {'label': 'Active', 'value': CourseStatus.active},
      {'label': 'Archived', 'value': CourseStatus.archived},
    ];
    return Wrap(
      spacing: 8,
      children: [
        for (final it in items)
          ChoiceChip(
            label: Text(it['label'] as String),
            selected: _status == it['value'],
            selectedColor: AppColors.primaryColor.withOpacity(0.15),
            labelStyle: TextStyle(
              color: _status == it['value']
                  ? AppColors.primaryColor
                  : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) =>
                setState(() => _status = it['value'] as CourseStatus),
          ),
      ],
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Create Course',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _row2(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}
