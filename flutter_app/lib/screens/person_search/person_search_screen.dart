import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_app/screens/employee_detail/employee_detail_screen.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

class PersonSearchScreen extends StatefulWidget {
  const PersonSearchScreen({super.key});

  @override
  State<PersonSearchScreen> createState() => _PersonSearchScreenState();
}

class _PersonSearchScreenState extends State<PersonSearchScreen> {
  // Basic fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  final TextEditingController _personNumberController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();

  // Advanced-only fields
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  DateTime _selectedDate = DateTime(2026, 6, 24);
  bool _isAdvancedSearch = false;
  bool _includeTerminated = false;
  int _searchResultsCount = 0;
  List<Map<String, String>> _searchResults = [];

  // All People dropdown
  String _selectedPeopleFilter = 'All People';
  final GlobalKey _allPeopleKey = GlobalKey();

  // Personalize dialog state
  bool _personSetDefault = true;
  bool _personRunAuto = false;
  bool _personShowInList = true;
  String _personalizeDropdownValue = 'All People';

  // ── Column visibility (View → Columns) ──────────────────────────
  List<String> _allColumns = [
    'Name',
    'Actions',
    'Person Number',
    'National ID',
    'Department',
    'Location',
    'User Person Type',
    'Job',
    'Assignment Name',
    'Position',
    'Primary Email',
    'Assignment Status',
    'Primary Phone',
    'Business Unit',
    'Country',
    'Town or City',
    'Assignment Number',
    'Termination Date',
    'System Person Type',
    'Worker Number',
  ];
  late Map<String, bool> _columnVisibility;

  // ── Sort config (View → Sort → Advanced) ────────────────────────
  String _sortBy1 = '';
  String _sortDir1 = 'Ascending';
  String _sortBy2 = '';
  String _sortDir2 = 'Ascending';
  String _sortBy3 = '';
  String _sortDir3 = 'Ascending';

  // GlobalKeys for positioning menus
  final GlobalKey _actionsMenuKey = GlobalKey();
  final GlobalKey _viewMenuKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _columnVisibility = {for (var col in _allColumns) col: true};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _keywordsController.dispose();
    _personNumberController.dispose();
    _nationalIdController.dispose();
    _locationController.dispose();
    _departmentController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _searchResults = [
        {
          'name': 'John Doe',
          'personNumber': 'P001',
          'nationalId': '123-45-6789',
          'department': 'Engineering',
          'location': 'New York',
          'personType': 'Staff',
          'job': 'Senior Developer',
          'assignment': 'Full-time',
          'position': 'Senior Developer',
          'primaryEmail': 'john.doe@mannai.com',
          'assignmentStatus': 'Active - Assignment',
          'primaryPhone': '+974 4444 5555',
          'businessUnit': 'Mannai Corporation',
          'country': 'Qatar',
          'townOrCity': 'Doha',
          'assignmentNumber': 'E100234',
          'terminationDate': 'N/A',
          'systemPersonType': 'Emp',
          'workerNumber': 'W0012',
        },
        {
          'name': 'Jane Smith',
          'personNumber': 'P002',
          'nationalId': '987-65-4321',
          'department': 'HR',
          'location': 'Los Angeles',
          'personType': 'Manager',
          'job': 'HR Manager',
          'assignment': 'Full-time',
          'position': 'HR Manager',
          'primaryEmail': 'jane.smith@mannai.com',
          'assignmentStatus': 'Active - Assignment',
          'primaryPhone': '+974 4444 6666',
          'businessUnit': 'Mannai Corporation',
          'country': 'Qatar',
          'townOrCity': 'Doha',
          'assignmentNumber': 'E100235',
          'terminationDate': 'N/A',
          'systemPersonType': 'Emp',
          'workerNumber': 'W0013',
        },
      ];
      _sortSearchResults();
      _searchResultsCount = _searchResults.length;
    });
  }

  void _sortSearchResults() {
    if (_searchResults.isEmpty) return;
    _searchResults.sort((a, b) {
      int cmp = 0;
      if (_sortBy1.isNotEmpty) {
        cmp = _compareRows(a, b, _sortBy1, _sortDir1);
      }
      if (cmp == 0 && _sortBy2.isNotEmpty) {
        cmp = _compareRows(a, b, _sortBy2, _sortDir2);
      }
      if (cmp == 0 && _sortBy3.isNotEmpty) {
        cmp = _compareRows(a, b, _sortBy3, _sortDir3);
      }
      return cmp;
    });
  }

  int _compareRows(
    Map<String, String> a,
    Map<String, String> b,
    String colName,
    String direction,
  ) {
    final String key = _getResultKeyForColumn(colName);
    final String valA = a[key] ?? '';
    final String valB = b[key] ?? '';
    final int comparison = valA.compareTo(valB);
    return direction == 'Ascending' ? comparison : -comparison;
  }

  String _getResultKeyForColumn(String colName) {
    switch (colName) {
      case 'Name':
        return 'name';
      case 'Person Number':
        return 'personNumber';
      case 'National ID':
        return 'nationalId';
      case 'Department':
        return 'department';
      case 'Location':
        return 'location';
      case 'User Person Type':
        return 'personType';
      case 'Job':
        return 'job';
      case 'Assignment Name':
        return 'assignment';
      case 'Position':
        return 'position';
      case 'Primary Email':
        return 'primaryEmail';
      case 'Assignment Status':
        return 'assignmentStatus';
      case 'Primary Phone':
        return 'primaryPhone';
      case 'Business Unit':
        return 'businessUnit';
      case 'Country':
        return 'country';
      case 'Town or City':
        return 'townOrCity';
      case 'Assignment Number':
        return 'assignmentNumber';
      case 'Termination Date':
        return 'terminationDate';
      case 'System Person Type':
        return 'systemPersonType';
      case 'Worker Number':
        return 'workerNumber';
      default:
        return '';
    }
  }

  void _resetSearch() {
    setState(() {
      _nameController.clear();
      _keywordsController.clear();
      _personNumberController.clear();
      _nationalIdController.clear();
      _locationController.clear();
      _departmentController.clear();
      _jobController.clear();
      _selectedDate = DateTime(2026, 6, 24);
      _includeTerminated = false;
      _searchResults = [];
      _searchResultsCount = 0;
    });
  }

  // ── All People dropdown popup ───────────────────────────────────
  void _showAllPeopleMenu() async {
    final RenderBox button =
        _allPeopleKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'All People',
          padding: EdgeInsets.zero,
          child: Container(
            color: _selectedPeopleFilter == 'All People'
                ? const Color(0xFFE8F0FC)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            child: Text(
              'All People',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _selectedPeopleFilter == 'All People'
                    ? const Color(0xFF1F4E8C)
                    : const Color(0xFF1F2937),
              ),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'Personalize',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Text(
            'Personalize...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );

    if (selected == null || !mounted) return;
    if (selected == 'Personalize') {
      _showPersonalizeDialog(context);
    } else {
      setState(() => _selectedPeopleFilter = selected);
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Actions menu (Export to Excel)
  // ════════════════════════════════════════════════════════════════════
  void _showActionsMenu() async {
    final RenderBox button =
        _actionsMenuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'export_excel',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.table_chart_outlined,
                size: 18,
                color: const Color(0xFF1F4E8C).withValues(alpha: 0.8),
              ),
              const SizedBox(width: 10),
              const Text(
                'Export to Excel',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (selected == null || !mounted) return;
    if (selected == 'export_excel') {
      _exportToExcel();
    }
  }

  // ── Export to Excel logic ───────────────────────────────────────
  Future<void> _exportToExcel() async {
    final excelFile = Excel.createExcel();
    final sheetName = 'Person Search Results';
    excelFile.rename(excelFile.getDefaultSheet()!, sheetName);
    final sheet = excelFile[sheetName];

    // Column headers matching Oracle HCM
    final headers = [
      'Name',
      'Actions',
      'Person Number',
      'National ID',
      'Department',
      'Location',
      'User Person Type',
      'Job',
      'Assignment Name',
      'Position',
      'Primary Email',
      'Assignment Status',
      'Primary Phone',
      'Business Unit',
      'Country',
      'Town or City',
      'Assignment Number',
      'Termination Date',
      'System Person Type',
      'Worker Number',
    ];

    // Write header row with styling
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
        backgroundColorHex: ExcelColor.fromHexString('#1F4E8C'),
        fontSize: 11,
      );
    }

    // Write data rows
    for (int r = 0; r < _searchResults.length; r++) {
      final row = _searchResults[r];
      final dataKeys = [
        'name',
        'actions',
        'personNumber',
        'nationalId',
        'department',
        'location',
        'personType',
        'job',
        'assignmentName',
        'position',
        'primaryEmail',
        'assignmentStatus',
        'primaryPhone',
        'businessUnit',
        'country',
        'townOrCity',
        'assignmentNumber',
        'terminationDate',
        'systemPersonType',
        'workerNumber',
      ];
      for (int c = 0; c < dataKeys.length; c++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1),
        );
        cell.value = TextCellValue(row[dataKeys[c]] ?? '');
      }
    }

    // Auto-size columns (set a reasonable default width)
    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 18);
    }

    // Save file
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/PersonSearchResults_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final fileBytes = excelFile.save();
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Excel exported to: ${file.path}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1F4E8C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Open',
              textColor: Colors.white,
              onPressed: () => OpenFile.open(filePath),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  View menu (Columns ▸, Sort ▸, Reorder Columns...)
  // ════════════════════════════════════════════════════════════════════
  void _showViewMenu() async {
    final RenderBox button =
        _viewMenuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'columns',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Columns',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
              Icon(Icons.arrow_right, size: 18, color: Color(0xFF6B7280)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'sort',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
              Icon(Icons.arrow_right, size: 18, color: Color(0xFF6B7280)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'reorder',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Text(
            'Reorder Columns...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );

    if (selected == null || !mounted) return;
    if (selected == 'columns') {
      _showColumnsSubmenu();
    } else if (selected == 'sort') {
      _showSortSubmenu();
    } else if (selected == 'reorder') {
      _showReorderColumnsDialog();
    }
  }

  // ── Columns submenu (checkable list) ───────────────────────────
  void _showColumnsSubmenu() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F4E8C),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.view_column_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Columns',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Show All ──
                  InkWell(
                    onTap: () {
                      setDialogState(() {
                        for (var col in _allColumns) {
                          _columnVisibility[col] = true;
                        }
                      });
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_rounded,
                            size: 16,
                            color: const Color(
                              0xFF1F4E8C,
                            ).withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Show All',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F4E8C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ── Column list ──
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _allColumns.length,
                      itemBuilder: (ctx2, index) {
                        final col = _allColumns[index];
                        final isVisible = _columnVisibility[col] ?? true;
                        return InkWell(
                          onTap: () {
                            setDialogState(() {
                              _columnVisibility[col] = !isVisible;
                            });
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isVisible
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked,
                                  size: 18,
                                  color: isVisible
                                      ? const Color(0xFF1F4E8C)
                                      : const Color(0xFF9CA3AF),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    col,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isVisible
                                          ? const Color(0xFF1F2937)
                                          : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // ── Manage Columns ──
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        width: double.infinity,
                        child: const Text(
                          'Manage Columns...',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F4E8C),
                          ),
                        ),
                      ),
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

  // ── Reorder Columns dialog ──────────────────────────────────────
  void _showReorderColumnsDialog() {
    final List<String> localColumns = List<String>.from(_allColumns);
    int selectedIndex = 0;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDlgState) {
            Widget buildReorderButton({
              required IconData icon,
              required VoidCallback onPressed,
            }) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(icon, size: 20, color: const Color(0xFF4B5563)),
                  onPressed: onPressed,
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reorder Columns',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(ctx).pop(),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // ── Visible Columns label ──
                    const Text(
                      'Visible Columns',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── List + Buttons row ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left List container
                        Expanded(
                          child: Container(
                            height: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFD1D5DB),
                              ),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: localColumns.length,
                              itemBuilder: (context, index) {
                                final col = localColumns[index];
                                final isSelected = selectedIndex == index;
                                return GestureDetector(
                                  onTap: () =>
                                      setDlgState(() => selectedIndex = index),
                                  child: Container(
                                    color: isSelected
                                        ? const Color(0xFFE8F0FC)
                                        : Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      col,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? const Color(0xFF1F4E8C)
                                            : const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Right Buttons Column
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildReorderButton(
                              icon: Icons.vertical_align_top_rounded,
                              onPressed: () {
                                if (selectedIndex > 0) {
                                  setDlgState(() {
                                    final item = localColumns.removeAt(
                                      selectedIndex,
                                    );
                                    localColumns.insert(0, item);
                                    selectedIndex = 0;
                                  });
                                }
                              },
                            ),
                            buildReorderButton(
                              icon: Icons.keyboard_arrow_up_rounded,
                              onPressed: () {
                                if (selectedIndex > 0) {
                                  setDlgState(() {
                                    final item = localColumns.removeAt(
                                      selectedIndex,
                                    );
                                    localColumns.insert(
                                      selectedIndex - 1,
                                      item,
                                    );
                                    selectedIndex--;
                                  });
                                }
                              },
                            ),
                            buildReorderButton(
                              icon: Icons.keyboard_arrow_down_rounded,
                              onPressed: () {
                                if (selectedIndex < localColumns.length - 1) {
                                  setDlgState(() {
                                    final item = localColumns.removeAt(
                                      selectedIndex,
                                    );
                                    localColumns.insert(
                                      selectedIndex + 1,
                                      item,
                                    );
                                    selectedIndex++;
                                  });
                                }
                              },
                            ),
                            buildReorderButton(
                              icon: Icons.vertical_align_bottom_rounded,
                              onPressed: () {
                                if (selectedIndex < localColumns.length - 1) {
                                  setDlgState(() {
                                    final item = localColumns.removeAt(
                                      selectedIndex,
                                    );
                                    localColumns.add(item);
                                    selectedIndex = localColumns.length - 1;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Bottom Action Buttons ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _dialogBtn(
                          label: 'OK',
                          onTap: () {
                            setState(() {
                              _allColumns = localColumns;
                            });
                            Navigator.of(ctx).pop();
                          },
                          filled: false,
                        ),
                        const SizedBox(width: 10),
                        _dialogBtn(
                          label: 'Cancel',
                          onTap: () => Navigator.of(ctx).pop(),
                          filled: false,
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

  // ── Sort submenu ───────────────────────────────────────────────
  void _showSortSubmenu() async {
    // Get the View button position for the submenu
    final RenderBox button =
        _viewMenuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final buttonPos = button.localToGlobal(Offset.zero, ancestor: overlay);
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPos.dx + button.size.width,
      buttonPos.dy,
      overlay.size.width - buttonPos.dx - button.size.width - 120,
      overlay.size.height - buttonPos.dy - 100,
    );

    // Get visible columns for sort options, excluding 'Actions', 'System Person Type', and 'Worker Number'
    final sortableColumns = _allColumns
        .where(
          (c) =>
              (_columnVisibility[c] ?? true) &&
              c != 'Actions' &&
              c != 'System Person Type' &&
              c != 'Worker Number',
        )
        .toList();

    final selected = await showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      items: [
        ...sortableColumns.map(
          (col) => PopupMenuItem<String>(
            value: 'sort_$col',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  _sortBy1 == col ? Icons.check_rounded : Icons.sort_rounded,
                  size: 16,
                  color: _sortBy1 == col
                      ? const Color(0xFF1F4E8C)
                      : const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 10),
                Text(
                  col,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'advanced_sort',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.tune_rounded,
                size: 16,
                color: const Color(0xFF1F4E8C).withValues(alpha: 0.8),
              ),
              const SizedBox(width: 10),
              const Text(
                'Advanced...',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F4E8C),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (selected == null || !mounted) return;
    if (selected == 'advanced_sort') {
      _showAdvancedSortDialog();
    } else if (selected.startsWith('sort_')) {
      setState(() {
        _sortBy1 = selected.replaceFirst('sort_', '');
        _sortSearchResults();
      });
    }
  }

  // ── Advanced Sort dialog ───────────────────────────────────────
  void _showAdvancedSortDialog() {
    String localSort1 = _sortBy1;
    String localDir1 = _sortDir1;
    String localSort2 = _sortBy2;
    String localDir2 = _sortDir2;
    String localSort3 = _sortBy3;
    String localDir3 = _sortDir3;

    final sortableColumns = [
      '',
      ..._allColumns.where(
        (c) =>
            c != 'Actions' && c != 'System Person Type' && c != 'Worker Number',
      ),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Widget buildSortRow({
              required String label,
              required String selectedCol,
              required String selectedDir,
              required ValueChanged<String?> onColChanged,
              required ValueChanged<String?> onDirChanged,
            }) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCol,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF6B7280),
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1F2937),
                              ),
                              items: sortableColumns
                                  .map(
                                    (col) => DropdownMenuItem(
                                      value: col,
                                      child: Text(
                                        col.isEmpty ? '(None)' : col,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: col.isEmpty
                                              ? const Color(0xFF9CA3AF)
                                              : const Color(0xFF1F2937),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: onColChanged,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _radioOption(
                              label: 'Ascending',
                              value: 'Ascending',
                              groupValue: selectedDir,
                              onChanged: onDirChanged,
                              setDialogState: setDialogState,
                            ),
                            _radioOption(
                              label: 'Descending',
                              value: 'Descending',
                              groupValue: selectedDir,
                              onChanged: onDirChanged,
                              setDialogState: setDialogState,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F4E8C),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sort_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Advanced Sort',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Body ──
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        buildSortRow(
                          label: 'Sort By',
                          selectedCol: localSort1,
                          selectedDir: localDir1,
                          onColChanged: (v) =>
                              setDialogState(() => localSort1 = v ?? ''),
                          onDirChanged: (v) => setDialogState(
                            () => localDir1 = v ?? 'Ascending',
                          ),
                        ),
                        const SizedBox(height: 18),
                        buildSortRow(
                          label: 'Then By',
                          selectedCol: localSort2,
                          selectedDir: localDir2,
                          onColChanged: (v) =>
                              setDialogState(() => localSort2 = v ?? ''),
                          onDirChanged: (v) => setDialogState(
                            () => localDir2 = v ?? 'Ascending',
                          ),
                        ),
                        const SizedBox(height: 18),
                        buildSortRow(
                          label: 'Then By',
                          selectedCol: localSort3,
                          selectedDir: localDir3,
                          onColChanged: (v) =>
                              setDialogState(() => localSort3 = v ?? ''),
                          onDirChanged: (v) => setDialogState(
                            () => localDir3 = v ?? 'Ascending',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Footer ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _sortBy1 = localSort1;
                              _sortDir1 = localDir1;
                              _sortBy2 = localSort2;
                              _sortDir2 = localDir2;
                              _sortBy3 = localSort3;
                              _sortDir3 = localDir3;
                              _sortSearchResults();
                            });
                            Navigator.pop(ctx);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1F4E8C),
                            side: const BorderSide(color: Color(0xFF1F4E8C)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  // ── Radio button helper for sort dialog ─────────────────────────
  Widget _radioOption({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required StateSetter setDialogState,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Radio<String>(
                value: value,
                // ignore: deprecated_member_use
                groupValue: groupValue,
                activeColor: const Color(0xFF1F4E8C),
                // ignore: deprecated_member_use
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Personalize Saved Searches dialog ──────────────────────────
  void _showPersonalizeDialog(BuildContext context) {
    bool localSetDefault = _personSetDefault;
    bool localRunAuto = _personRunAuto;
    bool localShowInList = _personShowInList;
    String localDropdown = _personalizeDropdownValue;
    bool dropdownOpen = false;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDlgState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Dialog title row ──────────────────────────
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Personalize Saved Searches',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(ctx).pop(),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Saved Searches label ──────────────────────
                    const Text(
                      'Saved Searches',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Dropdown ─────────────────────────────────
                    _buildPersonalizeDropdown(
                      value: localDropdown,
                      isOpen: dropdownOpen,
                      onToggle: () =>
                          setDlgState(() => dropdownOpen = !dropdownOpen),
                      onSelect: (val) => setDlgState(() {
                        localDropdown = val;
                        dropdownOpen = false;
                      }),
                    ),
                    const SizedBox(height: 24),

                    // ── Checkboxes ────────────────────────────────
                    // Set as Default
                    GestureDetector(
                      onTap: () =>
                          setDlgState(() => localSetDefault = !localSetDefault),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: localSetDefault,
                              activeColor: const Color(0xFF1F4E8C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              onChanged: (v) => setDlgState(
                                () => localSetDefault = v ?? false,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Set as Default',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Run Automatically (dash = indeterminate / disabled look)
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFBDBDBD),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(3),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: const Center(
                            child: Text(
                              '—',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF757575),
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Run Automatically',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Show in Search List (greyed-out checked)
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: localShowInList,
                            activeColor: const Color(0xFF9CA3AF),
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            onChanged: null, // greyed out
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Show in Search List',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Action buttons ────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _dialogBtn(
                          label: 'Apply',
                          onTap: () {
                            setState(() {
                              _personSetDefault = localSetDefault;
                              _personRunAuto = localRunAuto;
                              _personShowInList = localShowInList;
                              _personalizeDropdownValue = localDropdown;
                              _selectedPeopleFilter = localDropdown;
                            });
                          },
                          filled: false,
                        ),
                        const SizedBox(width: 8),
                        _dialogBtn(
                          label: 'OK',
                          onTap: () {
                            setState(() {
                              _personSetDefault = localSetDefault;
                              _personRunAuto = localRunAuto;
                              _personShowInList = localShowInList;
                              _personalizeDropdownValue = localDropdown;
                              _selectedPeopleFilter = localDropdown;
                            });
                            Navigator.of(ctx).pop();
                          },
                          filled: false,
                        ),
                        const SizedBox(width: 8),
                        _dialogBtn(
                          label: 'Cancel',
                          onTap: () => Navigator.of(ctx).pop(),
                          filled: false,
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

  /// Inline dropdown widget used inside the dialog
  Widget _buildPersonalizeDropdown({
    required String value,
    required bool isOpen,
    required VoidCallback onToggle,
    required ValueChanged<String> onSelect,
  }) {
    const options = ['All People'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isOpen
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                  : BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBDBDBD)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: const Color(0xFF6B7280),
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(color: const Color(0xFFBDBDBD)),
            ),
            child: Column(
              children: options
                  .map(
                    (opt) => GestureDetector(
                      onTap: () => onSelect(opt),
                      child: Container(
                        color: opt == value
                            ? const Color(0xFFE8F0FC)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        width: double.infinity,
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: opt == value
                                ? const Color(0xFF1F4E8C)
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  /// Generic bordered button for the dialog footer
  Widget _dialogBtn({
    required String label,
    required VoidCallback onTap,
    required bool filled,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1F4E8C),
        backgroundColor: filled ? const Color(0xFF1F4E8C) : Colors.white,
        side: const BorderSide(color: Color(0xFFBDBDBD)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: filled ? Colors.white : const Color(0xFF1F4E8C),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Shared Header ───────────────────────────────────────────
            const AppHeaderWidget(
              title: 'Person Management',
              showBack: true,
            ),

            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Search Form Card ────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Card header row ─────────────────────────
                        _buildSearchCardHeader(isSmallScreen),
                        const SizedBox(height: 16),

                        // ── Mode sub-header (Advanced mode title + collapse) ─
                        if (_isAdvancedSearch) _buildAdvancedModeHeader(),

                        const SizedBox(height: 4),

                        // ── Required legend ─────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '* Required',
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '** At least one is required',
                              style: TextStyle(
                                color: const Color(
                                  0xFF1F4E8C,
                                ).withValues(alpha: 0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ── Form Fields ──────────────────────────────
                        _isAdvancedSearch
                            ? _buildAdvancedFormFields(isSmallScreen)
                            : _buildBasicFormFields(isSmallScreen),

                        const SizedBox(height: 24),

                        // ── Action Buttons ───────────────────────────
                        _isAdvancedSearch
                            ? _buildAdvancedButtons(isSmallScreen)
                            : _buildBasicButtons(isSmallScreen),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Search Results Card ──────────────────────────────
                  _buildSearchResultsCard(isSmallScreen),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  Card header with Basic / Advanced / Saved Search / All People
  // ════════════════════════════════════════════════════════════════════
  Widget _buildSearchCardHeader(bool isSmallScreen) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Color(0xFF1F4E8C),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Search People',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4E8C),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Tab-style row: Basic | Advanced | Saved Search | All People ▾
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Basic tab (active when not advanced)
              _buildTabButton(
                label: 'Basic',
                isActive: !_isAdvancedSearch,
                onTap: () => setState(() => _isAdvancedSearch = false),
              ),
              const SizedBox(width: 4),
              // Advanced tab (active when advanced)
              _buildTabButton(
                label: 'Advanced',
                isActive: _isAdvancedSearch,
                onTap: () => setState(() => _isAdvancedSearch = true),
                trailingIcon: _isAdvancedSearch
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                ),
                child: const Text(
                  'Saved Search',
                  style: TextStyle(
                    color: Color(0xFF1F4E8C),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                key: _allPeopleKey,
                onTap: () => _showAllPeopleMenu(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedPeopleFilter,
                        style: const TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    IconData? trailingIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1F4E8C) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF1F4E8C) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : const Color(0xFF1F4E8C),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 2),
              Icon(
                trailingIcon,
                size: 16,
                color: isActive ? Colors.white : const Color(0xFF1F4E8C),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  Advanced Mode title bar with collapse arrow
  // ════════════════════════════════════════════════════════════════════
  Widget _buildAdvancedModeHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1E3F8)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF1F4E8C)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Advanced Search',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F4E8C),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isAdvancedSearch = false),
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 20,
              color: Color(0xFF1F4E8C),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  Basic form fields
  // ════════════════════════════════════════════════════════════════════
  Widget _buildBasicFormFields(bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        children: [
          _buildFormField(
            label: '** Name',
            controller: _nameController,
            hintText: 'Enter name',
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: '** Keywords',
            controller: _keywordsController,
            hintText: 'Enter keywords',
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: '** Person Number',
            controller: _personNumberController,
            hintText: 'Enter person number',
          ),
          const SizedBox(height: 16),
          _buildDateField(),
          const SizedBox(height: 16),
          _buildFormField(
            label: '** National ID',
            controller: _nationalIdController,
            hintText: 'Enter national ID',
          ),
        ],
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: '** Name',
                controller: _nameController,
                hintText: 'Enter name',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFormField(
                label: '** Keywords',
                controller: _keywordsController,
                hintText: 'Enter keywords',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: '** Person Number',
                controller: _personNumberController,
                hintText: 'Enter person number',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildDateField()),
          ],
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: '** National ID',
          controller: _nationalIdController,
          hintText: 'Enter national ID',
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  Advanced form fields  (all basic + Location, Department, Job,
  //  Include terminated checkbox)
  // ════════════════════════════════════════════════════════════════════
  Widget _buildAdvancedFormFields(bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: '** Name',
            controller: _nameController,
            hintText: 'Enter name',
          ),
          const SizedBox(height: 14),
          _buildFormField(
            label: '** Person Number',
            controller: _personNumberController,
            hintText: 'Enter person number',
          ),
          const SizedBox(height: 14),
          _buildFormField(
            label: '** National ID',
            controller: _nationalIdController,
            hintText: 'Enter national ID',
          ),
          const SizedBox(height: 14),
          _buildFormField(
            label: '** Keywords',
            controller: _keywordsController,
            hintText: 'Enter keywords',
          ),
          const SizedBox(height: 14),
          _buildDropdownField(
            label: '** Location',
            hintText: 'Select location',
            controller: _locationController,
          ),
          const SizedBox(height: 14),
          _buildDropdownField(
            label: '** Department',
            hintText: 'Select department',
            controller: _departmentController,
          ),
          const SizedBox(height: 14),
          _buildDropdownField(
            label: '** Job',
            hintText: 'Select job',
            controller: _jobController,
          ),
          const SizedBox(height: 14),
          _buildDateField(),
          const SizedBox(height: 14),
          _buildIncludeTerminatedCheckbox(),
        ],
      );
    }

    // Two-column layout for wider screens
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildFormField(
                    label: '** Name',
                    controller: _nameController,
                    hintText: 'Enter name',
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    label: '** Person Number',
                    controller: _personNumberController,
                    hintText: 'Enter person number',
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    label: '** National ID',
                    controller: _nationalIdController,
                    hintText: 'Enter national ID',
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    label: '** Keywords',
                    controller: _keywordsController,
                    hintText: 'Enter keywords',
                  ),
                  const SizedBox(height: 14),
                  _buildDropdownField(
                    label: '** Location',
                    hintText: 'Select location',
                    controller: _locationController,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(
                    label: '** Department',
                    hintText: 'Select department',
                    controller: _departmentController,
                  ),
                  const SizedBox(height: 14),
                  _buildDropdownField(
                    label: '** Job',
                    hintText: 'Select job',
                    controller: _jobController,
                  ),
                  const SizedBox(height: 14),
                  _buildIncludeTerminatedCheckbox(),
                  const SizedBox(height: 14),
                  _buildDateField(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  Basic action buttons
  // ════════════════════════════════════════════════════════════════════
  Widget _buildBasicButtons(bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _outlineBtn('Reset', _resetSearch)),
              const SizedBox(width: 12),
              Expanded(child: _outlineBtn('Save...', () {})),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _primaryBtn('Search', _performSearch),
          ),
        ],
      );
    }
    return Row(
      children: [
        _outlineBtn('Reset', _resetSearch, hPad: 24),
        const SizedBox(width: 12),
        _outlineBtn('Save...', () {}, hPad: 24),
        const Spacer(),
        _primaryBtn('Search', _performSearch, hPad: 36),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  Advanced action buttons (Search, Reset, Save…, Add Fields ▾, Reorder)
  // ════════════════════════════════════════════════════════════════════
  Widget _buildAdvancedButtons(bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _primaryBtn('Search', _performSearch)),
              const SizedBox(width: 10),
              Expanded(child: _outlineBtn('Reset', _resetSearch)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _outlineBtn('Save...', () {})),
              const SizedBox(width: 10),
              Expanded(
                child: _outlineBtn(
                  'Add Fields',
                  () {},
                  trailingIcon: Icons.arrow_drop_down,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: _outlineBtn(
              'Reorder',
              () {},
              leadingIcon: Icons.swap_vert_rounded,
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _primaryBtn('Search', _performSearch, hPad: 28),
        _outlineBtn('Reset', _resetSearch, hPad: 20),
        _outlineBtn('Save...', () {}, hPad: 20),
        _outlineBtn(
          'Add Fields',
          () {},
          hPad: 20,
          trailingIcon: Icons.arrow_drop_down,
        ),
        _outlineBtn(
          'Reorder',
          () {},
          hPad: 20,
          leadingIcon: Icons.swap_vert_rounded,
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  Search Results Card
  // ════════════════════════════════════════════════════════════════════
  Widget _buildSearchResultsCard(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.list_alt_rounded,
                  color: Color(0xFF1F4E8C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Search Results ($_searchResultsCount)',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4E8C),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.help_outline_rounded,
                color: Color(0xFF7B8B9B),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action menu bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton.icon(
                  key: _actionsMenuKey,
                  onPressed: _showActionsMenu,
                  icon: const Icon(Icons.arrow_drop_down, size: 14),
                  label: const Text(
                    'Actions',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1F4E8C),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                TextButton.icon(
                  key: _viewMenuKey,
                  onPressed: _showViewMenu,
                  icon: const Icon(Icons.arrow_drop_down, size: 14),
                  label: const Text(
                    'View',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1F4E8C),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_drop_down, size: 14),
                  label: const Text(
                    'Format',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1F4E8C),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.grid_on_rounded,
                  size: 16,
                  color: Color(0xFF1F4E8C),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Data table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: isSmallScreen ? 16 : 24,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFEEF5FC)),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              columns: _allColumns
                  .where((col) => _columnVisibility[col] == true)
                  .map(
                    (col) => DataColumn(
                      label: Text(
                        col,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF1F4E8C),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: _searchResults.isEmpty
                  ? [
                      DataRow(
                        cells: List.generate(
                          _allColumns
                              .where((col) => _columnVisibility[col] == true)
                              .length,
                          (index) => index == 0
                              ? const DataCell(
                                  Text(
                                    'No search conducted.',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : const DataCell(SizedBox()),
                        ),
                      ),
                    ]
                  : _searchResults
                        .map(
                          (result) => DataRow(
                            cells: _allColumns
                                .where((col) => _columnVisibility[col] == true)
                                .map((col) {
                                  switch (col) {
                                    case 'Name':
                                      return DataCell(
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EmployeeDetailScreen(
                                                    employee: result,
                                                  ),
                                            ),
                                          ),
                                          child: Text(
                                            result['name'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1F4E8C),
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    case 'Actions':
                                      return const DataCell(
                                        Icon(
                                          Icons.more_vert,
                                          size: 18,
                                          color: Color(0xFF6B7280),
                                        ),
                                      );
                                    case 'Person Number':
                                      return DataCell(
                                        Text(
                                          result['personNumber'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'National ID':
                                      return DataCell(
                                        Text(
                                          result['nationalId'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Department':
                                      return DataCell(
                                        Text(
                                          result['department'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Location':
                                      return DataCell(
                                        Text(
                                          result['location'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'User Person Type':
                                      return DataCell(
                                        Text(
                                          result['personType'] ?? 'Employee',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Job':
                                      return DataCell(
                                        Text(
                                          result['job'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Assignment Name':
                                      return DataCell(
                                        Text(
                                          result['assignment'] ?? 'Regular',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Position':
                                      return DataCell(
                                        Text(
                                          result['position'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Primary Email':
                                      return DataCell(
                                        Text(
                                          result['primaryEmail'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Assignment Status':
                                      return DataCell(
                                        Text(
                                          result['assignmentStatus'] ??
                                              'Active',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Primary Phone':
                                      return DataCell(
                                        Text(
                                          result['primaryPhone'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Business Unit':
                                      return DataCell(
                                        Text(
                                          result['businessUnit'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Country':
                                      return DataCell(
                                        Text(
                                          result['country'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Town or City':
                                      return DataCell(
                                        Text(
                                          result['townOrCity'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Assignment Number':
                                      return DataCell(
                                        Text(
                                          result['assignmentNumber'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Termination Date':
                                      return DataCell(
                                        Text(
                                          result['terminationDate'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'System Person Type':
                                      return DataCell(
                                        Text(
                                          result['systemPersonType'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    case 'Worker Number':
                                      return DataCell(
                                        Text(
                                          result['workerNumber'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      );
                                    default:
                                      return const DataCell(Text(''));
                                  }
                                })
                                .toList(),
                          ),
                        )
                        .toList(),
            ),
          ),
        ],
      ),
    );
  }


  // ════════════════════════════════════════════════════════════════════
  //  Reusable field widgets
  // ════════════════════════════════════════════════════════════════════
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
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
              borderSide: const BorderSide(
                color: Color(0xFF1F4E8C),
                width: 1.5,
              ),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
        ),
      ],
    );
  }

  /// Dropdown-style field (shows a down-arrow icon; no real dropdown menu yet)
  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF6B7280),
            ),
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
              borderSide: const BorderSide(
                color: Color(0xFF1F4E8C),
                width: 1.5,
              ),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
        ),
      ],
    );
  }

  Widget _buildIncludeTerminatedCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _includeTerminated = !_includeTerminated),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: _includeTerminated,
              activeColor: const Color(0xFF1F4E8C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (val) =>
                  setState(() => _includeTerminated = val ?? false),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Include terminated work relationships',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '* Effective As-of Date',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() => _selectedDate = pickedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year.toString().substring(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Button helpers ───────────────────────────────────────────────
  Widget _primaryBtn(String label, VoidCallback onTap, {double hPad = 0}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1F4E8C),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: hPad > 0 ? hPad : 14,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _outlineBtn(
    String label,
    VoidCallback onTap, {
    double hPad = 0,
    IconData? trailingIcon,
    IconData? leadingIcon,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1F4E8C),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        padding: EdgeInsets.symmetric(
          horizontal: hPad > 0 ? hPad : 14,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 15),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(trailingIcon, size: 15),
          ],
        ],
      ),
    );
  }
}
