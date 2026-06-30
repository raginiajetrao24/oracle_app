import 'package:flutter/material.dart';

class DocumentRecordsScreen extends StatefulWidget {
  const DocumentRecordsScreen({super.key});

  @override
  State<DocumentRecordsScreen> createState() => _DocumentRecordsScreenState();
}

class _DocumentRecordsScreenState extends State<DocumentRecordsScreen> {
  static const _text = Color(0xFF1F2937);

  final TextEditingController _searchController = TextEditingController();
  String _businessTitle = 'All';
  String _assignmentStatus = 'Active - Payroll Eligible';
  String _effectiveDate = '6/29/26';
  bool _includeTerminated = false;
  String _terminationDate = 'All';
  String _workerType = 'Employee';
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
      final matchesTitle =
          _businessTitle == 'All' || person.businessTitle == _businessTitle;
      return matchesQuery && matchesTitle;
    }).toList();

    if (_sortBy == 'Name') {
      rows.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'Person Number') {
      rows.sort((a, b) => a.personNumber.compareTo(b.personNumber));
    }
    return rows;
  }

  int get _activeFilterCount {
    var count = 0;
    if (_businessTitle != 'All') count++;
    if (_assignmentStatus != 'Active - Payroll Eligible') count++;
    if (_effectiveDate != '6/29/26') count++;
    if (_includeTerminated) count++;
    if (_terminationDate != 'All') count++;
    if (_workerType != 'Employee') count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      _businessTitle = 'All';
      _assignmentStatus = 'Active - Payroll Eligible';
      _effectiveDate = '6/29/26';
      _includeTerminated = false;
      _terminationDate = 'All';
      _workerType = 'Employee';
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
            title: 'Personal Details',
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
          _FilterButton(
            label: 'Business Title',
            value: _businessTitle,
            onTap: _showListFilters,
          ),
          _FilterButton(
            label: 'Assignment Status',
            value: _assignmentStatus,
            onTap: _showListFilters,
          ),
          _FilterButton(
            label: 'Effective As-of Date',
            value: _effectiveDate,
            onTap: _showListFilters,
          ),
          _ToggleFilterButton(
            label: 'Include Terminated Work Relationships',
            selected: _includeTerminated,
            onTap: () =>
                setState(() => _includeTerminated = !_includeTerminated),
          ),
          _FilterButton(
            label: 'Termination Date',
            value: _terminationDate,
            onTap: _showListFilters,
          ),
          _FilterButton(
            label: 'Worker Type',
            value: _workerType,
            onTap: _showListFilters,
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
                  values: const ['Relevance', 'Name', 'Person Number'],
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
    var businessTitle = _businessTitle;
    var assignmentStatus = _assignmentStatus;
    var effectiveDate = _effectiveDate;
    var includeTerminated = _includeTerminated;
    var terminationDate = _terminationDate;
    var workerType = _workerType;
    final titles = {
      'All',
      ..._people.map((person) => person.businessTitle),
    }.toList();

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
                  title: 'Business Title',
                  child: _SelectField(
                    value: businessTitle,
                    values: titles,
                    onChanged: (value) =>
                        setSheetState(() => businessTitle = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Assignment Status',
                  child: _SelectField(
                    value: assignmentStatus,
                    values: const [
                      'All',
                      'Active - Payroll Eligible',
                      'Inactive',
                      'Suspended',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => assignmentStatus = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Effective As-of Date',
                  child: _InlineTextField(
                    initialValue: effectiveDate,
                    label: 'Effective As-of Date',
                    onChanged: (value) => effectiveDate = value,
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Include Terminated Work Relationships',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  value: includeTerminated,
                  onChanged: (value) =>
                      setSheetState(() => includeTerminated = value),
                ),
                _FilterExpansion(
                  title: 'Termination Date',
                  child: _SelectField(
                    value: terminationDate,
                    values: const [
                      'All',
                      'Today',
                      'Last 7 days',
                      'Last 30 days',
                      'Custom date',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => terminationDate = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Worker Type',
                  child: _SelectField(
                    value: workerType,
                    values: const [
                      'All',
                      'Employee',
                      'Contingent Worker',
                      'Nonworker',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => workerType = value),
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
        _businessTitle = businessTitle;
        _assignmentStatus = assignmentStatus;
        _effectiveDate = effectiveDate;
        _includeTerminated = includeTerminated;
        _terminationDate = terminationDate;
        _workerType = workerType;
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
  String _category = 'All';
  String _excluded = 'Excluded 2';
  String _lastUpdated = 'All';
  String _type = 'All';
  bool _unpublished = false;
  String _createdFrom = 'All';
  String _creationDate = 'All';
  String _fromDate = 'All';
  String _issuedDate = 'All';
  String _issuingCountry = 'All';
  String _toDate = 'All';
  bool _bookmarked = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _activeFilterCount {
    var count = 0;
    if (_category != 'All') count++;
    if (_excluded != 'Excluded 2') count++;
    if (_lastUpdated != 'All') count++;
    if (_type != 'All') count++;
    if (_unpublished) count++;
    if (_createdFrom != 'All') count++;
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

  Widget _buildFilterBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _PlainFilterButton(
                  label: 'Category',
                  onTap: _showDocumentFilters,
                ),
                _FilterButton(
                  label: 'Excluded',
                  value: _excluded,
                  onTap: _showDocumentFilters,
                ),
                _PlainFilterButton(
                  label: 'Last Updated',
                  onTap: _showDocumentFilters,
                ),
                _PlainFilterButton(label: 'Type', onTap: _showDocumentFilters),
                _PlainFilterButton(
                  label: 'Unpublished',
                  onTap: _showDocumentFilters,
                ),
                _PlainFilterButton(
                  label: 'Filters',
                  onTap: _showDocumentFilters,
                ),
                TextButton(
                  onPressed: _clearFilters,
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
        _searchController.text.trim().isNotEmpty || _category != 'All';
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
      _category = 'All';
      _excluded = 'Excluded 2';
      _lastUpdated = 'All';
      _type = 'All';
      _unpublished = false;
      _createdFrom = 'All';
      _creationDate = 'All';
      _fromDate = 'All';
      _issuedDate = 'All';
      _issuingCountry = 'All';
      _toDate = 'All';
      _searchController.clear();
    });
  }

  Future<void> _showDocumentFilters() async {
    var category = _category;
    var excluded = _excluded;
    var lastUpdated = _lastUpdated;
    var type = _type;
    var unpublished = _unpublished;
    var createdFrom = _createdFrom;
    var creationDate = _creationDate;
    var fromDate = _fromDate;
    var issuedDate = _issuedDate;
    var issuingCountry = _issuingCountry;
    var toDate = _toDate;

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
                  title: 'Document type filters',
                  child: _SelectField(
                    value: type,
                    values: const [
                      'All',
                      'Passport',
                      'Contract',
                      'Visa',
                      'Certificate',
                    ],
                    onChanged: (value) => setSheetState(() => type = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Applied Tags',
                  child: _SelectField(
                    value: category,
                    values: const [
                      'All',
                      'Identification',
                      'Employment',
                      'Education',
                      'Medical',
                    ],
                    onChanged: (value) => setSheetState(() => category = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Created from',
                  child: _SelectField(
                    value: createdFrom,
                    values: const [
                      'All',
                      'Person',
                      'Checklist',
                      'Upload',
                      'Document Type',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => createdFrom = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Creation date',
                  child: _SelectField(
                    value: creationDate,
                    values: const [
                      'All',
                      'Today',
                      'Last 7 days',
                      'Last 30 days',
                      'Custom',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => creationDate = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Excluded',
                  child: _SelectField(
                    value: excluded,
                    values: const ['Excluded 2', 'Included', 'Excluded', 'All'],
                    onChanged: (value) => setSheetState(() => excluded = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'From date',
                  child: _SelectField(
                    value: fromDate,
                    values: const [
                      'All',
                      'Today',
                      'Last 7 days',
                      'Last 30 days',
                      'Custom',
                    ],
                    onChanged: (value) => setSheetState(() => fromDate = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Issued date',
                  child: _SelectField(
                    value: issuedDate,
                    values: const [
                      'All',
                      'Today',
                      'Last 7 days',
                      'Last 30 days',
                      'Custom',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => issuedDate = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Issuing Country',
                  child: _SelectField(
                    value: issuingCountry,
                    values: const [
                      'All',
                      'Qatar',
                      'United States',
                      'India',
                      'United Kingdom',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => issuingCountry = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'Last updated',
                  child: _SelectField(
                    value: lastUpdated,
                    values: const [
                      'All',
                      'Today',
                      'Last 7 days',
                      'Last 30 days',
                      'Custom',
                    ],
                    onChanged: (value) =>
                        setSheetState(() => lastUpdated = value),
                  ),
                ),
                _FilterExpansion(
                  title: 'To date',
                  child: _SelectField(
                    value: toDate,
                    values: const [
                      'All',
                      'Today',
                      'Next 7 days',
                      'Next 30 days',
                      'Custom',
                    ],
                    onChanged: (value) => setSheetState(() => toDate = value),
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Unpublished',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  value: unpublished,
                  onChanged: (value) =>
                      setSheetState(() => unpublished = value),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (result == true) {
      setState(() {
        _category = category;
        _excluded = excluded;
        _lastUpdated = lastUpdated;
        _type = type;
        _unpublished = unpublished;
        _createdFrom = createdFrom;
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
    final parts = name.split(' ');
    return parts.map((part) => part[0]).take(2).join().toUpperCase();
  }
}

class _WebLikeHeader extends StatelessWidget {
  static const _header = Color(0xFFC9DFF6);
  static const _blue = Color(0xFF1F4E8C);

  final String title;
  final String subtitle;
  final String? initials;
  final Widget child;
  final VoidCallback onBack;

  const _WebLikeHeader({
    required this.title,
    required this.subtitle,
    this.initials,
    required this.child,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _header,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 18,
        16,
        22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: _blue,
              ),
              if (initials != null) ...[
                Container(
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    initials!,
                    style: const TextStyle(
                      color: _blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.home_outlined, color: _blue),
              const SizedBox(width: 12),
              const Icon(Icons.notifications_none_rounded, color: _blue),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final IconData trailingIcon;

  const _SearchBox({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.trailingIcon = Icons.search_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Color(0xFF1F2937)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
        suffixIcon: controller.text.isEmpty
            ? Icon(trailingIcon, color: const Color(0xFF64748B))
            : IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF1F4E8C), width: 1.4),
        ),
      ),
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: compact
            ? Row(
                children: [
                  Expanded(child: _NameAndTitle(person: person)),
                  const Icon(Icons.chevron_right_rounded),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NameAndTitle(person: person),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: [
                      _MiniField('Person Number', person.personNumber),
                      _MiniField('Assignment Number', person.assignmentNumber),
                      _MiniField('Assignment Status', person.assignmentStatus),
                      _MiniField('Worker Type', person.workerType),
                      _MiniField('Work Email', person.email),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _NameAndTitle extends StatelessWidget {
  final DocumentPerson person;
  const _NameAndTitle({required this.person});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          person.name,
          style: const TextStyle(
            color: Color(0xFF00759B),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          person.businessTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF1F2937), fontSize: 13),
        ),
      ],
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
      width: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ChipShell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1F4E8C),
              fontWeight: FontWeight.w800,
            ),
          ),
          if (value != 'All') ...[
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(color: Color(0xFF1F2937))),
          ],
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
    return _ChipShell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1F4E8C),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ToggleFilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleFilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ChipShell(
      onTap: onTap,
      selected: selected,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...[
            const Icon(Icons.check_rounded, color: Color(0xFF1F4E8C), size: 16),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1F4E8C),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipShell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool selected;

  const _ChipShell({
    required this.child,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFE8F0FC)
                : Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: child,
        ),
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
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => values
          .map((item) => PopupMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort By ',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(value),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
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
      heightFactor: 0.92,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Expand filters',
                    onPressed: () {},
                    icon: const Icon(Icons.open_in_full_rounded, size: 19),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
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
                    onPressed: onSeeResults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF312C2A),
                      foregroundColor: Colors.white,
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
  }
}

class _FilterExpansion extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterExpansion({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 14),
      leading: const Icon(Icons.chevron_right_rounded),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
      children: [child],
    );
  }
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
