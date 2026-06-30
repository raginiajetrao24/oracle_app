import 'package:flutter/material.dart';
import 'package:flutter_app/screens/client_groups/person_directory_screen.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

class PersonProfileScreen extends StatefulWidget {
  final PersonRecord person;

  const PersonProfileScreen({super.key, required this.person});

  @override
  State<PersonProfileScreen> createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen> {
  static const _blue = Color(0xFF1F4E8C);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  bool _nationalIdVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            AppHeaderWidget(title: widget.person.name, showBack: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  _buildHeroCard(),
                  _ActionStrip(
                    actions: [
                      _ProfileAction(
                        icon: Icons.edit_outlined,
                        label: 'Edit',
                        onTap: _showUnavailable,
                      ),
                      _ProfileAction(
                        icon: Icons.history_rounded,
                        label: 'History',
                        onTap: _showUnavailable,
                      ),
                      _ProfileAction(
                        icon: Icons.more_horiz_rounded,
                        label: 'More',
                        onTap: _showMoreActions,
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Personal Info',
                    icon: Icons.badge_outlined,
                    actionIcon: Icons.edit_outlined,
                    onAction: _showUnavailable,
                    children: [
                      _FieldGrid(
                        fields: [
                          _InfoField('Start Date', '6/15/05'),
                          _InfoField('Name Style', 'United States'),
                          _InfoField('Last Name', _lastName),
                          _InfoField('First Name', _firstName),
                          _InfoField('Title', _titleForPerson),
                          _InfoField('Display Name', widget.person.name),
                          _InfoField(
                            'Person Number',
                            widget.person.personNumber,
                          ),
                          _InfoField('Worker Type', 'Employee'),
                        ],
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Contacts',
                    icon: Icons.contact_phone_outlined,
                    actionIcon: Icons.add_rounded,
                    onAction: _showUnavailable,
                    children: [
                      _ContactTile(
                        icon: Icons.mail_outline_rounded,
                        title: 'Work Email',
                        value: widget.person.email.isEmpty
                            ? 'No email recorded'
                            : widget.person.email,
                        status: 'Primary',
                      ),
                      const SizedBox(height: 10),
                      _ContactTile(
                        icon: Icons.phone_outlined,
                        title: 'Work Phone',
                        value: widget.person.phone.isEmpty
                            ? 'No phone recorded'
                            : widget.person.phone,
                        status: widget.person.phone.isEmpty ? null : 'Primary',
                      ),
                      const SizedBox(height: 10),
                      const _ContactTile(
                        icon: Icons.home_outlined,
                        title: 'Home Address',
                        value: 'Doha, Qatar',
                      ),
                      const SizedBox(height: 12),
                      _LinkRow(
                        label: 'Manage Contact Preferences',
                        onTap: _showUnavailable,
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Documents',
                    icon: Icons.description_outlined,
                    actionIcon: Icons.add_rounded,
                    onAction: _showUnavailable,
                    children: const [
                      _MiniTable(
                        headers: ['Type', 'Number', 'Expiration'],
                        rows: [
                          ['Passport', 'P-4589221', '12/31/29'],
                          ['Residence Permit', 'RP-778120', '6/14/27'],
                          ['Employment Contract', 'DOC-2026-001', '-'],
                        ],
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'National Identifiers',
                    icon: Icons.credit_card_outlined,
                    actionIcon: Icons.edit_outlined,
                    onAction: _showUnavailable,
                    children: [
                      _FieldGrid(
                        fields: [
                          _InfoField('Country', 'United States'),
                          _InfoField(
                            'National ID Type',
                            'Social Security Number',
                          ),
                          _InfoField(
                            'National ID',
                            _nationalIdVisible ? '123-45-6789' : '*********',
                            trailing: IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                _nationalIdVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: _muted,
                              ),
                              onPressed: () => setState(
                                () => _nationalIdVisible = !_nationalIdVisible,
                              ),
                            ),
                          ),
                          _InfoField('Issue Date', '-'),
                          _InfoField('Expiration Date', '-'),
                          _InfoField('Primary', 'Yes'),
                        ],
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Biographical Info',
                    icon: Icons.cake_outlined,
                    children: [
                      _FieldGrid(
                        fields: [
                          _InfoField('Date of Birth', '10/23/76'),
                          _InfoField('Age', _ageText()),
                          _InfoField('Country of Birth', 'United States'),
                          _InfoField('Town of Birth', 'Redwood City'),
                        ],
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Demographic Info',
                    icon: Icons.groups_2_outlined,
                    actionIcon: Icons.edit_outlined,
                    onAction: _showUnavailable,
                    children: [
                      _Subheading('United States'),
                      _FieldGrid(
                        fields: [
                          _InfoField('Marital Status', 'Single'),
                          _InfoField('Start Date', '6/15/05'),
                          _InfoField('Gender', 'Male'),
                          _InfoField(
                            'Highest Education Level',
                            'Bachelor of Arts',
                          ),
                          _InfoField('Veteran Self-Identification Status', '-'),
                          _InfoField('Regional Ethnicity or Race', '-'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _Subheading('Ethnicity'),
                      const _CheckRow(
                        label: 'I am Hispanic or Latino.',
                        value: false,
                      ),
                      const _CheckRow(
                        label: 'American Indian or Alaska Native',
                        value: false,
                      ),
                      const _CheckRow(label: 'Asian', value: false),
                      const _CheckRow(
                        label: 'Black or African American',
                        value: false,
                      ),
                      const _CheckRow(
                        label: 'Native Hawaiian or other Pacific Islander',
                        value: false,
                      ),
                      const _CheckRow(label: 'White', value: false),
                    ],
                  ),
                  _SectionCard(
                    title: 'Disabilities',
                    icon: Icons.accessible_forward_outlined,
                    actionIcon: Icons.add_rounded,
                    onAction: _showUnavailable,
                    children: const [
                      _EmptyState(
                        icon: Icons.info_outline_rounded,
                        text:
                            'No disability declaration is recorded. Add mental or physical disabilities, or decline to declare.',
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Extra Info',
                    icon: Icons.tune_rounded,
                    actionIcon: Icons.edit_outlined,
                    onAction: _showUnavailable,
                    children: [
                      _FieldGrid(
                        fields: [
                          _InfoField('Department', widget.person.department),
                          _InfoField('Location', widget.person.location),
                          _InfoField('Manager', widget.person.manager),
                          _InfoField('Business Unit', 'Mannai Corporation'),
                          _InfoField(
                            'Assignment Status',
                            'Active - Assignment',
                          ),
                          _InfoField('User Person Type', 'Employee'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: _blue,
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Approvals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Directory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String get _firstName => widget.person.name.split(' ').first;

  String get _lastName {
    final parts = widget.person.name.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '-';
  }

  String get _titleForPerson {
    if (widget.person.name.startsWith('Aisha') ||
        widget.person.name.startsWith('Carli') ||
        widget.person.name.startsWith('Halle') ||
        widget.person.name.startsWith('Hope') ||
        widget.person.name.startsWith('Sue')) {
      return 'Ms.';
    }
    return 'Mr.';
  }

  String _ageText() {
    final dob = DateTime(1976, 10, 23);
    final now = DateTime.now();
    var years = now.year - dob.year;
    var months = now.month - dob.month;
    if (now.day < dob.day) months -= 1;
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    return '$years Years $months Months';
  }

  Widget _buildHeroCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Text(
              widget.person.initials,
              style: const TextStyle(
                color: _blue,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.person.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.person.job,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: _muted),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill('Person ${widget.person.personNumber}'),
                    const _Pill('Active'),
                    _Pill(widget.person.location),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This action is available in the web application.'),
      ),
    );
  }

  void _showMoreActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetAction(
              icon: Icons.person_search_outlined,
              label: 'Search person',
              onTap: _closeSheet,
            ),
            _SheetAction(
              icon: Icons.print_outlined,
              label: 'Print profile',
              onTap: _closeSheet,
            ),
            _SheetAction(
              icon: Icons.file_download_outlined,
              label: 'Export details',
              onTap: _closeSheet,
            ),
            _SheetAction(
              icon: Icons.close_rounded,
              label: 'Close',
              onTap: _closeSheet,
            ),
          ],
        ),
      ),
    );
  }

  void _closeSheet() => Navigator.pop(context);

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    this.actionIcon,
    this.onAction,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Icon(icon, color: const Color(0xFF1F4E8C), size: 20),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ?actionIcon == null
                  ? null
                  : IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        actionIcon,
                        size: 20,
                        color: const Color(0xFF64748B),
                      ),
                      onPressed: onAction,
                    ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF64748B),
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}

class _FieldGrid extends StatelessWidget {
  final List<_InfoField> fields;
  const _FieldGrid({required this.fields});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 560 ? 3 : 2;
        final itemWidth =
            (constraints.maxWidth - ((columns - 1) * 12)) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 14,
          children: fields
              .map((field) => SizedBox(width: itemWidth, child: field))
              .toList(),
        );
      },
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoField(this.label, this.value, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? '-' : value,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ],
    );
  }
}

class _ActionStrip extends StatelessWidget {
  final List<_ProfileAction> actions;
  const _ActionStrip({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: actions
            .map(
              (action) => Expanded(
                child: TextButton.icon(
                  onPressed: action.onTap,
                  icon: Icon(action.icon, size: 18),
                  label: FittedBox(child: Text(action.label)),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1F4E8C),
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProfileAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? status;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1F4E8C), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (status != null) _Pill(status!),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FC),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1F4E8C),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MiniTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;

  const _MiniTable({required this.headers, required this.rows});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.3),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1),
        },
        border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 0.8),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
            children: headers
                .map((header) => _TableCell(header, head: true))
                .toList(),
          ),
          ...rows.map(
            (row) => TableRow(
              children: row.map((cell) => _TableCell(cell)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool head;
  const _TableCell(this.text, {this.head = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          color: head ? const Color(0xFF475569) : const Color(0xFF1E293B),
          fontWeight: head ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  const _CheckRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: null,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Subheading extends StatelessWidget {
  final String text;
  const _Subheading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1F4E8C),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: Color(0xFF1F4E8C),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1F4E8C)),
      title: Text(label),
      onTap: onTap,
    );
  }
}
