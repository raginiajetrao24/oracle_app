import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../core/constants/dummy_employee.dart';

class PersonInformationScreen extends StatelessWidget {
  const PersonInformationScreen({super.key});

  static void _openEdit(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Person Information'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Hero ───────────────────────────────────────────
            const _ProfileHero(),
            const SizedBox(height: 24),

            const _SectionLabel('Personal Details'),
            const SizedBox(height: 10),

            _InfoSection(
              icon: Icons.person_outline_rounded,
              title: 'Name & Addresses',
              color: const Color(0xFF3B82F6),
              onEdit: () => _openEdit(context, const _NameAddressSheet()),
              rows: [
                _Row('Title', employeeData.title),
                _Row('First Name', employeeData.firstName),
                _Row('Last Name', employeeData.lastName),
                _Row('Home Address', employeeData.homeAddress),
              ],
            ),
            const SizedBox(height: 12),

            _InfoSection(
              icon: Icons.phone_outlined,
              title: 'Communication Methods',
              color: const Color(0xFF10B981),
              onEdit: () => _openEdit(context, const _CommunicationSheet()),
              rows: [
                _Row('Phone', employeeData.phone),
                _Row('Email', employeeData.email),
              ],
            ),
            const SizedBox(height: 12),

            _InfoSection(
              icon: Icons.badge_outlined,
              title: 'National Identifiers',
              color: const Color(0xFF8B5CF6),
              onEdit: () => _openEdit(context, const _NationalIdSheet()),
              rows: [
                _Row('PAN', employeeData.pan),
                _Row('National ID', employeeData.nationalId),
              ],
            ),
            const SizedBox(height: 24),

            const _SectionLabel('Biographical'),
            const SizedBox(height: 10),

            _InfoSection(
              icon: Icons.cake_outlined,
              title: 'Biographical Information',
              color: const Color(0xFFF59E0B),
              onEdit: () => _openEdit(context, const _BiographicalSheet()),
              rows: [
                _Row('Date of Birth', employeeData.dateOfBirth),
                _Row('Blood Group', employeeData.bloodGroup),
              ],
            ),
            const SizedBox(height: 12),

            _InfoSection(
              icon: Icons.people_outline_rounded,
              title: 'Gender & Marital Status',
              color: const Color(0xFFEC4899),
              onEdit: () => _openEdit(context, const _GenderMaritalSheet()),
              rows: [
                _Row('Gender', employeeData.gender),
                _Row('Marital Status', employeeData.maritalStatus),
              ],
            ),
            const SizedBox(height: 12),

            _InfoSection(
              icon: Icons.account_balance_outlined,
              title: 'Ethnicity & Religion',
              color: const Color(0xFF06B6D4),
              onEdit: () => _openEdit(context, const _EthnicityReligionSheet()),
              rows: [
                _Row('Religion', employeeData.religion),
                _Row('Ethnicity', employeeData.ethnicity),
              ],
            ),
            const SizedBox(height: 12),

            _InfoSection(
              icon: Icons.public_rounded,
              title: 'Legislative Information',
              color: const Color(0xFF6366F1),
              onEdit: () => _openEdit(context, const _LegislativeSheet()),
              rows: [_Row('Country', employeeData.country)],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Hero ─────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    final initials = '${employeeData.firstName[0]}${employeeData.lastName[0]}'
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF1E6FBF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${employeeData.firstName} ${employeeData.lastName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employeeData.jobTitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    employeeData.employeeId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    ),
  );
}

// ─── Info section card ────────────────────────────────────────────────────────

class _Row {
  final String label;
  final String value;
  const _Row(this.label, this.value);
}

class _InfoSection extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onEdit;
  final List<_Row> rows;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.onEdit,
    required this.rows,
  });

  @override
  State<_InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<_InfoSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, size: 20, color: widget.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  // Edit icon button
                  InkWell(
                    onTap: widget.onEdit,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable rows
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _expanded
                ? Container(
                    color: const Color(0xFFFAFBFC),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: Column(
                      children: [
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 12),
                        ...widget.rows.map(
                          (r) => _DataRow(label: r.label, value: r.value),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BASE BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _BaseSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;

  const _BaseSheet({
    required this.title,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Title + close
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 24, color: AppColors.border),
            // Form content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: child,
              ),
            ),
            // Save button
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    onSave();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Changes saved successfully'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF16A34A),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared field helpers ─────────────────────────────────────────────────────

InputDecoration _fieldDeco(String label, {bool isRequired = false}) =>
    InputDecoration(
      labelText: isRequired ? '$label *' : label,
      labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );

Widget _gap([double h = 14]) => SizedBox(height: h);

Widget _sheetLabel(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 12, top: 4),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
      letterSpacing: 0.3,
    ),
  ),
);

// ─── Name & Address sheet ─────────────────────────────────────────────────────

class _NameAddressSheet extends StatefulWidget {
  const _NameAddressSheet();

  @override
  State<_NameAddressSheet> createState() => _NameAddressSheetState();
}

class _NameAddressSheetState extends State<_NameAddressSheet> {
  late String _title;
  late final TextEditingController _first,
      _father,
      _grandfather,
      _last,
      _motherFirst,
      _motherLast,
      _address;
  late bool _primaryMailing;

  @override
  void initState() {
    super.initState();
    _title = employeeData.title;
    _first = TextEditingController(text: employeeData.firstName);
    _father = TextEditingController(text: employeeData.fatherName);
    _grandfather = TextEditingController(text: employeeData.grandfatherName);
    _last = TextEditingController(text: employeeData.lastName);
    _motherFirst = TextEditingController(text: employeeData.motherFirstName);
    _motherLast = TextEditingController(text: employeeData.motherLastName);
    _address = TextEditingController(text: employeeData.homeAddress);
    _primaryMailing = employeeData.primaryMailing;
  }

  @override
  void dispose() {
    for (final c in [
      _first,
      _father,
      _grandfather,
      _last,
      _motherFirst,
      _motherLast,
      _address,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Name & Addresses',
      onSave: () {
        employeeData.title = _title;
        employeeData.firstName = _first.text.trim();
        employeeData.fatherName = _father.text.trim();
        employeeData.grandfatherName = _grandfather.text.trim();
        employeeData.lastName = _last.text.trim();
        employeeData.motherFirstName = _motherFirst.text.trim();
        employeeData.motherLastName = _motherLast.text.trim();
        employeeData.homeAddress = _address.text.trim();
        employeeData.primaryMailing = _primaryMailing;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sheetLabel('Name Information'),
          DropdownButtonFormField<String>(
            initialValue: _title,
            decoration: _fieldDeco('Title'),
            items: [
              'Mr',
              'Ms',
              'Mrs',
              'Dr',
            ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _title = v ?? _title),
          ),
          _gap(),
          TextField(
            controller: _first,
            decoration: _fieldDeco('First Name', isRequired: true),
          ),
          _gap(),
          TextField(
            controller: _father,
            decoration: _fieldDeco('Second / Father Name'),
          ),
          _gap(),
          TextField(
            controller: _grandfather,
            decoration: _fieldDeco('Third / Grandfather Name'),
          ),
          _gap(),
          TextField(
            controller: _last,
            decoration: _fieldDeco('Last Name', isRequired: true),
          ),
          _gap(),
          TextField(
            controller: _motherFirst,
            decoration: _fieldDeco('Mother First Name'),
          ),
          _gap(),
          TextField(
            controller: _motherLast,
            decoration: _fieldDeco('Mother Last Name'),
          ),
          _gap(20),
          const Divider(color: AppColors.border),
          _sheetLabel('Address Information'),
          TextField(
            controller: _address,
            maxLines: 4,
            decoration: _fieldDeco('Home Address'),
          ),
          _gap(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: SwitchListTile(
              value: _primaryMailing,
              title: const Text(
                'Primary Mailing Address',
                style: TextStyle(fontSize: 14),
              ),
              activeThumbColor: AppColors.primary,
              onChanged: (v) => setState(() => _primaryMailing = v),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Communication sheet ──────────────────────────────────────────────────────

class _CommunicationSheet extends StatefulWidget {
  const _CommunicationSheet();

  @override
  State<_CommunicationSheet> createState() => _CommunicationSheetState();
}

class _CommunicationSheetState extends State<_CommunicationSheet> {
  late final TextEditingController _phone, _email;

  @override
  void initState() {
    super.initState();
    _phone = TextEditingController(text: employeeData.phone);
    _email = TextEditingController(text: employeeData.email);
  }

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _BaseSheet(
    title: 'Communication Methods',
    onSave: () {
      employeeData.phone = _phone.text.trim();
      employeeData.email = _email.text.trim();
    },
    child: Column(
      children: [
        TextField(
          controller: _phone,
          decoration: _fieldDeco('Phone Number'),
          keyboardType: TextInputType.phone,
        ),
        _gap(),
        TextField(
          controller: _email,
          decoration: _fieldDeco('Email Address'),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    ),
  );
}

// ─── National ID sheet ────────────────────────────────────────────────────────

class _NationalIdSheet extends StatefulWidget {
  const _NationalIdSheet();

  @override
  State<_NationalIdSheet> createState() => _NationalIdSheetState();
}

class _NationalIdSheetState extends State<_NationalIdSheet> {
  late final TextEditingController _pan, _national;

  @override
  void initState() {
    super.initState();
    _pan = TextEditingController(text: employeeData.pan);
    _national = TextEditingController(text: employeeData.nationalId);
  }

  @override
  void dispose() {
    _pan.dispose();
    _national.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _BaseSheet(
    title: 'National Identifiers',
    onSave: () {
      employeeData.pan = _pan.text.trim();
      employeeData.nationalId = _national.text.trim();
    },
    child: Column(
      children: [
        TextField(controller: _pan, decoration: _fieldDeco('PAN')),
        _gap(),
        TextField(controller: _national, decoration: _fieldDeco('National ID')),
      ],
    ),
  );
}

// ─── Biographical sheet ───────────────────────────────────────────────────────

class _BiographicalSheet extends StatefulWidget {
  const _BiographicalSheet();

  @override
  State<_BiographicalSheet> createState() => _BiographicalSheetState();
}

class _BiographicalSheetState extends State<_BiographicalSheet> {
  late final TextEditingController _dob, _blood;

  @override
  void initState() {
    super.initState();
    _dob = TextEditingController(text: employeeData.dateOfBirth);
    _blood = TextEditingController(text: employeeData.bloodGroup);
  }

  @override
  void dispose() {
    _dob.dispose();
    _blood.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _BaseSheet(
    title: 'Biographical Information',
    onSave: () {
      employeeData.dateOfBirth = _dob.text.trim();
      employeeData.bloodGroup = _blood.text.trim();
    },
    child: Column(
      children: [
        TextField(controller: _dob, decoration: _fieldDeco('Date of Birth')),
        _gap(),
        TextField(controller: _blood, decoration: _fieldDeco('Blood Group')),
      ],
    ),
  );
}

// ─── Gender & Marital sheet ───────────────────────────────────────────────────

class _GenderMaritalSheet extends StatefulWidget {
  const _GenderMaritalSheet();

  @override
  State<_GenderMaritalSheet> createState() => _GenderMaritalSheetState();
}

class _GenderMaritalSheetState extends State<_GenderMaritalSheet> {
  late String _gender, _marital;

  @override
  void initState() {
    super.initState();
    _gender = employeeData.gender;
    _marital = employeeData.maritalStatus;
  }

  @override
  Widget build(BuildContext context) => _BaseSheet(
    title: 'Gender & Marital Status',
    onSave: () {
      employeeData.gender = _gender;
      employeeData.maritalStatus = _marital;
    },
    child: Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _gender,
          decoration: _fieldDeco('Gender'),
          items: [
            'Male',
            'Female',
            'Non-binary',
            'Prefer not to say',
          ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (v) => setState(() => _gender = v ?? _gender),
        ),
        _gap(),
        DropdownButtonFormField<String>(
          initialValue: _marital,
          decoration: _fieldDeco('Marital Status'),
          items: [
            'Single',
            'Married',
            'Divorced',
            'Widowed',
          ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
          onChanged: (v) => setState(() => _marital = v ?? _marital),
        ),
      ],
    ),
  );
}

// ─── Ethnicity & Religion sheet ───────────────────────────────────────────────

class _EthnicityReligionSheet extends StatefulWidget {
  const _EthnicityReligionSheet();

  @override
  State<_EthnicityReligionSheet> createState() =>
      _EthnicityReligionSheetState();
}

class _EthnicityReligionSheetState extends State<_EthnicityReligionSheet> {
  late final TextEditingController _religion, _ethnicity;

  @override
  void initState() {
    super.initState();
    _religion = TextEditingController(text: employeeData.religion);
    _ethnicity = TextEditingController(text: employeeData.ethnicity);
  }

  @override
  void dispose() {
    _religion.dispose();
    _ethnicity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _BaseSheet(
    title: 'Ethnicity & Religion',
    onSave: () {
      employeeData.religion = _religion.text.trim();
      employeeData.ethnicity = _ethnicity.text.trim();
    },
    child: Column(
      children: [
        TextField(controller: _religion, decoration: _fieldDeco('Religion')),
        _gap(),
        TextField(controller: _ethnicity, decoration: _fieldDeco('Ethnicity')),
      ],
    ),
  );
}

// ─── Legislative sheet ────────────────────────────────────────────────────────

class _LegislativeSheet extends StatefulWidget {
  const _LegislativeSheet();

  @override
  State<_LegislativeSheet> createState() => _LegislativeSheetState();
}

class _LegislativeSheetState extends State<_LegislativeSheet> {
  late final TextEditingController _country;

  @override
  void initState() {
    super.initState();
    _country = TextEditingController(text: employeeData.country);
  }

  @override
  void dispose() {
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _BaseSheet(
    title: 'Legislative Information',
    onSave: () => employeeData.country = _country.text.trim(),
    child: TextField(controller: _country, decoration: _fieldDeco('Country')),
  );
}
