import 'package:flutter/material.dart';

class DocumentRecordsScreen extends StatefulWidget {
  /// Optional label shown as the header subtitle (defaults to 'Document Records').
  final String sectionTitle;

  const DocumentRecordsScreen({
    super.key,
    this.sectionTitle = 'Document Records',
  });

  @override
  State<DocumentRecordsScreen> createState() => _DocumentRecordsScreenState();
}

class _DocumentRecordsScreenState extends State<DocumentRecordsScreen> {
  static const _text = Color(0xFF1F2937);

  final TextEditingController _searchController = TextEditingController();
  String _reports = 'Direct reports';
  bool _activePayrollEligible = false;
  bool _activeNoPayroll = false;
  bool _inactivePayrollEligible = false;
  bool _suspendedNoPayroll = false;
  bool _inactiveUnpaidLOA = false;
  bool _suspendedPayrollEligible = false;
  bool _lineManager = false;
  bool _showPrimaryAssignment = false;
  bool _workerTypeEmployee = false;
  bool _workerTypeContingent = false;
  bool _workerTypeNonworker = false;
  String _jobCode = '';
  String _jobName = '';
  String _attrName = '';
  String _attrPersonNumber = '';
  String _attrAssignmentNumber = '';
  String _attrWorkEmail = '';
  String _attrWorkPhone = '';
  String _attrWorkerNumber = '';
  String _attrUserName = '';

  String _sortBy = 'Relevance';
  bool _compactView = false;

  final List<DocumentPerson> _people = const [
    DocumentPerson(
      'Carmen Rodriguez',
      'E21356',
      '21356',
      'E21356',
      'Carmen.Rodriguez_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Jorge Vega',
      'E21454',
      '21454',
      'E21454',
      'Jorge.Vega_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Maria Larrondo',
      'E21458',
      '21458',
      'E21458',
      'Maria.Larrondo_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Carolina Garate',
      'E21700',
      '21700',
      'E21700',
      'Carolina.Garate_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Rocio Aparicio',
      'E21424',
      '21424',
      'E21424',
      'Rocio.Aparicio_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Luis Gomez',
      'E21321',
      '21321',
      'E21321',
      'Luis.Gomez_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Pedro Aberasturi',
      'E21450',
      '21450',
      'E21450',
      'Pedro.Aberasturi_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Victor Marin',
      'E21437',
      '21437',
      'E21437',
      'Victor.Marin_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Manuel Torres',
      'E21361',
      '21361',
      'E21361',
      'Manuel.Torres_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Marta Serrano',
      'E21474',
      '21474',
      'E21474',
      'Marta.Serrano_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Felix Villa',
      'E21701',
      '21701',
      'E21701',
      'Felix.Villa_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Juan Prieto',
      'E21371',
      '21371',
      'E21371',
      'Juan.Prieto_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Marcos Bueno',
      'E21470',
      '21470',
      'E21470',
      'Marcos.Bueno_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Pilar Anzola',
      'E21366',
      '21366',
      'E21366',
      'Pilar.Anzola_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Jose Diez',
      'E21420',
      '21420',
      'E21420',
      'Jose.Diez_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Lucia Marin',
      'E21330',
      '21330',
      'E21330',
      'Lucia.Marin_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Leire Montes',
      'E21386',
      '21386',
      'E21386',
      'Leire.Montes_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Borja Pascual',
      'E21378',
      '21378',
      'E21378',
      'Borja.Pascual_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Francisco Rojo',
      'E21345',
      '21345',
      'E21345',
      'Francisco.Rojo_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Ramon Benitez',
      'E21409',
      '21409',
      'E21409',
      'Ramon.Benitez_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Ruben Molina',
      'E21396',
      '21396',
      'E21396',
      'Ruben.Molina_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Naroa Cortes',
      'E21391',
      '21391',
      'E21391',
      'Naroa.Cortes_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Janni Helt',
      'Human Resources Administrator',
      '23329',
      'E23329',
      'janni.helt_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Ib Pedersen',
      'Analyst',
      '23338',
      'E23338',
      'ib.pedersen_esll-dev2@oracledemos.com',
    ),
    DocumentPerson(
      'Anni Mouritsen',
      'Human Resources Business Partner',
      '23343',
      'E23343',
      'anni.mouritsen_esll-dev2@oracledemos.com',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DocumentPerson> get _filteredPeople {
    final query = _searchController.text.trim().toLowerCase();
    final rows = _people.where((person) {
      final matchesQuery =
          query.isEmpty ||
          [
            person.name,
            person.businessTitle,
            person.personNumber,
            person.assignmentNumber,
            person.email,
          ].any((value) => value.toLowerCase().contains(query));

      // Filter by Assignment Status
      final hasSelectedStatus =
          _activePayrollEligible ||
          _activeNoPayroll ||
          _inactivePayrollEligible ||
          _suspendedNoPayroll ||
          _inactiveUnpaidLOA ||
          _suspendedPayrollEligible;
      if (hasSelectedStatus) {
        final status = person.assignmentStatus;
        final matchesActivePayroll =
            _activePayrollEligible && status == 'Active - Payroll Eligible';
        final matchesActiveNoPayroll =
            _activeNoPayroll && status == 'Active - No Payroll';
        final matchesInactivePayroll =
            _inactivePayrollEligible && status == 'Inactive - Payroll Eligible';
        final matchesSuspendedNoPayroll =
            _suspendedNoPayroll && status == 'Suspended - No Payroll';
        final matchesInactiveUnpaid =
            _inactiveUnpaidLOA && status == 'Inactive-Unpaid LOA';
        final matchesSuspendedPayroll =
            _suspendedPayrollEligible &&
            status == 'Suspended - Payroll Eligible';
        if (!matchesActivePayroll &&
            !matchesActiveNoPayroll &&
            !matchesInactivePayroll &&
            !matchesSuspendedNoPayroll &&
            !matchesInactiveUnpaid &&
            !matchesSuspendedPayroll) {
          return false;
        }
      }

      // Filter by Worker Type
      final hasSelectedWorkerType =
          _workerTypeEmployee || _workerTypeContingent || _workerTypeNonworker;
      if (hasSelectedWorkerType) {
        final wt = person.workerType;
        final matchesEmployee = _workerTypeEmployee && wt == 'Employee';
        final matchesContingent =
            _workerTypeContingent && wt == 'Contingent Worker';
        final matchesNonworker = _workerTypeNonworker && wt == 'Nonworker';
        if (!matchesEmployee && !matchesContingent && !matchesNonworker) {
          return false;
        }
      }

      return matchesQuery;
    }).toList();

    if (_sortBy == 'Name, A to Z') {
      rows.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'Name, Z to A') {
      rows.sort((a, b) => b.name.compareTo(a.name));
    }

    return rows;
  }

  int get _activeFilterCount {
    var count = 0;
    if (_reports != 'Direct reports') count++;
    if (_activePayrollEligible) count++;
    if (_activeNoPayroll) count++;
    if (_inactivePayrollEligible) count++;
    if (_suspendedNoPayroll) count++;
    if (_inactiveUnpaidLOA) count++;
    if (_suspendedPayrollEligible) count++;
    if (_lineManager) count++;
    if (_showPrimaryAssignment) count++;
    if (_workerTypeEmployee) count++;
    if (_workerTypeContingent) count++;
    if (_workerTypeNonworker) count++;
    if (_jobCode.isNotEmpty) count++;
    if (_jobName.isNotEmpty) count++;
    if (_attrName.isNotEmpty) count++;
    if (_attrPersonNumber.isNotEmpty) count++;
    if (_attrAssignmentNumber.isNotEmpty) count++;
    if (_attrWorkEmail.isNotEmpty) count++;
    if (_attrWorkPhone.isNotEmpty) count++;
    if (_attrWorkerNumber.isNotEmpty) count++;
    if (_attrUserName.isNotEmpty) count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      _reports = 'Direct reports';
      _activePayrollEligible = false;
      _activeNoPayroll = false;
      _inactivePayrollEligible = false;
      _suspendedNoPayroll = false;
      _inactiveUnpaidLOA = false;
      _suspendedPayrollEligible = false;
      _lineManager = false;
      _showPrimaryAssignment = false;
      _workerTypeEmployee = false;
      _workerTypeContingent = false;
      _workerTypeNonworker = false;
      _jobCode = '';
      _jobName = '';
      _attrName = '';
      _attrPersonNumber = '';
      _attrAssignmentNumber = '';
      _attrWorkEmail = '';
      _attrWorkPhone = '';
      _attrWorkerNumber = '';
      _attrUserName = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filteredPeople;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          _WebLikeHeader(
            title: widget.sectionTitle,
            subtitle: 'Document Records',
            onBack: () => Navigator.maybePop(context),
            child: Column(
              children: [
                _SearchBox(
                  controller: _searchController,
                  hint:
                      'Search by Name, Business Title, Work Email, or Person Number',
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                _buildFilterBar(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: _buildResultsCard(rows),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // Reports Popup
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => _reports = val),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Direct reports',
                child: Row(
                  children: [
                    Icon(
                      _reports == 'Direct reports'
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      size: 20,
                      color: _reports == 'Direct reports'
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Direct reports'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'All reports',
                child: Row(
                  children: [
                    Icon(
                      _reports == 'All reports'
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      size: 20,
                      color: _reports == 'All reports'
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('All reports'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Others and delegated',
                child: Row(
                  children: [
                    Icon(
                      _reports == 'Others and delegated'
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      size: 20,
                      color: _reports == 'Others and delegated'
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Others and delegated'),
                  ],
                ),
              ),
            ],
            child: _FilterPill(
              label: 'Reports',
              value: _reports == 'Direct reports' ? '' : _reports,
              selected: _reports != 'Direct reports',
            ),
          ),

          // Assignment Status Popup
          PopupMenuButton<String>(
            onSelected: (val) {
              setState(() {
                if (val == 'Active - Payroll Eligible') {
                  _activePayrollEligible = !_activePayrollEligible;
                }
                if (val == 'Active - No Payroll') {
                  _activeNoPayroll = !_activeNoPayroll;
                }
                if (val == 'Inactive - Payroll Eligible') {
                  _inactivePayrollEligible = !_inactivePayrollEligible;
                }
                if (val == 'Suspended - No Payroll') {
                  _suspendedNoPayroll = !_suspendedNoPayroll;
                }
                if (val == 'Inactive-Unpaid LOA') {
                  _inactiveUnpaidLOA = !_inactiveUnpaidLOA;
                }
                if (val == 'Suspended - Payroll Eligible') {
                  _suspendedPayrollEligible = !_suspendedPayrollEligible;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Active - Payroll Eligible',
                child: Row(
                  children: [
                    Icon(
                      _activePayrollEligible
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _activePayrollEligible
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Active - Payroll Eligible (5476)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Active - No Payroll',
                child: Row(
                  children: [
                    Icon(
                      _activeNoPayroll
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _activeNoPayroll
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Active - No Payroll (14)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Inactive - Payroll Eligible',
                child: Row(
                  children: [
                    Icon(
                      _inactivePayrollEligible
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _inactivePayrollEligible
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Inactive - Payroll Eligible (4)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Suspended - No Payroll',
                child: Row(
                  children: [
                    Icon(
                      _suspendedNoPayroll
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _suspendedNoPayroll
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Suspended - No Payroll (4)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Inactive-Unpaid LOA',
                child: Row(
                  children: [
                    Icon(
                      _inactiveUnpaidLOA
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _inactiveUnpaidLOA
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Inactive-Unpaid LOA (3)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Suspended - Payroll Eligible',
                child: Row(
                  children: [
                    Icon(
                      _suspendedPayrollEligible
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _suspendedPayrollEligible
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Suspended - Payroll Eligible (1)'),
                  ],
                ),
              ),
            ],
            child: _FilterPill(
              label: 'Assignment Status',
              value: _activePayrollEligible ? 'Active - Payroll Eligible' : '',
              selected:
                  _activePayrollEligible ||
                  _activeNoPayroll ||
                  _inactivePayrollEligible ||
                  _suspendedNoPayroll ||
                  _inactiveUnpaidLOA ||
                  _suspendedPayrollEligible,
            ),
          ),

          // Manager Type Popup
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'Line Manager') {
                setState(() => _lineManager = !_lineManager);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Line Manager',
                child: Row(
                  children: [
                    Icon(
                      _lineManager
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _lineManager
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Line Manager (17)'),
                  ],
                ),
              ),
            ],
            child: _FilterPill(
              label: 'Manager Type',
              value: _lineManager ? 'Line Manager' : '',
              selected: _lineManager,
            ),
          ),

          // Show Primary Assignment directly clickable
          GestureDetector(
            onTap: () => setState(
              () => _showPrimaryAssignment = !_showPrimaryAssignment,
            ),
            child: _FilterPill(
              label: 'Show primary assignment only',
              value: _showPrimaryAssignment ? 'Yes' : '',
              selected: _showPrimaryAssignment,
            ),
          ),

          // Worker Type Popup
          PopupMenuButton<String>(
            onSelected: (val) {
              setState(() {
                if (val == 'Employee') {
                  _workerTypeEmployee = !_workerTypeEmployee;
                }
                if (val == 'Contingent Worker') {
                  _workerTypeContingent = !_workerTypeContingent;
                }
                if (val == 'Nonworker') {
                  _workerTypeNonworker = !_workerTypeNonworker;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Employee',
                child: Row(
                  children: [
                    Icon(
                      _workerTypeEmployee
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _workerTypeEmployee
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Employee (17)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Contingent Worker',
                child: Row(
                  children: [
                    Icon(
                      _workerTypeContingent
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _workerTypeContingent
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Contingent Worker (0)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Nonworker',
                child: Row(
                  children: [
                    Icon(
                      _workerTypeNonworker
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: _workerTypeNonworker
                          ? const Color(0xFF1F4E8C)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text('Nonworker (0)'),
                  ],
                ),
              ),
            ],
            child: _FilterPill(
              label: 'Worker Type',
              value: _workerTypeEmployee ? 'Employee' : '',
              selected:
                  _workerTypeEmployee ||
                  _workerTypeContingent ||
                  _workerTypeNonworker,
            ),
          ),

          _PlainFilterButton(label: 'Filters', onTap: _showListFilters),
          TextButton(
            onPressed: _activeFilterCount == 0 ? null : _clearFilters,
            child: Text('Clear ($_activeFilterCount)'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard(List<DocumentPerson> rows) {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${rows.length} people',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                ),
                _SortButton(
                  value: _sortBy,
                  values: const ['Relevance', 'Name, A to Z', 'Name, Z to A'],
                  onChanged: (value) => setState(() => _sortBy = value),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  tooltip: 'Toggle view',
                  onPressed: () => setState(() => _compactView = !_compactView),
                  icon: Icon(
                    _compactView
                        ? Icons.view_agenda_outlined
                        : Icons.view_column_outlined,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No matching people found.'),
            )
          else if (!_compactView)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                columnSpacing: 24,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  fontSize: 13,
                ),
                dataTextStyle: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 13,
                ),
                border: const TableBorder(
                  horizontalInside: BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Business Title')),
                  DataColumn(label: Text('Person Number')),
                  DataColumn(label: Text('Assignment Number')),
                  DataColumn(label: Text('Assignment Status')),
                  DataColumn(label: Text('Worker Type')),
                  DataColumn(label: Text('Work Email')),
                ],
                rows: rows.map((person) {
                  return DataRow(
                    cells: [
                      DataCell(
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PersonDocumentRecordsScreen(person: person),
                            ),
                          ),
                          child: Text(
                            person.name,
                            style: const TextStyle(
                              color: Color(0xFF00759B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(person.businessTitle)),
                      DataCell(Text(person.personNumber)),
                      DataCell(Text(person.assignmentNumber)),
                      DataCell(Text(person.assignmentStatus)),
                      DataCell(Text(person.workerType)),
                      DataCell(Text(person.email)),
                    ],
                  );
                }).toList(),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final person = rows[index];
                return _DocumentPersonRow(
                  person: person,
                  compact: _compactView,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PersonDocumentRecordsScreen(person: person),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _showListFilters() async {
    var reports = _reports;
    var activePayrollEligible = _activePayrollEligible;
    var activeNoPayroll = _activeNoPayroll;
    var inactivePayrollEligible = _inactivePayrollEligible;
    var suspendedNoPayroll = _suspendedNoPayroll;
    var inactiveUnpaidLOA = _inactiveUnpaidLOA;
    var suspendedPayrollEligible = _suspendedPayrollEligible;
    var lineManager = _lineManager;
    var showPrimaryAssignment = _showPrimaryAssignment;
    var workerTypeEmployee = _workerTypeEmployee;
    var workerTypeContingent = _workerTypeContingent;
    var workerTypeNonworker = _workerTypeNonworker;
    var jobCode = _jobCode;
    var jobName = _jobName;
    var attrName = _attrName;
    var attrPersonNumber = _attrPersonNumber;
    var attrAssignmentNumber = _attrAssignmentNumber;
    var attrWorkEmail = _attrWorkEmail;
    var attrWorkPhone = _attrWorkPhone;
    var attrWorkerNumber = _attrWorkerNumber;
    var attrUserName = _attrUserName;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return _FilterSheetFrame(
            title: 'Filters',
            onCancel: () => Navigator.pop(context, false),
            onSeeResults: () => Navigator.pop(context, true),
            child: Column(
              children: [
                _FilterExpansion(
                  title: 'Reports',
                  child: RadioGroup<String>(
                    groupValue: reports,
                    onChanged: (val) => setSheetState(() => reports = val!),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text(
                            'Direct reports',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'Direct reports',
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                        RadioListTile<String>(
                          title: const Text(
                            'All reports',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'All reports',
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                        RadioListTile<String>(
                          title: const Text(
                            'Others and delegated',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'Others and delegated',
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ),
                _FilterExpansion(
                  title: 'Assignment Status',
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text(
                          'Active - Payroll Eligible (5476)',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: activePayrollEligible,
                        onChanged: (val) => setSheetState(
                          () => activePayrollEligible = val ?? false,
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity.compact,
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'Active - No Payroll (14)',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: activeNoPayroll,
                        onChanged: (val) =>
                            setSheetState(() => activeNoPayroll = val ?? false),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                _FilterExpansion(
                  title: 'Manager Type',
                  child: CheckboxListTile(
                    title: const Text(
                      'Line Manager (13)',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: lineManager,
                    onChanged: (val) =>
                        setSheetState(() => lineManager = val ?? false),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Show primary assignment only',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  value: showPrimaryAssignment,
                  onChanged: (value) =>
                      setSheetState(() => showPrimaryAssignment = value),
                ),
                const SizedBox(height: 14),
                _FilterExpansion(
                  title: 'Worker Type',
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text(
                          'Employee (13)',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: workerTypeEmployee,
                        onChanged: (val) => setSheetState(
                          () => workerTypeEmployee = val ?? false,
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity.compact,
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'Contingent Worker (0)',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: workerTypeContingent,
                        onChanged: (val) => setSheetState(
                          () => workerTypeContingent = val ?? false,
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                _FilterExpansion(
                  title: 'Job',
                  child: Column(
                    children: [
                      _SelectField(
                        value: jobCode.isEmpty ? 'Job Code' : jobCode,
                        values: const ['Job Code', 'Code 1', 'Code 2'],
                        onChanged: (val) => setSheetState(
                          () => jobCode = val == 'Job Code' ? '' : val,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SelectField(
                        value: jobName.isEmpty ? 'Job Name' : jobName,
                        values: const ['Job Name', 'Name 1', 'Name 2'],
                        onChanged: (val) => setSheetState(
                          () => jobName = val == 'Job Name' ? '' : val,
                        ),
                      ),
                    ],
                  ),
                ),
                _FilterExpansion(
                  title: 'Person Attributes',
                  child: Column(
                    children: [
                      _InlineTextField(
                        initialValue: attrName,
                        label: 'Name',
                        onChanged: (val) => attrName = val,
                      ),
                      const SizedBox(height: 10),
                      _InlineTextField(
                        initialValue: attrPersonNumber,
                        label: 'Person Number',
                        onChanged: (val) => attrPersonNumber = val,
                      ),
                      const SizedBox(height: 10),
                      _InlineTextField(
                        initialValue: attrAssignmentNumber,
                        label: 'Assignment Number',
                        onChanged: (val) => attrAssignmentNumber = val,
                      ),
                      const SizedBox(height: 10),
                      _InlineTextField(
                        initialValue: attrWorkEmail,
                        label: 'Work Email',
                        onChanged: (val) => attrWorkEmail = val,
                      ),
                      const SizedBox(height: 10),
                      _InlineTextField(
                        initialValue: attrWorkPhone,
                        label: 'Work Phone',
                        onChanged: (val) => attrWorkPhone = val,
                      ),
                      const SizedBox(height: 10),
                      _InlineTextField(
                        initialValue: attrWorkerNumber,
                        label: 'Worker Number',
                        onChanged: (val) => attrWorkerNumber = val,
                      ),
                      const SizedBox(height: 10),
                      _InlineTextField(
                        initialValue: attrUserName,
                        label: 'User Name',
                        onChanged: (val) => attrUserName = val,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (result == true) {
      setState(() {
        _reports = reports;
        _activePayrollEligible = activePayrollEligible;
        _activeNoPayroll = activeNoPayroll;
        _inactivePayrollEligible = inactivePayrollEligible;
        _suspendedNoPayroll = suspendedNoPayroll;
        _inactiveUnpaidLOA = inactiveUnpaidLOA;
        _suspendedPayrollEligible = suspendedPayrollEligible;
        _lineManager = lineManager;
        _showPrimaryAssignment = showPrimaryAssignment;
        _workerTypeEmployee = workerTypeEmployee;
        _workerTypeContingent = workerTypeContingent;
        _workerTypeNonworker = workerTypeNonworker;
        _jobCode = jobCode;
        _jobName = jobName;
        _attrName = attrName;
        _attrPersonNumber = attrPersonNumber;
        _attrAssignmentNumber = attrAssignmentNumber;
        _attrWorkEmail = attrWorkEmail;
        _attrWorkPhone = attrWorkPhone;
        _attrWorkerNumber = attrWorkerNumber;
        _attrUserName = attrUserName;
      });
    }
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE5E7EB)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class PersonDocumentRecordsScreen extends StatefulWidget {
  final DocumentPerson person;

  const PersonDocumentRecordsScreen({super.key, required this.person});

  @override
  State<PersonDocumentRecordsScreen> createState() =>
      _PersonDocumentRecordsScreenState();
}

class _PersonDocumentRecordsScreenState
    extends State<PersonDocumentRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // multi-select sets
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedExcluded = {};
  final Set<String> _selectedTypes = {};

  // date range (last updated)
  String _lastUpdatedFrom = '';
  String _lastUpdatedTo = '';

  // other filters
  bool _unpublished = false;
  String _createdFrom = 'All';
  String _sourceFrom = 'All';
  String _creationDate = 'All';
  String _fromDate = 'All';
  String _issuedDate = 'All';
  String _issuingCountry = 'All';
  String _toDate = 'All';
  bool _bookmarked = false;

  static const _categoryOptions = [
    'Absence',
    'Audit',
    'Awards and recognitions',
    'Benefits',
    'Compensation',
    'Employment',
    'Ethics and Compliance',
    'Expenses',
    'Gatekeeper law',
    'Identification',
    'Legal document',
    'Licenses and certificates',
    'Passport information',
    'Payroll',
    'Performance',
    'Personal information',
    'QS Education & Qualifications',
    'Qualification information',
    'Relationships',
    'Retail',
    'SD Document',
    'Salary information',
    'Swiss Registrations',
    'Visa and permit',
    'Visa information',
    'Working Hours Change Document',
  ];

  static const _excludedOptions = ['No attachment', 'Past-dated', 'Payroll'];

  static const _typeOptions = [
    '1095-C',
    'Absence Events DSN',
    'Achievements - nonperformance based',
    'Adoption',
    'Adoption certificate',
    'AHV-AVS',
    'Air Ticket',
    'Alliance Payments',
    'Application',
    'Attendance Record',
    'attestato di matrimonio',
    'Background Check',
    'Bankruptcy',
    'Before Employment Physical',
    'Beneficiary',
    'Birth',
    'Birth certificate',
    "Birth certificate of domestic partner's child",
    'Bonus Payment',
    'Brazil Birth Certificate',
    'Brazil Vaccination Certificate',
    'BUR',
    'BVG-LPP',
    'Canada End of Year Interface',
    'Card or ID',
    'Certification Regime document type',
    'Collective Bargaining Agreement',
    'Common law spouse affidavit',
    'Company Car',
    'Compensation Notification',
    'Completion',
    'Contact',
    'Correspondence Involuntary Deduction',
    'Correspondence Tax',
    'Court Order',
    'Court order for dependents',
    'COVID-19 Vaccination',
    'Creditor Debt',
    'CUD (Certificazione Unica Dipendente)',
    'Death',
    'Death certificate',
    'Debt Owed to a Creditor',
    'Deduction Authorization',
    'Degree or Certificate',
    'Dental Insurance',
    'Dependant',
    'Designation supporting document',
    'Disability Absence',
    'Disability Payroll',
    'Disciplinary',
    'Divorce decree certification',
    'Documenti Italiani',
    'Domestic partner affidavit',
    'Domestic partner certificate',
    'Domestic partner legal affidavit',
    'Drivers License',
    'e-IWO Orders',
    'Education Institution',
    'Education Loan',
    'Electoral Card',
    'Employee Discount',
    'Employee Grievance',
    'Employee Request',
    'Employee Stock Purchase Sale Income Notification',
    'Employee Stock Purchase Sale Third Party Income',
    'Employer Paid Benefits',
    'Employment Agreement',
    'Employment Certificate',
    'Employment / Compensation Verification',
    'Employment Letter',
    'End Of Contract Events DSN',
    'End of Year Report',
    'Enrollment document',
    'Evidence of Insurability',
    'FAK-CAF',
    'Filing Status',
    'Final Evaluation',
    'First Year Evaluation',
    'Form 16',
    'FORM12BA_REPORT',
    'FORM12BB_REPORT',
    'FORM16_PARTA',
    'FORM16_PARTB',
    'FORM16_REPORT',
    'Gender Recognition Certificate',
    'Gender Recognition Certificate',
    'Government Issued',
    'Government Issued',
    'Grandchild affidavit',
    'Health Insurance',
    'ID Card',
    'Ill-Health Retirement Assessment',
    'IN Proof Submission Documents',
    'Income from Sale or Purchase of Employee Stock',
    'Income Tax Computation Sheet Report',
    'Job Center Linking Letter',
    'KTG-AMC',
    'Leave Approval',
    'Leave Extension',
    'Leave Request',
    'Legal custody certificate',
    'Legal separation agreement',
    'Length of Service',
    'Letter of Recognition',
    'Life Insurance',
    'Living Will',
    'Loan Request',
    'Long Term Disability',
    'Mannai Air Ticket',
    'Mannai SS Letter Generation',
    'Manual Payments and Deductions for Benefits',
    'Manual Payments and Deductions for Others',
    'Manual Payments Deductions Benefits',
    'Manual Payments Deductions Other',
    'Marriage',
    'Marriage certificate',
    'Medical Disability',
    'Medical Reimbursement',
    'Medical Reports',
    'Mexico CFDI',
    'Military Active Duty',
    'Military Certificate',
    'Military Dependent',
    'Military Draft',
    'Moving Expense Non-Taxable',
    'Moving Expense Taxable',
    'Native of Country',
    'Non Medical Reports',
    'Notarized spousal consent',
    'Notes',
    'Optical Insurance',
    'Other Awards and Recognitions',
    'Other Benefits',
    'Other Employment',
    'Other Expenses Non-Taxable',
    'Other Expenses Taxable',
    'Other health coverage',
    'Other Identification',
    'Other Legal Document',
    'Other Licenses and Certificates',
    'Other Relationships',
    'Other than Medical Reports',
    'P11D',
    'P45 - Starter',
    'P6 P6B P9 EDI File',
    'P60',
    'Passport',
    'Pay Advance Remittance Advice',
    'Payment',
    'Payments after Termination',
    'Payrolled Benefits Statement',
    'Payslip',
    'Pension Automatic Enrolment',
    'Performance Based',
    'Performance Improvement Plan',
    'Permanent Resident',
    'Plan of Approach',
    'Power of Attorney',
    'Pre-Employment Physical',
    'Preference Request',
    'Previous Employment',
    'Problem Analysis',
    'Proof of Enrollment Child Care',
    'Proof of Enrollment Education',
    'Proof of external coverage',
    'Proof of good health',
    'Proof of life',
    'Proof of national identifier',
    'Proof of other coverage',
    'Proof of qualifying life event',
    "QS Bachelor's Degree",
    "QS Master's Degree",
    'QS Professional Certification',
    'QST-IS',
    'Recovery Information',
    'Recruiting',
    'Recruiting Job Offer Letters',
    'Recurring Physical',
    'Reference',
    'Relocation Payments',
    'Report of Earnings',
    'Residence',
    'Resident Citizen',
    'Retail',
    'Retirement Plan',
    'Return to Work',
    'Richiesta di cambio residenza',
    'RL1 Amended',
    'RL1 Cancelled',
    'RL1 Original',
    'RL1 Register Amended',
    'RL1 Register Cancelled',
    'RL1 Register Original',
    'RL2 Amended',
    'RL2 Cancelled',
    'RL2 Original',
    'RL2 Register Amended',
    'RL2 Register Cancelled',
    'RL2 Register Original',
    'ROE Worksheet',
    'Salary Increase',
    'Salary Letter',
    'Security Clearance Report',
    'Short Term Disabiity',
    'Short Term Disability',
    'Sign on Bonus',
    'ST-I',
    'Stock Grant',
    'Stock Purchase',
    'Supplies Non-Taxable',
    'Supplies Taxable',
    'Support Child',
    'Support Order',
    'T4 Amended',
    'T4 Cancelled',
    'T4 Original',
    'T4 Register Amended',
    'T4 Register Cancelled',
    'T4 Register Original',
    'T4A Amended',
    'T4A Cancelled',
    'T4A Original',
    'T4A Register Amended',
    'T4A Register Cancelled',
    'T4A Register Original',
    'Tax Deduction Certificate',
    'Tax Levy',
    'Termination',
    'Termination Report',
    'Terms and Conditions',
    'Test Annual Ticket Request',
    'Test Doc',
    'Test Doc Type',
    'Test Sys',
    'Third Party Payslip',
    'Third-Party Payroll Documents',
    'Transcripts',
    'Travel Request',
    'Tuition Reimbursement Agreement',
    'UID-BFS',
    'UID-EHRA',
    'UVG-LAA',
    'UVGZ-LAAC',
    'UWV Sickness Report',
    'Vehicle Details for Allowance',
    'Visa for Embassy',
    'Void Check',
    'Voter Registration',
    'W2',
    'Work',
    'Working Hours Change Document',
    'W_2',
    'W_2 Amended',
    'W_2c',
    'XYZ Passport',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _activeFilterCount {
    var count = 0;
    if (_selectedCategories.isNotEmpty) count++;
    if (_selectedExcluded.isNotEmpty) count++;
    if (_lastUpdatedFrom.isNotEmpty || _lastUpdatedTo.isNotEmpty) count++;
    if (_selectedTypes.isNotEmpty) count++;
    if (_unpublished) count++;
    if (_createdFrom != 'All') count++;
    if (_sourceFrom != 'All') count++;
    if (_creationDate != 'All') count++;
    if (_fromDate != 'All') count++;
    if (_issuedDate != 'All') count++;
    if (_issuingCountry != 'All') count++;
    if (_toDate != 'All') count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          _WebLikeHeader(
            title: 'Document Records',
            subtitle: '${widget.person.name}, ${widget.person.businessTitle}',
            initials: widget.person.initials,
            onBack: () => Navigator.maybePop(context),
            child: Column(
              children: [
                _SearchBox(
                  controller: _searchController,
                  hint: 'Search by type, name, or number',
                  trailingIcon: Icons.search_rounded,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                _buildFilterBar(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: _buildDocumentCard(),
          ),
        ],
      ),
    );
  }

  Future<void> _showCheckboxSheet({
    required String title,
    required List<String> options,
    required Set<String> current,
  }) async {
    final temp = Set<String>.from(current);
    final applied = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => FractionallySizedBox(
          heightFactor: 0.88,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setS(() => temp.clear()),
                        child: const Text('Clear all'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (_, i) {
                      final opt = options[i];
                      return CheckboxListTile(
                        title: Text(opt, style: const TextStyle(fontSize: 14)),
                        value: temp.contains(opt),
                        onChanged: (v) => setS(() {
                          if (v == true) {
                            temp.add(opt);
                          } else {
                            temp.remove(opt);
                          }
                        }),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        activeColor: const Color(0xFF1F4E8C),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF312C2A),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('See Results'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (applied == true) {
      setState(() {
        current.clear();
        current.addAll(temp);
      });
    }
  }

  Future<void> _showDateRangeSheet() async {
    final fromCtrl = TextEditingController(text: _lastUpdatedFrom);
    final toCtrl = TextEditingController(text: _lastUpdatedTo);
    final applied = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Text(
                    'Last Updated',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    children: [
                      TextField(
                        controller: fromCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Range start date',
                          hintText: 'Range start date',
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: () async {
                              final p = await showDatePicker(
                                context: ctx2,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (p != null) {
                                setS(
                                  () => fromCtrl.text =
                                      '${p.month}/${p.day}/${p.year}',
                                );
                              }
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F4E8C),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F4E8C),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F4E8C),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: toCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Range end date',
                          hintText: 'Range end date',
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: () async {
                              final p = await showDatePicker(
                                context: ctx2,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (p != null) {
                                setS(
                                  () => toCtrl.text =
                                      '${p.month}/${p.day}/${p.year}',
                                );
                              }
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F4E8C),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF312C2A),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('See Results'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (applied == true) {
      setState(() {
        _lastUpdatedFrom = fromCtrl.text;
        _lastUpdatedTo = toCtrl.text;
      });
    }
    fromCtrl.dispose();
    toCtrl.dispose();
  }

  Widget _buildFilterBar() {
    final catLabel = _selectedCategories.isEmpty
        ? ''
        : _selectedCategories.length == 1
        ? _selectedCategories.first
        : '${_selectedCategories.length} selected';
    final excLabel = _selectedExcluded.isEmpty
        ? ''
        : _selectedExcluded.length == 1
        ? _selectedExcluded.first
        : '${_selectedExcluded.length} selected';
    final luLabel = (_lastUpdatedFrom.isEmpty && _lastUpdatedTo.isEmpty)
        ? ''
        : _lastUpdatedFrom.isNotEmpty && _lastUpdatedTo.isNotEmpty
        ? '$_lastUpdatedFrom - $_lastUpdatedTo'
        : _lastUpdatedFrom.isNotEmpty
        ? 'From $_lastUpdatedFrom'
        : 'To $_lastUpdatedTo';
    final typeLabel = _selectedTypes.isEmpty
        ? ''
        : _selectedTypes.length == 1
        ? _selectedTypes.first
        : '${_selectedTypes.length} selected';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showCheckboxSheet(
                    title: 'Category',
                    options: _categoryOptions,
                    current: _selectedCategories,
                  ),
                  child: _FilterPill(
                    label: 'Category',
                    value: catLabel,
                    selected: _selectedCategories.isNotEmpty,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (val) => setState(() {
                    if (_selectedExcluded.contains(val)) {
                      _selectedExcluded.remove(val);
                    } else {
                      _selectedExcluded.add(val);
                    }
                  }),
                  itemBuilder: (_) => _excludedOptions
                      .map(
                        (opt) => PopupMenuItem<String>(
                          value: opt,
                          child: Row(
                            children: [
                              Icon(
                                _selectedExcluded.contains(opt)
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                size: 18,
                                color: _selectedExcluded.contains(opt)
                                    ? const Color(0xFF1F4E8C)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 8),
                              Text(opt),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  child: _FilterPill(
                    label: 'Excluded',
                    value: excLabel,
                    selected: _selectedExcluded.isNotEmpty,
                  ),
                ),
                GestureDetector(
                  onTap: _showDateRangeSheet,
                  child: _FilterPill(
                    label: 'Last Updated',
                    value: luLabel,
                    selected: luLabel.isNotEmpty,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showCheckboxSheet(
                    title: 'Type',
                    options: _typeOptions,
                    current: _selectedTypes,
                  ),
                  child: _FilterPill(
                    label: 'Type',
                    value: typeLabel,
                    selected: _selectedTypes.isNotEmpty,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _unpublished = !_unpublished),
                  child: _FilterPill(
                    label: 'Unpublished',
                    value: _unpublished ? 'Yes' : '',
                    selected: _unpublished,
                  ),
                ),
                _PlainFilterButton(
                  label: 'Filters',
                  onTap: _showDocumentFilters,
                ),
                TextButton(
                  onPressed: _activeFilterCount == 0 ? null : _clearFilters,
                  child: Text('Clear ($_activeFilterCount)'),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          tooltip: 'Bookmark',
          onPressed: () => setState(() => _bookmarked = !_bookmarked),
          icon: Icon(_bookmarked ? Icons.bookmark : Icons.bookmark_border),
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildDocumentCard() {
    final hasResults =
        _searchController.text.trim().isNotEmpty ||
        _selectedCategories.isNotEmpty ||
        _selectedTypes.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: OutlinedButton.icon(
              onPressed: _showAddDocumentSheet,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Color(0xFF9CA3AF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          if (!hasResults)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 22, 16, 120),
              child: Text(
                "We couldn't find any matching document record.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _DocumentRecordTile(
                    title: 'Passport',
                    number: 'P-4589221',
                    category: 'Identification',
                    type: 'Passport',
                    issuingCountry: 'Qatar',
                    issued: '1/1/24',
                    expires: '12/31/29',
                  ),
                  SizedBox(height: 10),
                  _DocumentRecordTile(
                    title: 'Employment Contract',
                    number: 'DOC-2026-001',
                    category: 'Employment',
                    type: 'Contract',
                    issuingCountry: 'Qatar',
                    issued: '6/15/26',
                    expires: '-',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedExcluded.clear();
      _selectedTypes.clear();
      _lastUpdatedFrom = '';
      _lastUpdatedTo = '';
      _unpublished = false;
      _createdFrom = 'All';
      _sourceFrom = 'All';
      _creationDate = 'All';
      _fromDate = 'All';
      _issuedDate = 'All';
      _issuingCountry = 'All';
      _toDate = 'All';
      _searchController.clear();
    });
  }

  Future<void> _showDocumentFilters() async {
    final selCats = Set<String>.from(_selectedCategories);
    final selExcl = Set<String>.from(_selectedExcluded);
    final selTypes = Set<String>.from(_selectedTypes);
    var luFrom = _lastUpdatedFrom;
    var luTo = _lastUpdatedTo;
    var unpublished = _unpublished;
    var createdFrom = _createdFrom;
    var sourceFrom = _sourceFrom;
    var creationDate = _creationDate;
    var fromDate = _fromDate;
    var issuedDate = _issuedDate;
    var issuingCountry = _issuingCountry;
    var toDate = _toDate;

    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close filters',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogCtx, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (dialogCtx, setSheetState) {
            return Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: _DocumentFilterDrawer(
                  onCancel: () => Navigator.pop(dialogCtx, false),
                  onSeeResults: () => Navigator.pop(dialogCtx, true),
                  child: Column(
                    children: [
                      _FilterExpansion(
                        title: 'Document type filters',
                        initiallyExpanded: true,
                        child: Column(
                          children: [
                            _SheetMultiSelectField(
                              label: 'Category',
                              options: _categoryOptions,
                              selected: selCats,
                              onChanged: (next) => setSheetState(() {
                                selCats
                                  ..clear()
                                  ..addAll(next);
                              }),
                            ),
                            const SizedBox(height: 12),
                            _SheetSingleSelectField(
                              label: 'Country',
                              value: 'All',
                              values: const [
                                'All',
                                'Qatar',
                                'United States',
                                'India',
                                'United Kingdom',
                              ],
                              onChanged: (_) {},
                            ),
                            const SizedBox(height: 12),
                            _SheetSingleSelectField(
                              label: 'Tags',
                              value: 'All',
                              values: const ['All', 'Past-dated'],
                              onChanged: (_) {},
                            ),
                            const SizedBox(height: 12),
                            _SheetMultiSelectField(
                              label: 'Type',
                              options: _typeOptions,
                              selected: selTypes,
                              onChanged: (next) => setSheetState(() {
                                selTypes
                                  ..clear()
                                  ..addAll(next);
                              }),
                            ),
                            const SizedBox(height: 12),
                            _SheetSingleSelectField(
                              label: 'Status',
                              value: unpublished ? 'Unpublished' : 'All',
                              values: const ['All', 'Published', 'Unpublished'],
                              onChanged: (value) => setSheetState(
                                () => unpublished = value == 'Unpublished',
                              ),
                            ),
                          ],
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Applied Tags',
                        child: _SheetMultiSelectField(
                          label: 'Applied Tags',
                          options: _categoryOptions,
                          selected: selCats,
                          onChanged: (next) => setSheetState(() {
                            selCats
                              ..clear()
                              ..addAll(next);
                          }),
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Created from',
                        child: _SheetSingleSelectField(
                          label: 'Created From',
                          value: createdFrom,
                          values: const [
                            'All',
                            'Person',
                            'Checklist',
                            'Upload',
                            'Document Type',
                          ],
                          onChanged: (v) =>
                              setSheetState(() => createdFrom = v),
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Created from',
                        child: _SheetSingleSelectField(
                          label: 'Created From',
                          value: sourceFrom,
                          values: const [
                            'All',
                            'Person',
                            'Checklist',
                            'Upload',
                            'Document Type',
                          ],
                          onChanged: (v) => setSheetState(() => sourceFrom = v),
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Creation date',
                        child: _SheetDateRangeFields(
                          startValue: creationDate == 'All' ? '' : creationDate,
                          endValue: '',
                          onStartChanged: (value) => setSheetState(
                            () => creationDate = value.isEmpty ? 'All' : value,
                          ),
                          onEndChanged: (_) {},
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Excluded',
                        child: _SheetCheckboxList(
                          options: _excludedOptions,
                          selected: selExcl,
                          onChanged: (next) => setSheetState(() {
                            selExcl
                              ..clear()
                              ..addAll(next);
                          }),
                        ),
                      ),
                      _FilterExpansion(
                        title: 'From date',
                        child: _SheetDateRangeFields(
                          startValue: fromDate == 'All' ? '' : fromDate,
                          endValue: '',
                          onStartChanged: (value) => setSheetState(
                            () => fromDate = value.isEmpty ? 'All' : value,
                          ),
                          onEndChanged: (_) {},
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Issued date',
                        child: _SheetDateRangeFields(
                          startValue: issuedDate == 'All' ? '' : issuedDate,
                          endValue: '',
                          onStartChanged: (value) => setSheetState(
                            () => issuedDate = value.isEmpty ? 'All' : value,
                          ),
                          onEndChanged: (_) {},
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Issuing Country',
                        child: _SheetSingleSelectField(
                          label: 'Issuing Country',
                          value: issuingCountry,
                          values: const [
                            'All',
                            'Qatar',
                            'United States',
                            'India',
                            'United Kingdom',
                          ],
                          onChanged: (v) =>
                              setSheetState(() => issuingCountry = v),
                        ),
                      ),
                      _FilterExpansion(
                        title: 'Last updated',
                        child: _SheetDateRangeFields(
                          startValue: luFrom,
                          endValue: luTo,
                          onStartChanged: (value) =>
                              setSheetState(() => luFrom = value),
                          onEndChanged: (value) =>
                              setSheetState(() => luTo = value),
                        ),
                      ),
                      _FilterExpansion(
                        title: 'To date',
                        child: _SheetDateRangeFields(
                          startValue: toDate == 'All' ? '' : toDate,
                          endValue: '',
                          onStartChanged: (value) => setSheetState(
                            () => toDate = value.isEmpty ? 'All' : value,
                          ),
                          onEndChanged: (_) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );

    if (result == true) {
      setState(() {
        _selectedCategories
          ..clear()
          ..addAll(selCats);
        _selectedExcluded
          ..clear()
          ..addAll(selExcl);
        _selectedTypes
          ..clear()
          ..addAll(selTypes);
        _lastUpdatedFrom = luFrom;
        _lastUpdatedTo = luTo;
        _unpublished = unpublished;
        _createdFrom = createdFrom;
        _sourceFrom = sourceFrom;
        _creationDate = creationDate;
        _fromDate = fromDate;
        _issuedDate = issuedDate;
        _issuingCountry = issuingCountry;
        _toDate = toDate;
      });
    }
  }

  void _showAddDocumentSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Document Record',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.upload_file_outlined),
                title: const Text('Upload document'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.note_add_outlined),
                title: const Text('Create document record'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineTextField extends StatefulWidget {
  final String initialValue;
  final String label;
  final ValueChanged<String> onChanged;

  const _InlineTextField({
    required this.initialValue,
    required this.label,
    required this.onChanged,
  });

  @override
  State<_InlineTextField> createState() => _InlineTextFieldState();
}

class _InlineTextFieldState extends State<_InlineTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class DocumentPerson {
  final String name;
  final String businessTitle;
  final String personNumber;
  final String assignmentNumber;
  final String email;
  final String assignmentStatus;
  final String workerType;

  const DocumentPerson(
    this.name,
    this.businessTitle,
    this.personNumber,
    this.assignmentNumber,
    this.email, {
    this.assignmentStatus = 'Active - Payroll Eligible',
    this.workerType = 'Employee',
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}

class _WebLikeHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? initials;
  final VoidCallback? onBack;
  final Widget child;

  const _WebLikeHeader({
    required this.title,
    required this.subtitle,
    this.initials,
    this.onBack,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF4B252C),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (onBack != null)
                  IconButton(
                    tooltip: 'Back',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                  ),
                if (initials != null) ...[
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Text(
                      initials!,
                      style: const TextStyle(
                        color: Color(0xFF4B252C),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFE5E7EB),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData trailingIcon;
  final ValueChanged<String> onChanged;

  const _SearchBox({
    required this.controller,
    required this.hint,
    this.trailingIcon = Icons.search_rounded,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: Icon(trailingIcon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;

  const _FilterPill({
    required this.label,
    this.value = '',
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : const Color(0xFFE5E7EB);
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1F4E8C) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF7A5960)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: foreground, fontWeight: FontWeight.w800),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: foreground),
              ),
            ),
          ],
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: foreground),
        ],
      ),
    );
  }
}

class _PlainFilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PlainFilterButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.tune_rounded),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF7A5960)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}

class _FilterSheetFrame extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onCancel;
  final VoidCallback onSeeResults;

  const _FilterSheetFrame({
    required this.title,
    required this.child,
    required this.onCancel,
    required this.onSeeResults,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: onCancel,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: child,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF312C2A),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onSeeResults,
                    child: const Text('See Results'),
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

class _DocumentFilterDrawer extends StatelessWidget {
  final Widget child;
  final VoidCallback onCancel;
  final VoidCallback onSeeResults;

  const _DocumentFilterDrawer({
    required this.child,
    required this.onCancel,
    required this.onSeeResults,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = screenWidth < 560 ? screenWidth * 0.92 : 380.0;
    return SizedBox(
      width: drawerWidth,
      height: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 18,
              offset: Offset(-4, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 10, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: onCancel,
                      icon: const Icon(Icons.close_fullscreen_rounded),
                      color: Color(0xFF4B5563),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  child: child,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF312C2A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: onSeeResults,
                        child: const Text('See Results'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterExpansion extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const _FilterExpansion({
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      iconColor: const Color(0xFF111827),
      collapsedIconColor: const Color(0xFF111827),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
      children: [child],
    );
  }
}

class _SheetSingleSelectField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  const _SheetSingleSelectField({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue = values.contains(value) ? value : values.first;
    return DropdownButtonFormField<String>(
      initialValue: selectedValue,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
      items: values
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
      style: const TextStyle(
        color: Color(0xFF374151),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      decoration: _sheetInputDecoration(label),
    );
  }
}

class _SheetMultiSelectField extends StatefulWidget {
  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  const _SheetMultiSelectField({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<_SheetMultiSelectField> createState() => _SheetMultiSelectFieldState();
}

class _SheetMultiSelectFieldState extends State<_SheetMultiSelectField> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.selected.isEmpty
        ? widget.label
        : widget.selected.length == 1
        ? widget.selected.first
        : '${widget.selected.length} selected';
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(3),
          child: InputDecorator(
            decoration: _sheetInputDecoration(widget.label),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  _open
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: const Color(0xFF111827),
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Container(
            constraints: const BoxConstraints(maxHeight: 230),
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(3),
            ),
            child: _SheetCheckboxList(
              options: widget.options,
              selected: widget.selected,
              onChanged: widget.onChanged,
              scrollable: true,
            ),
          ),
      ],
    );
  }
}

class _SheetCheckboxList extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final bool scrollable;

  const _SheetCheckboxList({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final children = options.map((opt) {
      return CheckboxListTile(
        value: selected.contains(opt),
        onChanged: (checked) {
          final next = Set<String>.from(selected);
          if (checked == true) {
            next.add(opt);
          } else {
            next.remove(opt);
          }
          onChanged(next);
        },
        title: Text(
          opt,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        activeColor: const Color(0xFF1F4E8C),
        contentPadding: EdgeInsets.zero,
      );
    }).toList();

    if (scrollable) {
      return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        children: children,
      );
    }
    return Column(children: children);
  }
}

class _SheetDateRangeFields extends StatelessWidget {
  final String startValue;
  final String endValue;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;

  const _SheetDateRangeFields({
    required this.startValue,
    required this.endValue,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SheetDateField(
          label: 'Range start date',
          value: startValue,
          onChanged: onStartChanged,
        ),
        const SizedBox(height: 12),
        _SheetDateField(
          label: 'Range end date',
          value: endValue,
          onChanged: onEndChanged,
        ),
      ],
    );
  }
}

class _SheetDateField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _SheetDateField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged('${picked.month}/${picked.day}/${picked.year}');
        }
      },
      borderRadius: BorderRadius.circular(3),
      child: InputDecorator(
        decoration: _sheetInputDecoration(label).copyWith(
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF111827),
            size: 16,
          ),
        ),
        child: Text(
          value.isEmpty ? label : value,
          style: TextStyle(
            color: value.isEmpty
                ? const Color(0xFF6B7280)
                : const Color(0xFF111827),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

InputDecoration _sheetInputDecoration(String label) {
  return InputDecoration(
    labelText: null,
    hintText: label,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: Color(0xFF1F4E8C), width: 1.4),
    ),
  );
}

class _SelectField extends StatelessWidget {
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  const _SelectField({
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: values.contains(value) ? value : values.first,
      items: values
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  const _SortButton({
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: values
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _DocumentPersonRow extends StatelessWidget {
  final DocumentPerson person;
  final bool compact;
  final VoidCallback onTap;

  const _DocumentPersonRow({
    required this.person,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: Text(person.initials)),
      title: Text(
        person.name,
        style: const TextStyle(
          color: Color(0xFF00759B),
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Text('${person.businessTitle}\n${person.email}'),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _MiniField extends StatelessWidget {
  final String label;
  final String value;

  const _MiniField(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _DocumentRecordTile extends StatelessWidget {
  final String title;
  final String number;
  final String category;
  final String type;
  final String issuingCountry;
  final String issued;
  final String expires;

  const _DocumentRecordTile({
    required this.title,
    required this.number,
    required this.category,
    required this.type,
    required this.issuingCountry,
    required this.issued,
    required this.expires,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: Color(0xFF00759B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _MiniField('Number', number),
              _MiniField('Category', category),
              _MiniField('Type', type),
              _MiniField('Issuing Country', issuingCountry),
              _MiniField('Issued Date', issued),
              _MiniField('To Date', expires),
            ],
          ),
        ],
      ),
    );
  }
}
