import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/data/help_desk_requests_data_source.dart';
import '../../app/models/help_desk_request_model.dart';
import '../../widgets/common/app_header_widget.dart';
import 'create_help_desk_request_screen.dart';

const List<String> _statusAdvancedOptions = [
  'All of the Words',
  'Any of the Words',
  'Equals',
  'Exists',
  'Fuzzy Match',
  'Is Missing',
  'None of the Words',
  'Not Equal to',
];

const List<String> _searchScopeOptions = [
  'All records I can see',
  'Assigned to me',
  'Assigned to my subordinates',
  'Created by me',
  'I am a member of the Queue',
  'I am on the Account team',
  'I am on the team',
  'My subordinates are members of Queue',
  'My subordinates are on the team',
];

const List<String> _groupByOptions = [
  'None',
  'Assigned To',
  'Category Name',
  'Created By',
  'Critical',
  'Last Updated By',
  'Primary Point of Contact',
  'Queue',
  'Severity',
  'Status',
];

const List<String> _manageColumnOptions = [
  'Assigned To',
  'Assigned To: Name',
  'Assigned To: E-Mail',
  'Assigned To: Effective As-of Date',
  'Assigned To: First Name',
  'Assigned To: Last Name',
  'Assigned To: Middle Name',
  'Assigned To: Primary Email',
  'Assigned To: Primary Email: Email',
  'Assigned To: Primary Email: Do Not Email',
  'Assigned To: Primary Phone',
  'Assigned To: Primary Phone: Phone Number',
  'Assigned To: Primary Phone: Do Not Call',
  'Assigned To: Primary Phone: Phone',
  'Assigned To: To Date',
  'Assigned To: User Name',
  'Assisted by Human Flag',
  'Category Name',
  'Channel Type',
  'Contact',
  'Contact: Name',
  'Contact: Job Title',
  'Contact: Primary Address',
  'Contact: Primary Address: Address',
  'Contact: Primary Address: City',
  'Contact: Primary Address: Country',
  'Contact: Primary Address: Site Number',
  'Contact: Primary Address: State',
  'Contact: Primary Email',
  'Contact: Primary Email: Email',
  'Contact: Primary Email: Do Not Email',
  'Contact: Primary Phone',
  'Contact: Primary Phone: Phone Number',
  'Contact: Primary Phone: Do Not Call',
  'Contact: Primary Phone: Phone',
  'Contact: Registry ID',
  'Contacts',
  'Created By',
  'Creation Date',
  'Critical',
  'Date Closed',
  'Date Reported',
  'Detailed Description',
  'Handled by AI Flag',
  'Language Code',
  'Last Updated By',
  'Last Updated Date',
  'Messages',
  'Outcome',
  'Owner Type',
  'Primary Point of Contact',
  'Primary Point of Contact: Name',
  'Product',
  'Product: Name',
  'Product Group',
  'Product Group: Name',
  'Product Group: Active',
  'Product Group: Description',
  'Product Group: Effective from Date',
  'Product Group: Effective to Date',
  'Product Group: Reference Number',
  'Product: Description',
  'Product: Product Number',
  'Product: Sales Product Type',
  'Queue',
  'Queue: Queue Name',
  'Reported By',
  'Reported By: Name',
  'Request Number',
  'Resolution Code',
  'Resolution Date',
  'Resolved By',
  'Resolved by AI Flag',
  'Severity',
  'Solution Description',
  'Status',
  'Status Type',
  'Stripe Code',
  'Subject',
  'Team Members',
];

class HelpDeskRequestsScreen extends StatefulWidget {
  final HelpDeskRequestsDataSource dataSource;

  const HelpDeskRequestsScreen({
    super.key,
    this.dataSource = const MockHelpDeskRequestsDataSource(),
  });

  @override
  State<HelpDeskRequestsScreen> createState() => _HelpDeskRequestsScreenState();
}

class _HelpDeskRequestsScreenState extends State<HelpDeskRequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<HelpDeskStatus> _selectedStatuses = {
    HelpDeskStatus.newRequest,
    HelpDeskStatus.inProgress,
    HelpDeskStatus.waiting,
  };
  final Set<String> _selectedScopes = {'All records I can see'};
  final Set<String> _selectedColumns = {
    'Request Number',
    'Subject',
    'Severity',
    'Status',
    'Last Updated Date',
    'Assigned To',
  };

  List<HelpDeskRequest> _requests = [];
  bool _loading = true;
  String _groupBy = _groupByOptions.first;
  String _statusOperator = 'Equals';
  HelpDeskStatus _advancedStatusValue = HelpDeskStatus.newRequest;

  // Checkbox state
  final Set<String> _checkedRequestIds = {};
  bool _selectAllChecked = false;

  // Dropdown open state for group by groups
  final Set<String> _expandedGroups = {};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    final requests = await widget.dataSource.fetchRequests();
    if (!mounted) return;
    setState(() {
      _requests = requests;
      _loading = false;
    });
  }

  List<HelpDeskRequest> get _filteredRequests {
    final query = _searchController.text.trim().toLowerCase();
    return _requests.where((request) {
      final matchesStatus = _selectedStatuses.contains(request.status);
      final matchesQuery =
          query.isEmpty ||
          request.requestNumber.toLowerCase().contains(query) ||
          request.subject.toLowerCase().contains(query) ||
          request.assignedTo.toLowerCase().contains(query) ||
          request.categoryName.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  String _groupKey(HelpDeskRequest request) {
    switch (_groupBy) {
      case 'Assigned To':
        return request.assignedTo.isEmpty ? 'Unassigned' : request.assignedTo;
      case 'Category Name':
        return request.categoryName;
      case 'Created By':
        return request.createdBy;
      case 'Critical':
        return request.severity == HelpDeskSeverity.critical
            ? 'Critical'
            : 'Not Critical';
      case 'Queue':
        return request.queue;
      case 'Severity':
        return request.severity.label;
      case 'Status':
        return request.status.label;
      case 'Primary Point of Contact':
        return request.primaryPointOfContact;
      case 'Last Updated By':
        return request.assignedTo.isEmpty ? 'Unknown' : request.assignedTo;
      default:
        return '';
    }
  }

  Map<String, List<HelpDeskRequest>> get _groupedRequests {
    if (_groupBy == 'None') return {};
    final results = _filteredRequests;
    final Map<String, List<HelpDeskRequest>> groups = {};
    for (final request in results) {
      final key = _groupKey(request);
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(request);
    }
    // Sort keys
    final sortedKeys = groups.keys.toList()..sort();
    final sortedMap = <String, List<HelpDeskRequest>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = groups[key]!;
    }
    return sortedMap;
  }

  void _toggleCheck(String requestNumber) {
    setState(() {
      if (_checkedRequestIds.contains(requestNumber)) {
        _checkedRequestIds.remove(requestNumber);
      } else {
        _checkedRequestIds.add(requestNumber);
      }
      _selectAllChecked =
          _checkedRequestIds.length == _filteredRequests.length &&
          _filteredRequests.isNotEmpty;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectAllChecked) {
        _checkedRequestIds.clear();
        _selectAllChecked = false;
      } else {
        _checkedRequestIds.addAll(
          _filteredRequests.map((r) => r.requestNumber),
        );
        _selectAllChecked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredRequests;
    final grouped = _groupedRequests;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: AppHeaderWidget(
                title: 'Help Desk Requests',
                showBack: true,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: _FilterPanel(
                  searchController: _searchController,
                  selectedStatuses: _selectedStatuses,
                  selectedScopes: _selectedScopes,
                  onSearchChanged: () => setState(() {}),
                  onStatusTap: _showStatusFilter,
                  onScopeTap: _showSearchScopeFilter,
                  onClearSearch: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              sliver: SliverToBoxAdapter(
                child: _Toolbar(
                  groupBy: _groupBy,
                  groupByOptions: _groupByOptions,
                  selectedCount: _checkedRequestIds.length,
                  onGroupByChanged: (value) =>
                      setState(() => _groupBy = value ?? _groupBy),
                  onActionsSelected: _handleAction,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: _loading
                  ? const SliverToBoxAdapter(child: _LoadingCard())
                  : _groupBy == 'None'
                  ? SliverToBoxAdapter(
                      child: _RequestsTable(
                        requests: results,
                        checkedIds: _checkedRequestIds,
                        selectAllChecked: _selectAllChecked,
                        onToggleCheck: _toggleCheck,
                        onToggleSelectAll: _toggleSelectAll,
                        onActionSelected: _handleAction,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: _GroupedRequestsView(
                        grouped: grouped,
                        groupBy: _groupBy,
                        checkedIds: _checkedRequestIds,
                        expandedGroups: _expandedGroups,
                        onToggleCheck: _toggleCheck,
                        onToggleGroup: (key) => setState(() {
                          if (_expandedGroups.contains(key)) {
                            _expandedGroups.remove(key);
                          } else {
                            _expandedGroups.add(key);
                          }
                        }),
                        onActionSelected: _handleAction,
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateHelpDeskRequestScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
      ),
    );
  }

  void _handleAction(String action) {
    if (action == 'Manage Columns') {
      _showManageColumns();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(action),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showStatusFilter() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        var localStatuses = Set<HelpDeskStatus>.of(_selectedStatuses);
        var localOperator = _statusOperator;
        var localValue = _advancedStatusValue;
        var advancedExpanded = false;

        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SheetTitle('Status'),
                    const SizedBox(height: 12),
                    ...HelpDeskStatus.values.map(
                      (status) => CheckboxListTile(
                        value: localStatuses.contains(status),
                        onChanged: (checked) => sheetSetState(() {
                          checked == true
                              ? localStatuses.add(status)
                              : localStatuses.remove(status);
                        }),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Expanded(child: Text(status.label)),
                            Text(
                              '(${_countForStatus(status)})',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => sheetSetState(
                        () => advancedExpanded = !advancedExpanded,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_list_rounded,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Advanced',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              advancedExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (advancedExpanded) ...[
                      const SizedBox(height: 8),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ..._statusAdvancedOptions.map(
                              (option) => _AdvancedOptionTile(
                                label: option,
                                selected: option == localOperator,
                                onTap: () =>
                                    sheetSetState(() => localOperator = option),
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<HelpDeskStatus>(
                              initialValue: localValue,
                              decoration: const InputDecoration(
                                labelText: 'Value',
                                prefixIcon: Icon(Icons.tune_rounded),
                              ),
                              items: HelpDeskStatus.values
                                  .map(
                                    (status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => sheetSetState(
                                () => localValue = value ?? localValue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedStatuses
                                  ..clear()
                                  ..addAll(localStatuses);
                                _statusOperator = localOperator;
                                _advancedStatusValue = localValue;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSearchScopeFilter() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        var localScopes = Set<String>.of(_selectedScopes);
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SheetTitle('Search Filter'),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: _searchScopeOptions
                            .map(
                              (scope) => CheckboxListTile(
                                value: localScopes.contains(scope),
                                onChanged: (checked) => sheetSetState(() {
                                  checked == true
                                      ? localScopes.add(scope)
                                      : localScopes.remove(scope);
                                }),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(scope),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedScopes
                            ..clear()
                            ..addAll(localScopes);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showManageColumns() async {
    final searchController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        var localColumns = Set<String>.of(_selectedColumns);
        var query = '';
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            final fields = _manageColumnOptions
                .where((field) => field.toLowerCase().contains(query))
                .toList();

            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.82,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SheetTitle('Manage Columns'),
                      const SizedBox(height: 16),
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search Fields',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                        onChanged: (value) => sheetSetState(
                          () => query = value.trim().toLowerCase(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: fields.length,
                          itemBuilder: (context, index) {
                            final field = fields[index];
                            return CheckboxListTile(
                              value: localColumns.contains(field),
                              onChanged: (checked) => sheetSetState(() {
                                checked == true
                                    ? localColumns.add(field)
                                    : localColumns.remove(field);
                              }),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                field,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedColumns
                                    ..clear()
                                    ..addAll(localColumns);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Apply'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    searchController.dispose();
  }

  int _countForStatus(HelpDeskStatus status) {
    return _requests.where((request) => request.status == status).length;
  }
}

class _FilterPanel extends StatelessWidget {
  final TextEditingController searchController;
  final Set<HelpDeskStatus> selectedStatuses;
  final Set<String> selectedScopes;
  final VoidCallback onSearchChanged;
  final VoidCallback onStatusTap;
  final VoidCallback onScopeTap;
  final VoidCallback onClearSearch;

  const _FilterPanel({
    required this.searchController,
    required this.selectedStatuses,
    required this.selectedScopes,
    required this.onSearchChanged,
    required this.onStatusTap,
    required this.onScopeTap,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChipButton(
                label: 'Status (${selectedStatuses.length})',
                icon: Icons.checklist_rounded,
                onTap: onStatusTap,
              ),
              _FilterChipButton(
                label: selectedScopes.isEmpty
                    ? 'Search Filter'
                    : selectedScopes.first,
                icon: Icons.filter_alt_outlined,
                onTap: onScopeTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchController,
            onChanged: (_) => onSearchChanged(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Try searching by keyword or add a filter',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: onClearSearch,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final String groupBy;
  final List<String> groupByOptions;
  final int selectedCount;
  final ValueChanged<String?> onGroupByChanged;
  final ValueChanged<String> onActionsSelected;

  const _Toolbar({
    required this.groupBy,
    required this.groupByOptions,
    required this.selectedCount,
    required this.onGroupByChanged,
    required this.onActionsSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: groupBy,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Group By',
                  prefixIcon: Icon(Icons.group_work_outlined),
                ),

                items: groupByOptions
                    .map(
                      (option) =>
                          DropdownMenuItem(value: option, child: Text(option)),
                    )
                    .toList(),
                onChanged: onGroupByChanged,
              ),
            ),
            const SizedBox(width: 10),
            if (selectedCount > 0)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$selectedCount selected',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            PopupMenuButton<String>(
              tooltip: 'Actions',
              onSelected: onActionsSelected,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'Save', child: Text('Save')),
                PopupMenuItem(
                  value: 'Export to Excel',
                  child: Text('Export to Excel'),
                ),
                PopupMenuItem(
                  value: 'Export to CSV',
                  child: Text('Export to CSV'),
                ),
                PopupMenuItem(
                  value: 'Manage Columns',
                  child: Text('Manage Columns'),
                ),
                PopupMenuItem(
                  value: 'Sort by Relevance',
                  child: Text('Sort by Relevance'),
                ),
              ],
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Actions',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GroupedRequestsView extends StatelessWidget {
  final Map<String, List<HelpDeskRequest>> grouped;
  final String groupBy;
  final Set<String> checkedIds;
  final Set<String> expandedGroups;
  final ValueChanged<String> onToggleCheck;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<String> onActionSelected;

  const _GroupedRequestsView({
    required this.grouped,
    required this.groupBy,
    required this.checkedIds,
    required this.expandedGroups,
    required this.onToggleCheck,
    required this.onToggleGroup,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                const Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${grouped.values.fold(0, (sum, list) => sum + list.length)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Grouped by: $groupBy',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ...grouped.entries.map(
            (entry) => _GroupSection(
              groupKey: entry.key,
              requests: entry.value,
              checkedIds: checkedIds,
              expanded: expandedGroups.contains(entry.key),
              onToggleCheck: onToggleCheck,
              onToggleExpand: () => onToggleGroup(entry.key),
              onActionSelected: onActionSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  final String groupKey;
  final List<HelpDeskRequest> requests;
  final Set<String> checkedIds;
  final bool expanded;
  final ValueChanged<String> onToggleCheck;
  final VoidCallback onToggleExpand;
  final ValueChanged<String> onActionSelected;

  const _GroupSection({
    required this.groupKey,
    required this.requests,
    required this.checkedIds,
    required this.expanded,
    required this.onToggleCheck,
    required this.onToggleExpand,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final groupAllChecked = requests.every(
      (r) => checkedIds.contains(r.requestNumber),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: const Border(
              top: BorderSide(color: AppColors.border),
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: InkWell(
            onTap: onToggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: _RequestsTable.checkWidth,
                    height: 48,
                    child: Center(
                      child: Checkbox(
                        value: groupAllChecked,
                        onChanged: (_) {
                          final allChecked = groupAllChecked;
                          for (final r in requests) {
                            if (allChecked &&
                                checkedIds.contains(r.requestNumber)) {
                              onToggleCheck(r.requestNumber);
                            } else if (!allChecked &&
                                !checkedIds.contains(r.requestNumber)) {
                              onToggleCheck(r.requestNumber);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      groupKey,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${requests.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (expanded)
          ...requests.map(
            (request) => _RequestTableRow(
              request: request,
              checked: checkedIds.contains(request.requestNumber),
              onToggleCheck: () => onToggleCheck(request.requestNumber),
              onActionSelected: onActionSelected,
            ),
          ),
      ],
    );
  }
}

class _RequestsTable extends StatelessWidget {
  final List<HelpDeskRequest> requests;
  final Set<String> checkedIds;
  final bool selectAllChecked;
  final ValueChanged<String> onToggleCheck;
  final VoidCallback onToggleSelectAll;
  final ValueChanged<String> onActionSelected;

  const _RequestsTable({
    required this.requests,
    required this.checkedIds,
    required this.selectAllChecked,
    required this.onToggleCheck,
    required this.onToggleSelectAll,
    required this.onActionSelected,
  });

  static const double checkWidth = 44;
  static const double requestWidth = 132;
  static const double subjectWidth = 180;
  static const double severityWidth = 118;
  static const double statusWidth = 132;
  static const double dateWidth = 170;
  static const double assignedWidth = 150;
  static const double actionsWidth = 90;

  static const double tableWidth =
      checkWidth +
      requestWidth +
      subjectWidth +
      severityWidth +
      statusWidth +
      dateWidth +
      assignedWidth +
      actionsWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                const Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${requests.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: checkWidth,
                          height: 48,
                          child: Center(
                            child: Checkbox(
                              value: selectAllChecked,
                              onChanged: (_) => onToggleSelectAll(),
                            ),
                          ),
                        ),
                        const _HeaderCell(
                          label: 'Request\nNumber',
                          width: requestWidth,
                        ),
                        _HeaderCell(label: 'Subject', width: subjectWidth),
                        _HeaderCell(label: 'Severity', width: severityWidth),
                        _HeaderCell(label: 'Status', width: statusWidth),
                        _HeaderCell(
                          label: 'Last Updated\nDate',
                          width: dateWidth,
                        ),
                        _HeaderCell(label: 'Assigned To', width: assignedWidth),
                        _HeaderCell(
                          label: 'Actions',
                          width: actionsWidth,
                          sortable: false,
                        ),
                      ],
                    ),
                  ),
                  if (requests.isEmpty)
                    const SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'No requests found.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ...requests.map(
                      (request) => _RequestTableRow(
                        request: request,
                        checked: checkedIds.contains(request.requestNumber),
                        onToggleCheck: () =>
                            onToggleCheck(request.requestNumber),
                        onActionSelected: onActionSelected,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestTableRow extends StatelessWidget {
  final HelpDeskRequest request;
  final bool checked;
  final VoidCallback onToggleCheck;
  final ValueChanged<String> onActionSelected;

  const _RequestTableRow({
    required this.request,
    required this.checked,
    required this.onToggleCheck,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(bottom: BorderSide(color: AppColors.border)),
        color: checked ? AppColors.primary.withValues(alpha: 0.04) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: _RequestsTable.checkWidth,
            height: 48,
            child: Center(
              child: Checkbox(
                value: checked,
                onChanged: (_) => onToggleCheck(),
              ),
            ),
          ),
          _TableCell(
            width: _RequestsTable.requestWidth,
            child: Text(
              request.requestNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00759B),
              ),
            ),
          ),
          _TableCell(
            width: _RequestsTable.subjectWidth,
            child: Text(
              request.subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _TableCell(
            width: _RequestsTable.severityWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _SeverityPill(severity: request.severity),
            ),
          ),
          _TableCell(
            width: _RequestsTable.statusWidth,
            child: Text(
              request.status.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _TableCell(
            width: _RequestsTable.dateWidth,
            child: Text(
              _formatDate(request.lastUpdated),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _TableCell(
            width: _RequestsTable.assignedWidth,
            child: Text(
              request.assignedTo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: _RequestsTable.actionsWidth,
            height: 48,
            child: PopupMenuButton<String>(
              tooltip: 'Request actions',
              onSelected: onActionSelected,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'View', child: Text('View')),
                PopupMenuItem(value: 'Assign', child: Text('Assign')),
                PopupMenuItem(
                  value: 'Update Status',
                  child: Text('Update Status'),
                ),
              ],
              child: const Center(
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final bool sortable;

  const _HeaderCell({
    required this.label,
    required this.width,
    this.sortable = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (sortable)
              const Icon(
                Icons.unfold_more_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
          ],
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final double width;
  final Widget child;

  const _TableCell({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final hour = value.hour == 0
      ? 12
      : value.hour > 12
      ? value.hour - 12
      : value.hour;
  final minute = value.minute.toString().padLeft(2, '0');
  final period = value.hour >= 12 ? 'PM' : 'AM';
  return '${value.month}/${value.day}/${value.year.toString().substring(2)} $hour:$minute $period';
}

class RequestCard extends StatelessWidget {
  final HelpDeskRequest request;

  const RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.requestNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF00759B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.subject,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _SeverityPill(severity: request.severity),
                PopupMenuButton<String>(
                  tooltip: 'Request actions',
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'View', child: Text('View')),
                    PopupMenuItem(value: 'Assign', child: Text('Assign')),
                    PopupMenuItem(
                      value: 'Update Status',
                      child: Text('Update Status'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.flag_outlined,
                  label: request.status.label,
                ),
                _InfoChip(
                  icon: Icons.schedule_rounded,
                  label: _formatDate(request.lastUpdated),
                ),
                if (request.assignedTo.isNotEmpty)
                  _InfoChip(
                    icon: Icons.person_outline_rounded,
                    label: request.assignedTo,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text(
              '${request.categoryName} • ${request.queue}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityPill extends StatelessWidget {
  final HelpDeskSeverity severity;

  const _SeverityPill({required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = switch (severity) {
      HelpDeskSeverity.low => const Color(0xFF22C55E),
      HelpDeskSeverity.medium => const Color(0xFFF59E0B),
      HelpDeskSeverity.high => const Color(0xFFEF4444),
      HelpDeskSeverity.critical => const Color(0xFFDC2626),
    };
    final bgColor = switch (severity) {
      HelpDeskSeverity.low => const Color(0xFFDCFCE7),
      HelpDeskSeverity.medium => const Color(0xFFFEF3C7),
      HelpDeskSeverity.high => const Color(0xFFFEE2E2),
      HelpDeskSeverity.critical => const Color(0xFFFEE2E2),
    };
    final textColor = switch (severity) {
      HelpDeskSeverity.low => const Color(0xFF16A34A),
      HelpDeskSeverity.medium => const Color(0xFFD97706),
      HelpDeskSeverity.high => const Color(0xFFDC2626),
      HelpDeskSeverity.critical => const Color(0xFFB91C1C),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        severity.label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F3F8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvancedOptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AdvancedOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 20,
              color: selected ? AppColors.primary : AppColors.textPrimary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  final String title;

  const _SheetTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      alignment: Alignment.center,
      decoration: _cardDecoration(),
      child: const CircularProgressIndicator(),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Color(0x08000000), // same 4% black, no debug trigger
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );
}
