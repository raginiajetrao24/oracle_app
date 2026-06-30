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
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _personNumberFilterController =
      TextEditingController();
  final TextEditingController _assignmentNumberFilterController =
      TextEditingController();
  final TextEditingController _workEmailFilterController =
      TextEditingController();
  final TextEditingController _workPhoneFilterController =
      TextEditingController();
  final TextEditingController _workerNumberFilterController =
      TextEditingController();
  final TextEditingController _userNameFilterController =
      TextEditingController();
  String _reportsFilter = 'Direct reports';
  String _assignmentStatus = 'All';
  String _managerType = 'All';
  String _workerType = 'Employee';
  bool _primaryAssignmentOnly = false;
  String _jobCode = 'All';
  String _jobName = 'All';
  String _sortBy = 'Relevance';

  final List<Map<String, String>> _people = const [
    {
      'name': 'Khalid Almajid',
      'businessTitle': 'Minister',
      'personNumber': '11000',
      'assignmentNumber': 'E11000',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'managerType': 'Line Manager',
      'jobCode': 'MIN',
      'workPhone': '+974 4400 1100',
      'workerNumber': 'W11000',
      'userName': 'khalid.almajid',
      'workEmail': 'Khalid.Almajid@mannai.com.qa',
    },
    {
      'name': 'Anthony Wesley',
      'businessTitle': 'Call Center Agent',
      'personNumber': '657',
      'assignmentNumber': 'E657',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'managerType': 'Line Manager',
      'jobCode': 'CCA',
      'workPhone': '+974 4400 0657',
      'workerNumber': 'W657',
      'userName': 'anthony.wesley',
      'workEmail': 'anthony.wesley@mannai.com.qa',
    },
    {
      'name': 'Ahmed Shahin',
      'businessTitle': 'Analyst',
      'personNumber': '2915',
      'assignmentNumber': 'E2915',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'managerType': 'Line Manager',
      'jobCode': 'ANL',
      'workPhone': '+974 4400 2915',
      'workerNumber': 'W2915',
      'userName': 'ahmed.shahin',
      'workEmail': 'ahmed.shahin@mannai.com.qa',
    },
    {
      'name': 'Hope Hightower',
      'businessTitle': 'Human Resources Generalist',
      'personNumber': '4149',
      'assignmentNumber': 'E4149',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'managerType': 'Line Manager',
      'jobCode': 'HRG',
      'workPhone': '+974 4400 4149',
      'workerNumber': 'W4149',
      'userName': 'hope.hightower',
      'workEmail': 'hope.hightower@mannai.com.qa',
    },
    {
      'name': 'Martin Lletget',
      'businessTitle': 'Human Resources Generalist',
      'personNumber': '4308',
      'assignmentNumber': 'E4308',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'managerType': 'Line Manager',
      'jobCode': 'HRG',
      'workPhone': '+974 4400 4308',
      'workerNumber': 'W4308',
      'userName': 'martin.lletget',
      'workEmail': 'martin.lletget@mannai.com.qa',
    },
    {
      'name': 'Sue Eden',
      'businessTitle': 'Product Design Engineer',
      'personNumber': '4337',
      'assignmentNumber': 'E4337',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'managerType': 'Line Manager',
      'jobCode': 'PDE',
      'workPhone': '+974 4400 4337',
      'workerNumber': 'W4337',
      'userName': 'sue.eden',
      'workEmail': 'sue.eden@mannai.com.qa',
    },
    {
      'name': 'Junaid Mohamed',
      'businessTitle': 'UG HR Consultant',
      'personNumber': '7631',
      'assignmentNumber': 'E7631',
      'assignmentStatus': 'Inactive',
      'workerType': 'Contingent Worker',
      'managerType': 'Line Manager',
      'jobCode': 'HRC',
      'workPhone': '+974 4400 7631',
      'workerNumber': 'W7631',
      'userName': 'junaid.mohamed',
      'workEmail': 'junaid.mohamed@mannai.com.qa',
    },
    {
      'name': 'Aisha Alma',
      'businessTitle': 'UG Manager',
      'personNumber': '7667',
      'assignmentNumber': '001234',
      'assignmentStatus': 'Active - Payroll Eligible',
      'workerType': 'Employee',
      'managerType': 'Line Manager',
      'jobCode': 'MGR',
      'workPhone': '+974 4400 7667',
      'workerNumber': 'W7667',
      'userName': 'aisha.alma',
      'workEmail': 'aisha.alma@mannai.com.qa',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _nameFilterController.dispose();
    _personNumberFilterController.dispose();
    _assignmentNumberFilterController.dispose();
    _workEmailFilterController.dispose();
    _workPhoneFilterController.dispose();
    _workerNumberFilterController.dispose();
    _userNameFilterController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredPeople {
    final query = _searchController.text.trim().toLowerCase();
    final nameFilter = _nameFilterController.text.trim().toLowerCase();
    final personNumberFilter = _personNumberFilterController.text
        .trim()
        .toLowerCase();
    final assignmentNumberFilter = _assignmentNumberFilterController.text
        .trim()
        .toLowerCase();
    final workEmailFilter = _workEmailFilterController.text
        .trim()
        .toLowerCase();
    final workPhoneFilter = _workPhoneFilterController.text
        .trim()
        .toLowerCase();
    final workerNumberFilter = _workerNumberFilterController.text
        .trim()
        .toLowerCase();
    final userNameFilter = _userNameFilterController.text.trim().toLowerCase();

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
      final matchesManager =
          _managerType == 'All' || person['managerType'] == _managerType;
      final matchesWorker =
          _workerType == 'All' || person['workerType'] == _workerType;
      final matchesJobCode = _jobCode == 'All' || person['jobCode'] == _jobCode;
      final matchesJobName =
          _jobName == 'All' || person['businessTitle'] == _jobName;
      final matchesAttributes =
          _containsField(person['name'], nameFilter) &&
          _containsField(person['personNumber'], personNumberFilter) &&
          _containsField(person['assignmentNumber'], assignmentNumberFilter) &&
          _containsField(person['workEmail'], workEmailFilter) &&
          _containsField(person['workPhone'], workPhoneFilter) &&
          _containsField(person['workerNumber'], workerNumberFilter) &&
          _containsField(person['userName'], userNameFilter);
      return matchesQuery &&
          matchesStatus &&
          matchesManager &&
          matchesWorker &&
          matchesJobCode &&
          matchesJobName &&
          matchesAttributes;
    }).toList();

    if (_sortBy == 'Name') {
      rows.sort((a, b) => a['name']!.compareTo(b['name']!));
    } else if (_sortBy == 'Person Number') {
      rows.sort((a, b) => a['personNumber']!.compareTo(b['personNumber']!));
    }
    return rows;
  }

  bool _containsField(String? value, String filter) {
    return filter.isEmpty || (value ?? '').toLowerCase().contains(filter);
  }

  int get _activeFilterCount {
    var count = 0;
    if (_reportsFilter != 'Direct reports') count++;
    if (_assignmentStatus != 'All') count++;
    if (_managerType != 'All') count++;
    if (_workerType != 'Employee') count++;
    if (_primaryAssignmentOnly) count++;
    if (_jobCode != 'All') count++;
    if (_jobName != 'All') count++;
    if (_nameFilterController.text.trim().isNotEmpty) count++;
    if (_personNumberFilterController.text.trim().isNotEmpty) count++;
    if (_assignmentNumberFilterController.text.trim().isNotEmpty) count++;
    if (_workEmailFilterController.text.trim().isNotEmpty) count++;
    if (_workPhoneFilterController.text.trim().isNotEmpty) count++;
    if (_workerNumberFilterController.text.trim().isNotEmpty) count++;
    if (_userNameFilterController.text.trim().isNotEmpty) count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _reportsFilter = 'Direct reports';
      _assignmentStatus = 'All';
      _managerType = 'All';
      _workerType = 'Employee';
      _primaryAssignmentOnly = false;
      _jobCode = 'All';
      _jobName = 'All';
      _nameFilterController.clear();
      _personNumberFilterController.clear();
      _assignmentNumberFilterController.clear();
      _workEmailFilterController.clear();
      _workPhoneFilterController.clear();
      _workerNumberFilterController.clear();
      _userNameFilterController.clear();
      _sortBy = 'Relevance';
    });
  }

  Future<void> _showFilterSheet() async {
    var reports = _reportsFilter;
    var status = _assignmentStatus;
    var manager = _managerType;
    var worker = _workerType;
    var primaryOnly = _primaryAssignmentOnly;
    var jobCode = _jobCode;
    var jobName = _jobName;
    var reportsExpanded = true;
    var statusExpanded = true;
    var managerExpanded = true;
    var workerExpanded = true;
    var jobExpanded = true;
    var personExpanded = true;

    final nameController = TextEditingController(
      text: _nameFilterController.text,
    );
    final personNumberController = TextEditingController(
      text: _personNumberFilterController.text,
    );
    final assignmentNumberController = TextEditingController(
      text: _assignmentNumberFilterController.text,
    );
    final workEmailController = TextEditingController(
      text: _workEmailFilterController.text,
    );
    final workPhoneController = TextEditingController(
      text: _workPhoneFilterController.text,
    );
    final workerNumberController = TextEditingController(
      text: _workerNumberFilterController.text,
    );
    final userNameController = TextEditingController(
      text: _userNameFilterController.text,
    );
    final jobCodes = {
      'All',
      ..._people.map((person) => person['jobCode']!),
    }.toList();
    final jobNames = {
      'All',
      ..._people.map((person) => person['businessTitle']!),
    }.toList();

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setSheetState) {
              return FractionallySizedBox(
                heightFactor: 0.92,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Filters',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: _text,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Close filters',
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close_fullscreen_rounded,
                                color: _text,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFilterSection(
                                title: 'Reports',
                                expanded: reportsExpanded,
                                onToggle: () => setSheetState(
                                  () => reportsExpanded = !reportsExpanded,
                                ),
                                children: [
                                  _buildRadioOption(
                                    label: 'Direct reports',
                                    value: 'Direct reports',
                                    groupValue: reports,
                                    onChanged: (value) =>
                                        setSheetState(() => reports = value),
                                  ),
                                  _buildRadioOption(
                                    label: 'All reports',
                                    value: 'All reports',
                                    groupValue: reports,
                                    onChanged: (value) =>
                                        setSheetState(() => reports = value),
                                  ),
                                  _buildRadioOption(
                                    label: 'Others and delegated',
                                    value: 'Others and delegated',
                                    groupValue: reports,
                                    onChanged: (value) =>
                                        setSheetState(() => reports = value),
                                  ),
                                ],
                              ),
                              _buildFilterSection(
                                title: 'Assignment Status',
                                expanded: statusExpanded,
                                onToggle: () => setSheetState(
                                  () => statusExpanded = !statusExpanded,
                                ),
                                children: [
                                  _buildCheckboxOption(
                                    label: 'Active - Payroll Eligible (13)',
                                    value:
                                        status == 'Active - Payroll Eligible',
                                    onChanged: (value) => setSheetState(() {
                                      status = value
                                          ? 'Active - Payroll Eligible'
                                          : 'All';
                                    }),
                                  ),
                                ],
                              ),
                              _buildFilterSection(
                                title: 'Manager Type',
                                expanded: managerExpanded,
                                onToggle: () => setSheetState(
                                  () => managerExpanded = !managerExpanded,
                                ),
                                children: [
                                  _buildCheckboxOption(
                                    label: 'Line Manager (13)',
                                    value: manager == 'Line Manager',
                                    onChanged: (value) => setSheetState(() {
                                      manager = value ? 'Line Manager' : 'All';
                                    }),
                                  ),
                                ],
                              ),
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                activeThumbColor: _blue,
                                value: primaryOnly,
                                title: const Text(
                                  'Show primary assignment only',
                                  style: TextStyle(
                                    color: _text,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onChanged: (value) =>
                                    setSheetState(() => primaryOnly = value),
                              ),
                              const SizedBox(height: 10),
                              _buildFilterSection(
                                title: 'Worker Type',
                                expanded: workerExpanded,
                                onToggle: () => setSheetState(
                                  () => workerExpanded = !workerExpanded,
                                ),
                                children: [
                                  _buildCheckboxOption(
                                    label: 'Employee (13)',
                                    value: worker == 'Employee',
                                    onChanged: (value) => setSheetState(() {
                                      worker = value ? 'Employee' : 'All';
                                    }),
                                  ),
                                ],
                              ),
                              _buildFilterSection(
                                title: 'Job',
                                expanded: jobExpanded,
                                onToggle: () => setSheetState(
                                  () => jobExpanded = !jobExpanded,
                                ),
                                children: [
                                  _buildSheetSelect(
                                    label: 'Job Code',
                                    value: jobCode,
                                    values: jobCodes,
                                    onChanged: (value) =>
                                        setSheetState(() => jobCode = value),
                                  ),
                                  const SizedBox(height: 14),
                                  _buildSheetSelect(
                                    label: 'Job Name',
                                    value: jobName,
                                    values: jobNames,
                                    onChanged: (value) =>
                                        setSheetState(() => jobName = value),
                                  ),
                                ],
                              ),
                              _buildFilterSection(
                                title: 'Person Attributes',
                                expanded: personExpanded,
                                onToggle: () => setSheetState(
                                  () => personExpanded = !personExpanded,
                                ),
                                children: [
                                  _buildSheetTextField(
                                    label: 'Name',
                                    controller: nameController,
                                  ),
                                  _buildSheetTextField(
                                    label: 'Person Number',
                                    controller: personNumberController,
                                  ),
                                  _buildSheetTextField(
                                    label: 'Assignment Number',
                                    controller: assignmentNumberController,
                                  ),
                                  _buildSheetTextField(
                                    label: 'Work Email',
                                    controller: workEmailController,
                                  ),
                                  _buildSheetTextField(
                                    label: 'Work Phone',
                                    controller: workPhoneController,
                                  ),
                                  _buildSheetTextField(
                                    label: 'Worker Number',
                                    controller: workerNumberController,
                                  ),
                                  _buildSheetTextField(
                                    label: 'User Name',
                                    controller: userNameController,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _text,
                                side: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 13,
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _reportsFilter = reports;
                                  _assignmentStatus = status;
                                  _managerType = manager;
                                  _workerType = worker;
                                  _primaryAssignmentOnly = primaryOnly;
                                  _jobCode = jobCode;
                                  _jobName = jobName;
                                  _nameFilterController.text =
                                      nameController.text;
                                  _personNumberFilterController.text =
                                      personNumberController.text;
                                  _assignmentNumberFilterController.text =
                                      assignmentNumberController.text;
                                  _workEmailFilterController.text =
                                      workEmailController.text;
                                  _workPhoneFilterController.text =
                                      workPhoneController.text;
                                  _workerNumberFilterController.text =
                                      workerNumberController.text;
                                  _userNameFilterController.text =
                                      userNameController.text;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF312C2A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                              ),
                              child: const Text('See Results'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      nameController.dispose();
      personNumberController.dispose();
      assignmentNumberController.dispose();
      workEmailController.dispose();
      workPhoneController.dispose();
      workerNumberController.dispose();
      userNameController.dispose();
    }
  }

  Widget _buildFilterSection({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: _text,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[const SizedBox(height: 8), ...children],
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(6),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? _blue : _text,
              size: 22,
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _text, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: _blue,
            visualDensity: VisualDensity.compact,
            onChanged: (selected) => onChanged(selected ?? false),
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _text, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetSelect({
    required String label,
    required String value,
    required List<String> values,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      items: values.map((item) {
        final display = item == 'All' ? label : item;
        return DropdownMenuItem(value: item, child: Text(display));
      }).toList(),
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
      decoration: _sheetInputDecoration(label),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _text),
    );
  }

  Widget _buildSheetTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _text, fontSize: 15),
        decoration: _sheetInputDecoration(label),
      ),
    );
  }

  InputDecoration _sheetInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF9CA3AF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF9CA3AF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _blue, width: 1.4),
      ),
      labelStyle: const TextStyle(
        color: _muted,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filteredPeople;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeaderWidget(title: 'Personal Details', showBack: true),
            Padding(
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
          ],
        ),
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
