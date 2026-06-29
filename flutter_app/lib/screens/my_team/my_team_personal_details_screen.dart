import 'package:flutter/material.dart';
import 'package:flutter_app/screens/core_hr/person_information/person_information_screen.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

class MyTeamPersonalDetailsScreen extends StatefulWidget {
  const MyTeamPersonalDetailsScreen({super.key});

  @override
  State<MyTeamPersonalDetailsScreen> createState() =>
      _MyTeamPersonalDetailsScreenState();
}

class _MyTeamPersonalDetailsScreenState
    extends State<MyTeamPersonalDetailsScreen> {
  static const _blue = Color(0xFF1F4E8C);
  static const _text = Color(0xFF1F2937);
  static const _muted = Color(0xFF6B7280);

  final TextEditingController _searchController = TextEditingController();
  String _reportsFilter = 'Direct reports';
  String _assignmentStatus = 'All';
  String _workerType = 'Employee';
  bool _primaryAssignmentOnly = true;
  String _sortBy = 'Relevance';

  final List<Map<String, String>> _people = const [
    {
      'name': 'Khalid Almajid',
      'businessTitle': 'Minister',
      'personNumber': '11000',
      'assignmentNumber': 'E11000',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'workEmail': 'Khalid.Almajid@mannai.com.qa',
    },
    {
      'name': 'Anthony Wesley',
      'businessTitle': 'Call Center Agent',
      'personNumber': '657',
      'assignmentNumber': 'E657',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'workEmail': 'anthony.wesley@mannai.com.qa',
    },
    {
      'name': 'Ahmed Shahin',
      'businessTitle': 'Analyst',
      'personNumber': '2915',
      'assignmentNumber': 'E2915',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'workEmail': 'ahmed.shahin@mannai.com.qa',
    },
    {
      'name': 'Hope Hightower',
      'businessTitle': 'Human Resources Generalist',
      'personNumber': '4149',
      'assignmentNumber': 'E4149',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'workEmail': 'hope.hightower@mannai.com.qa',
    },
    {
      'name': 'Martin Lletget',
      'businessTitle': 'Human Resources Generalist',
      'personNumber': '4308',
      'assignmentNumber': 'E4308',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'workEmail': 'martin.lletget@mannai.com.qa',
    },
    {
      'name': 'Sue Eden',
      'businessTitle': 'Product Design Engineer',
      'personNumber': '4337',
      'assignmentNumber': 'E4337',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'workEmail': 'sue.eden@mannai.com.qa',
    },
    {
      'name': 'Junaid Mohamed',
      'businessTitle': 'UG HR Consultant',
      'personNumber': '7631',
      'assignmentNumber': 'E7631',
      'assignmentStatus': 'Inactive',
      'workerType': 'Contingent Worker',
      'workEmail': 'junaid.mohamed@mannai.com.qa',
    },
    {
      'name': 'Aisha Alma',
      'businessTitle': 'UG Manager',
      'personNumber': '7667',
      'assignmentNumber': '001234',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'workEmail': 'aisha.alma@mannai.com.qa',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredPeople {
    final query = _searchController.text.trim().toLowerCase();
    final rows = _people.where((person) {
      final matchesQuery =
          query.isEmpty ||
          [
            person['name'],
            person['businessTitle'],
            person['workEmail'],
            person['personNumber'],
          ].any((value) => (value ?? '').toLowerCase().contains(query));
      final matchesStatus =
          _assignmentStatus == 'All' ||
          person['assignmentStatus'] == _assignmentStatus;
      final matchesWorker =
          _workerType == 'All' || person['workerType'] == _workerType;
      return matchesQuery && matchesStatus && matchesWorker;
    }).toList();

    if (_sortBy == 'Name') {
      rows.sort((a, b) => a['name']!.compareTo(b['name']!));
    } else if (_sortBy == 'Person Number') {
      rows.sort((a, b) => a['personNumber']!.compareTo(b['personNumber']!));
    }
    return rows;
  }

  int get _activeFilterCount {
    var count = 0;
    if (_reportsFilter != 'Direct reports') count++;
    if (_assignmentStatus != 'All') count++;
    if (_workerType != 'Employee') count++;
    if (!_primaryAssignmentOnly) count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _reportsFilter = 'Direct reports';
      _assignmentStatus = 'All';
      _workerType = 'Employee';
      _primaryAssignmentOnly = true;
      _sortBy = 'Relevance';
    });
  }

  Future<void> _showFilterSheet() async {
    var reports = _reportsFilter;
    var status = _assignmentStatus;
    var worker = _workerType;
    var primaryOnly = _primaryAssignmentOnly;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildSheetDropdown(
                    label: 'Reports',
                    value: reports,
                    values: const ['Direct reports', 'All reports'],
                    onChanged: (value) => setSheetState(() => reports = value),
                  ),
                  const SizedBox(height: 14),
                  _buildSheetDropdown(
                    label: 'Assignment Status',
                    value: status,
                    values: const [
                      'All',
                      'Active - Payroll Eligible',
                      'Inactive',
                    ],
                    onChanged: (value) => setSheetState(() => status = value),
                  ),
                  const SizedBox(height: 14),
                  _buildSheetDropdown(
                    label: 'Worker Type',
                    value: worker,
                    values: const ['All', 'Employee', 'Contingent Worker'],
                    onChanged: (value) => setSheetState(() => worker = value),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: _blue,
                    value: primaryOnly,
                    title: const Text(
                      'Show primary assignment only',
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    onChanged: (value) =>
                        setSheetState(() => primaryOnly = value),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _reportsFilter = reports;
                          _assignmentStatus = status;
                          _workerType = worker;
                          _primaryAssignmentOnly = primaryOnly;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetDropdown({
    required String label,
    required String value,
    required List<String> values,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: values
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filteredPeople;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FC),
      body: Column(
        children: [
          const AppHeaderWidget(title: 'Personal Details', showBack: true),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchPanel(),
                  const SizedBox(height: 14),
                  _buildFilterBar(),
                  const SizedBox(height: 14),
                  _buildResultsCard(rows),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by name, title, work email, or person number',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          prefixIcon: const Icon(Icons.search_rounded, color: _muted),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _blue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip('Reports', _reportsFilter, removable: false),
          _buildFilterChip('Assignment Status', _assignmentStatus),
          _buildFilterChip('Worker Type', _workerType),
          _buildToggleChip(),
          _buildActionChip(
            label: 'Filters',
            icon: Icons.tune_rounded,
            onTap: _showFilterSheet,
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _clearFilters,
            child: Text(
              'Clear ($_activeFilterCount)',
              style: const TextStyle(
                color: _blue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, {bool removable = true}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label ', style: const TextStyle(color: _muted, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(
              color: _text,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (removable) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (label == 'Assignment Status') {
                    _assignmentStatus = 'All';
                  } else if (label == 'Worker Type') {
                    _workerType = 'All';
                  }
                });
              },
              child: const Icon(Icons.close_rounded, size: 16, color: _muted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToggleChip() {
    return GestureDetector(
      onTap: () =>
          setState(() => _primaryAssignmentOnly = !_primaryAssignmentOnly),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: _primaryAssignmentOnly
              ? const Color(0xFFE8F0FC)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _primaryAssignmentOnly
                ? const Color(0xFFD1E3F8)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _primaryAssignmentOnly
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 16,
              color: _primaryAssignmentOnly ? _blue : _muted,
            ),
            const SizedBox(width: 6),
            const Text(
              'Primary assignment only',
              style: TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _blue),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: _blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard(List<Map<String, String>> rows) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Text(
                  'Team Members (${rows.length})',
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildSortButton(),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Icon(Icons.view_column_outlined, color: _text),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              columnSpacing: 28,
              horizontalMargin: 14,
              columns: const [
                DataColumn(label: _TableHeader('Name')),
                DataColumn(label: _TableHeader('Business Title')),
                DataColumn(label: _TableHeader('Person Number')),
                DataColumn(label: _TableHeader('Assignment Number')),
                DataColumn(label: _TableHeader('Assignment Status')),
                DataColumn(label: _TableHeader('Worker Type')),
                DataColumn(label: _TableHeader('Work Email')),
              ],
              rows: rows.isEmpty
                  ? const [
                      DataRow(
                        cells: [
                          DataCell(Text('No people match these filters.')),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                        ],
                      ),
                    ]
                  : rows.map(_buildDataRow).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      initialValue: _sortBy,
      onSelected: (value) => setState(() => _sortBy = value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Relevance', child: Text('Relevance')),
        PopupMenuItem(value: 'Name', child: Text('Name')),
        PopupMenuItem(value: 'Person Number', child: Text('Person Number')),
      ],
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort By ',
              style: TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(_sortBy, style: const TextStyle(color: _text, fontSize: 12)),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(Map<String, String> person) {
    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PersonInformationScreen(),
              ),
            ),
            child: Text(
              person['name'] ?? '',
              style: const TextStyle(
                color: Color(0xFF007398),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(_TableText(person['businessTitle'] ?? '')),
        DataCell(_TableText(person['personNumber'] ?? '')),
        DataCell(_TableText(person['assignmentNumber'] ?? '')),
        DataCell(_StatusPill(person['assignmentStatus'] ?? '')),
        DataCell(_TableText(person['workerType'] ?? '')),
        DataCell(_TableText(person['workEmail'] ?? '')),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String label;
  const _TableHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _TableText extends StatelessWidget {
  final String value;
  const _TableText(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(color: Color(0xFF1F2937), fontSize: 12),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String value;
  const _StatusPill(this.value);

  @override
  Widget build(BuildContext context) {
    final isActive = value.startsWith('Active');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
