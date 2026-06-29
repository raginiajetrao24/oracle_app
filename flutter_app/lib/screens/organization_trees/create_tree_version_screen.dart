import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/models/organization_tree_model.dart';

// ─── Node model ───────────────────────────────────────────────────────────────

class _NodeRow {
  final String nodeName;
  final String nodeDescription;
  final String label;
  final String dataSource;

  const _NodeRow({
    required this.nodeName,
    required this.nodeDescription,
    required this.label,
    required this.dataSource,
  });
}

class CreateTreeVersionScreen extends StatefulWidget {
  final OrgTree? selectedTree;
  const CreateTreeVersionScreen({super.key, this.selectedTree});

  @override
  State<CreateTreeVersionScreen> createState() =>
      _CreateTreeVersionScreenState();
}

class _CreateTreeVersionScreenState extends State<CreateTreeVersionScreen> {
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _effectiveStartDate = DateTime.now();
  DateTime? _effectiveEndDate;
  String _status = 'Draft';

  final _formKey = GlobalKey<FormState>();

  // Node table state
  final List<_NodeRow> _nodes = [];

  // Column visibility state (initial matching the screenshot: Node Name unchecked/false, rest checked/true)
  final Map<String, bool> _columnVisibility = {
    'Node Name': false,
    'Data Source': true,
    'Label': true,
    'Node Description': true,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String get _treeName => widget.selectedTree?.name ?? '';
  String get _treeCode => widget.selectedTree?.code ?? '';
  String get _treeStructureCode => widget.selectedTree?.structure ?? '';

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart
        ? (_effectiveStartDate ?? DateTime.now())
        : (_effectiveEndDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _effectiveStartDate = picked;
        } else {
          _effectiveEndDate = picked;
        }
      });
    }
  }

  void _onNext() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus();
        setState(() => _currentStep = 1);
      }
    }
  }

  void _onPrevious() {
    FocusScope.of(context).unfocus();
    setState(() => _currentStep = 0);
  }

  void _onBack() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _onSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tree version created successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF16A34A),
      ),
    );
    Navigator.pop(context);
  }

  void _onCancel() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _showAddNodeDialog() {
    String nodeType =
        'Specific value'; // 'Specific value' or 'Referenced hierarchy'
    String selectedDataSource = 'Organization Tree Data Source';
    String selectedReferencedTree = 'Recruiting Organization Tree';
    String selectedReferencedTreeVersion = 'Recruiting Tree - version 1';

    // Predefined nodes to search
    final List<_NodeRow> searchResults = [
      const _NodeRow(
        nodeName: 'Supremo Global HQ',
        nodeDescription: 'Global Headquarters',
        label: 'HQ',
        dataSource: 'Organization Tree Data Source',
      ),
      const _NodeRow(
        nodeName: 'US Sales Division',
        nodeDescription: 'US Sales Operations',
        label: 'US-SALES',
        dataSource: 'Organization Tree Data Source',
      ),
      const _NodeRow(
        nodeName: 'EMEA Operations',
        nodeDescription: 'Europe, Middle East & Africa Operations',
        label: 'EMEA-OPS',
        dataSource: 'Organization Tree Data Source',
      ),
      const _NodeRow(
        nodeName: 'HR Operations',
        nodeDescription: 'Human Resources Department',
        label: 'HR-OPS',
        dataSource: 'Organization Tree Data Source',
      ),
    ];

    _NodeRow? selectedSearchResult;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Tree Node',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 16),

                    // Tree Node Type selection
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 130,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Tree Node Type',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    nodeType = 'Specific value';
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Specific value',
                                      groupValue: nodeType,
                                      activeColor: AppColors.secondary,
                                      onChanged: (val) {
                                        setDialogState(() {
                                          nodeType = val!;
                                        });
                                      },
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Specific value',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    nodeType = 'Referenced hierarchy';
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Referenced hierarchy',
                                      groupValue: nodeType,
                                      activeColor: AppColors.secondary,
                                      onChanged: (val) {
                                        setDialogState(() {
                                          nodeType = val!;
                                        });
                                      },
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Values from referenced hierarchy',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Conditional details
                    if (nodeType == 'Specific value') ...[
                      // Data Source Row
                      Row(
                        children: [
                          const SizedBox(
                            width: 130,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Data Source',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDataSource,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Organization Tree Data Source',
                                      child: Text(
                                        'Organization Tree Data Source',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Location Data Source',
                                      child: Text('Location Data Source'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Department Data Source',
                                      child: Text('Department Data Source'),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        selectedDataSource = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tree Node Details + Search Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tree Node Details',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textHeading,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Show search and selection list
                              final selected = await showDialog<_NodeRow>(
                                context: context,
                                builder: (context) => SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  title: const Text(
                                    'Select a Node Record',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  children: searchResults.map((r) {
                                    return SimpleDialogOption(
                                      onPressed: () =>
                                          Navigator.pop(context, r),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 4,
                                        ),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: AppColors.border,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              r.nodeName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Description: ${r.nodeDescription}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            Text(
                                              'Label: ${r.label} | Source: ${r.dataSource}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                              if (selected != null) {
                                setDialogState(() {
                                  selectedSearchResult = selected;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.textPrimary,
                              elevation: 0,
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: AppColors.border),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Search',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Display Selected Search Result details
                      if (selectedSearchResult != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _dialogReadOnlyRow(
                                'Node Name',
                                selectedSearchResult!.nodeName,
                              ),
                              const SizedBox(height: 6),
                              _dialogReadOnlyRow(
                                'Description',
                                selectedSearchResult!.nodeDescription,
                              ),
                              const SizedBox(height: 6),
                              _dialogReadOnlyRow(
                                'Label',
                                selectedSearchResult!.label,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No node selected. Click Search to select.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ] else ...[
                      // Values from referenced hierarchy Tab
                      const Text(
                        'Tree Node Details',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textHeading,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Referenced Tree Row
                      Row(
                        children: [
                          const SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Referenced Tree',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedReferencedTree,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Recruiting Organization Tree',
                                      child: Text(
                                        'Recruiting Organization Tree',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'OTL_TREE',
                                      child: Text('OTL_TREE'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Project Organization Hierarchy',
                                      child: Text(
                                        'Project Organization Hierarchy',
                                      ),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        selectedReferencedTree = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Referenced Tree Version Row
                      Row(
                        children: [
                          const SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Referenced Tree Version',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedReferencedTreeVersion,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Recruiting Tree - version 1',
                                      child: Text(
                                        'Recruiting Tree - version 1',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Recruiting Tree - version 2',
                                      child: Text(
                                        'Recruiting Tree - version 2',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Project Org V1',
                                      child: Text('Project Org V1'),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        selectedReferencedTreeVersion = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (nodeType == 'Specific value') {
                              if (selectedSearchResult != null) {
                                setState(() {
                                  _nodes.add(selectedSearchResult!);
                                });
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please search and select a node record first.',
                                    ),
                                  ),
                                );
                              }
                            } else {
                              // Add a mock node corresponding to the referenced hierarchy
                              setState(() {
                                _nodes.add(
                                  _NodeRow(
                                    nodeName: 'Ref: $selectedReferencedTree',
                                    nodeDescription:
                                        'Referenced Tree: $selectedReferencedTree (Version: $selectedReferencedTreeVersion)',
                                    label: 'REF-NODE',
                                    dataSource: 'Referenced Hierarchy',
                                  ),
                                );
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
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
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateNodeDialog() {
    String selectedDataSource = 'Organization Tree Data Source';
    final treeVersion = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : 'demo';
    final treeName =
        widget.selectedTree?.name ?? 'Recruiting Organization Tree';
    final treeStructure =
        widget.selectedTree?.structure ??
        'HCM Organization Hierarchy Tree Structure';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create Tree Node',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 16),

                    // Selected Node + Next Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selected Node',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Proceeding to next step of node record creation (Mock)',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.border),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Click Next to create a new record for selected data source.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Data Source dropdown
                    Row(
                      children: [
                        const SizedBox(
                          width: 140,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '*',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Data Source',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedDataSource,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Organization Tree Data Source',
                                    child: Text(
                                      'Organization Tree Data Source',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Location Data Source',
                                    child: Text('Location Data Source'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Department Data Source',
                                    child: Text('Department Data Source'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() {
                                      selectedDataSource = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Tree Version Row
                    _dialogReadOnlyRow('Tree Version', treeVersion),
                    const SizedBox(height: 14),

                    // Tree Row
                    _dialogReadOnlyRow('Tree', treeName),
                    const SizedBox(height: 14),

                    // Tree Structure Row
                    _dialogReadOnlyRow('Tree Structure', treeStructure),

                    const SizedBox(height: 24),

                    // Bottom OK and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Create a dummy node and add to nodes list
                            setState(() {
                              _nodes.add(
                                _NodeRow(
                                  nodeName: 'New Org Node',
                                  nodeDescription:
                                      'Created Node for $selectedDataSource',
                                  label: 'NEW-NODE',
                                  dataSource: selectedDataSource,
                                ),
                              );
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
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
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dialogReadOnlyRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Create Tree Version',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          _StepperHeader(currentStep: _currentStep),
          _ActionBar(
            currentStep: _currentStep,
            onBack: _onBack,
            onNext: _onNext,
            onPrevious: _onPrevious,
            onSubmit: _onSubmit,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _currentStep == 0
                  ? _SpecifyDefinitionStep(
                      key: const ValueKey('step0'),
                      formKey: _formKey,
                      treeName: _treeName,
                      treeCode: _treeCode,
                      treeStructureCode: _treeStructureCode,
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      noteController: _noteController,
                      effectiveStartDate: _effectiveStartDate,
                      effectiveEndDate: _effectiveEndDate,
                      status: _status,
                      onPickStartDate: () => _pickDate(isStart: true),
                      onPickEndDate: () => _pickDate(isStart: false),
                      onStatusChanged: (v) =>
                          setState(() => _status = v ?? 'Draft'),
                      formatDate: _formatDate,
                    )
                  : _SpecifyNodesStep(
                      key: const ValueKey('step1'),
                      treeName: _treeName,
                      treeCode: _treeCode,
                      treeStructure: _treeStructureCode,
                      versionName: _nameController.text,
                      nodes: _nodes,
                      onAddNode: _showAddNodeDialog,
                      onCreateNode: _showCreateNodeDialog,
                      onDeleteNode: (i) => setState(() => _nodes.removeAt(i)),
                      columnVisibility: _columnVisibility,
                      onColumnVisibilityChanged: (colName, isVisible) {
                        setState(() {
                          _columnVisibility[colName] = isVisible;
                        });
                      },
                      onShowAllColumns: () {
                        setState(() {
                          _columnVisibility.updateAll((key, val) => true);
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stepper Header ───────────────────────────────────────────────────────────

class _StepperHeader extends StatelessWidget {
  final int currentStep;
  const _StepperHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          _StepCircle(
            index: 0,
            label: 'Specify\nDefinition',
            currentStep: currentStep,
          ),
          _StepConnector(isCompleted: currentStep > 0),
          _StepCircle(
            index: 1,
            label: 'Specify\nNodes',
            currentStep: currentStep,
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final String label;
  final int currentStep;

  const _StepCircle({
    required this.index,
    required this.label,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = currentStep > index;
    final isActive = currentStep == index;

    final Color bgColor = isCompleted
        ? const Color(0xFF16A34A)
        : isActive
        ? AppColors.primary
        : Colors.white;

    final Color borderColor = isCompleted
        ? const Color(0xFF16A34A)
        : isActive
        ? AppColors.primary
        : const Color(0xFFD1D5DB);

    final Widget circleChild = isCompleted
        ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
        : Text(
            '${index + 1}',
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: circleChild,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? AppColors.primary
                : isCompleted
                ? const Color(0xFF16A34A)
                : const Color(0xFF9CA3AF),
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isCompleted;
  const _StepConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 2,
        decoration: BoxDecoration(
          color: isCompleted
              ? const Color(0xFF16A34A)
              : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ),
  );
}

// ─── Action Bar ───────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack, onNext, onPrevious, onSubmit;

  const _ActionBar({
    required this.currentStep,
    required this.onBack,
    required this.onNext,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          if (currentStep == 0)
            _OutlineBtn(
              label: 'Back',
              icon: Icons.chevron_left_rounded,
              onPressed: onBack,
            )
          else
            _OutlineBtn(
              label: 'Previous',
              icon: Icons.chevron_left_rounded,
              onPressed: onPrevious,
            ),
          const Spacer(),
          if (currentStep == 0)
            _FilledBtn(
              label: 'Next',
              trailingIcon: Icons.chevron_right_rounded,
              onPressed: onNext,
            )
          else
            _FilledBtn(
              label: 'Submit',
              trailingIcon: Icons.check_rounded,
              onPressed: onSubmit,
              color: const Color(0xFF16A34A),
            ),
        ],
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _OutlineBtn({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

class _FilledBtn extends StatelessWidget {
  final String label;
  final IconData trailingIcon;
  final VoidCallback onPressed;
  final Color? color;

  const _FilledBtn({
    required this.label,
    required this.trailingIcon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        Icon(trailingIcon, size: 16),
      ],
    ),
  );
}

// ─── Step 1: Specify Definition ───────────────────────────────────────────────

class _SpecifyDefinitionStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String treeName, treeCode, treeStructureCode;
  final TextEditingController nameController,
      descriptionController,
      noteController;
  final DateTime? effectiveStartDate, effectiveEndDate;
  final String status;
  final VoidCallback onPickStartDate, onPickEndDate;
  final ValueChanged<String?> onStatusChanged;
  final String Function(DateTime?) formatDate;

  const _SpecifyDefinitionStep({
    super.key,
    required this.formKey,
    required this.treeName,
    required this.treeCode,
    required this.treeStructureCode,
    required this.nameController,
    required this.descriptionController,
    required this.noteController,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.status,
    required this.onPickStartDate,
    required this.onPickEndDate,
    required this.onStatusChanged,
    required this.formatDate,
  });

  InputDecoration _inputDeco(String? hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 13),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDC2626)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              child: Column(
                children: [
                  _ReadOnlyRow(label: 'Tree Name', value: treeName),
                  const SizedBox(height: 12),
                  _ReadOnlyRow(label: 'Tree Code', value: treeCode),
                  const SizedBox(height: 12),
                  _ReadOnlyRow(
                    label: 'Tree Structure Code',
                    value: treeStructureCode,
                    valueColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Version Details',
              child: Column(
                children: [
                  _FieldLabel(label: 'Name', isRequired: true),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: nameController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                    decoration: _inputDeco('Enter version name'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(label: 'Description'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: _inputDeco('Enter description'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(label: 'Note'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: _inputDeco('Enter note'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Effective Period & Status',
              child: Column(
                children: [
                  _FieldLabel(label: 'Effective Start Date', isRequired: true),
                  const SizedBox(height: 6),
                  _DatePickerField(
                    value: formatDate(effectiveStartDate),
                    hint: 'Select start date',
                    onTap: onPickStartDate,
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(label: 'Effective End Date'),
                  const SizedBox(height: 6),
                  _DatePickerField(
                    value: formatDate(effectiveEndDate),
                    hint: 'Select end date (optional)',
                    onTap: onPickEndDate,
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(label: 'Status'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: _inputDeco(null),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Draft', child: Text('Draft')),
                      DropdownMenuItem(value: 'Active', child: Text('Active')),
                      DropdownMenuItem(
                        value: 'Inactive',
                        child: Text('Inactive'),
                      ),
                    ],
                    onChanged: onStatusChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Step 2: Specify Nodes ────────────────────────────────────────────────────

class _SpecifyNodesStep extends StatelessWidget {
  final String treeName, treeCode, treeStructure, versionName;
  final List<_NodeRow> nodes;
  final VoidCallback onAddNode;
  final VoidCallback onCreateNode;
  final void Function(int) onDeleteNode;
  final Map<String, bool> columnVisibility;
  final void Function(String, bool) onColumnVisibilityChanged;
  final VoidCallback onShowAllColumns;

  const _SpecifyNodesStep({
    super.key,
    required this.treeName,
    required this.treeCode,
    required this.treeStructure,
    required this.versionName,
    required this.nodes,
    required this.onAddNode,
    required this.onCreateNode,
    required this.onDeleteNode,
    required this.columnVisibility,
    required this.onColumnVisibilityChanged,
    required this.onShowAllColumns,
  });

  Widget _buildMenuItem(
    String label,
    IconData icon, {
    bool disabled = false,
    VoidCallback? onPressed,
  }) {
    return MenuItemButton(
      onPressed: disabled ? null : (onPressed ?? () {}),
      leadingIcon: Icon(
        icon,
        size: 16,
        color: disabled ? const Color(0xFFB0BEC5) : AppColors.textPrimary,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: disabled ? const Color(0xFFB0BEC5) : AppColors.textPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tree summary card
          _SectionCard(
            title: 'Tree Information',
            child: Column(
              children: [
                _ReadOnlyRow(
                  label: 'Version Name',
                  value: versionName.isEmpty ? '-' : versionName,
                ),
                const SizedBox(height: 12),
                _ReadOnlyRow(
                  label: 'Tree Name',
                  value: treeName.isEmpty ? '-' : treeName,
                ),
                const SizedBox(height: 12),
                _ReadOnlyRow(
                  label: 'Tree Code',
                  value: treeCode.isEmpty ? '-' : treeCode,
                ),
                const SizedBox(height: 12),
                _ReadOnlyRow(
                  label: 'Tree Structure',
                  value: treeStructure.isEmpty ? '-' : treeStructure,
                  valueColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Nodes table card ────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Toolbar row ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      // Actions menu
                      MenuAnchor(
                        style: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          elevation: WidgetStateProperty.all(4),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        builder: (context, controller, child) {
                          return InkWell(
                            onTap: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Actions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        menuChildren: [
                          _buildMenuItem(
                            'Add',
                            Icons.add_rounded,
                            onPressed: onAddNode,
                          ),
                          _buildMenuItem(
                            'Create',
                            Icons.create_rounded,
                            onPressed: onCreateNode,
                          ),
                          _buildMenuItem('Duplicate', Icons.copy_outlined),
                          _buildMenuItem('Edit', Icons.edit_outlined),
                          _buildMenuItem(
                            'Remove',
                            Icons.remove_circle_outline_rounded,
                          ),
                          MenuItemButton(
                            onPressed: () {},
                            leadingIcon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 16,
                              color: Color(0xFFDC2626),
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            'Export Nodes',
                            Icons.upload_file_outlined,
                          ),
                          _buildMenuItem(
                            'Export Selected Nodes',
                            Icons.file_upload_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),

                      // View menu
                      MenuAnchor(
                        style: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          elevation: WidgetStateProperty.all(4),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        builder: (context, controller, child) {
                          return InkWell(
                            onTap: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        menuChildren: [
                          SubmenuButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(
                                AppColors.textPrimary,
                              ),
                              textStyle: WidgetStateProperty.all(
                                const TextStyle(fontSize: 13),
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            menuChildren: [
                              MenuItemButton(
                                onPressed: onShowAllColumns,
                                child: const Text(
                                  'Show All',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              const PopupMenuDivider(),
                              ...columnVisibility.keys.map((colName) {
                                final isVisible =
                                    columnVisibility[colName] ?? false;
                                return MenuItemButton(
                                  onPressed: () {
                                    onColumnVisibilityChanged(
                                      colName,
                                      !isVisible,
                                    );
                                  },
                                  leadingIcon: isVisible
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 14,
                                          color: AppColors.textPrimary,
                                        )
                                      : Container(
                                          width: 10,
                                          height: 10,
                                          margin: const EdgeInsets.only(
                                            left: 2,
                                            right: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade400,
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                  child: Text(
                                    colName,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }),
                              const PopupMenuDivider(),
                              MenuItemButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Manage Columns clicked'),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Manage Columns...',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.view_column_outlined,
                                  size: 16,
                                  color: AppColors.textPrimary,
                                ),
                                SizedBox(width: 8),
                                Text('Columns'),
                              ],
                            ),
                          ),
                          _buildMenuItem(
                            'Freeze',
                            Icons.ac_unit_rounded,
                            disabled: true,
                          ),
                          _buildMenuItem('Detach', Icons.open_in_new_rounded),
                          _buildMenuItem(
                            'Expand',
                            Icons.expand_rounded,
                            disabled: true,
                          ),
                          _buildMenuItem(
                            'Expand All Below',
                            Icons.unfold_more_rounded,
                            disabled: true,
                          ),
                          _buildMenuItem(
                            'Collapse All Below',
                            Icons.unfold_less_rounded,
                            disabled: true,
                          ),
                          _buildMenuItem('Expand All', Icons.expand_outlined),
                          _buildMenuItem(
                            'Collapse All',
                            Icons.compress_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),

                      // Format menu
                      MenuAnchor(
                        style: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          elevation: WidgetStateProperty.all(4),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        builder: (context, controller, child) {
                          return InkWell(
                            onTap: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Format',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        menuChildren: [
                          _buildMenuItem(
                            'Resize Columns...',
                            Icons.swap_horiz_rounded,
                            disabled: true,
                          ),
                          _buildMenuItem('Wrap', Icons.wrap_text_rounded),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Horizontally scrollable table ────────────────────────
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column headers
                        Container(
                          color: const Color(0xFFEEF2F7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                          child: Row(
                            children: [
                              if (columnVisibility['Node Name'] ?? true)
                                const SizedBox(
                                  width: 180,
                                  child: _ColHeader('Node Name'),
                                ),
                              if (columnVisibility['Node Description'] ?? true)
                                const SizedBox(
                                  width: 200,
                                  child: _ColHeader('Node Description'),
                                ),
                              if (columnVisibility['Label'] ?? true)
                                const SizedBox(
                                  width: 130,
                                  child: _ColHeader('Label'),
                                ),
                              if (columnVisibility['Data Source'] ?? true)
                                const SizedBox(
                                  width: 150,
                                  child: _ColHeader('Data Source'),
                                ),
                              const SizedBox(width: 36),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.border),

                        // Rows
                        nodes.isEmpty
                            ? _EmptyNodes(onAdd: onAddNode)
                            : Column(
                                children: List.generate(nodes.length, (i) {
                                  final node = nodes[i];
                                  return Column(
                                    children: [
                                      Container(
                                        color: i.isEven
                                            ? Colors.white
                                            : const Color(0xFFFAFBFC),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 13,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (columnVisibility['Node Name'] ??
                                                true)
                                              SizedBox(
                                                width: 180,
                                                child: Text(
                                                  node.nodeName,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            if (columnVisibility['Node Description'] ??
                                                true)
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  node.nodeDescription.isEmpty
                                                      ? '—'
                                                      : node.nodeDescription,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                            if (columnVisibility['Label'] ??
                                                true)
                                              SizedBox(
                                                width: 130,
                                                child: Text(
                                                  node.label.isEmpty
                                                      ? '—'
                                                      : node.label,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                            if (columnVisibility['Data Source'] ??
                                                true)
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  node.dataSource.isEmpty
                                                      ? '—'
                                                      : node.dataSource,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                            SizedBox(
                                              width: 36,
                                              child: GestureDetector(
                                                onTap: () => onDeleteNode(i),
                                                child: const Icon(
                                                  Icons.close_rounded,
                                                  size: 18,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (i < nodes.length - 1)
                                        const Divider(
                                          height: 1,
                                          color: AppColors.border,
                                        ),
                                    ],
                                  );
                                }),
                              ),
                      ],
                    ),
                  ),
                ),

                // ── Add node button at bottom ─────────────────────────────
                if (nodes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextButton.icon(
                      onPressed: onAddNode,
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Add Node'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Empty nodes placeholder ──────────────────────────────────────────────────

class _EmptyNodes extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyNodes({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF5FC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.account_tree_outlined,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No data to display.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Node'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Node menu button ─────────────────────────────────────────────────────────

// _IconToolBtn removed — no longer used

class _ColHeader extends StatelessWidget {
  final String text;
  const _ColHeader(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 0.3,
    ),
  );
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textHeading,
              ),
            ),
            const SizedBox(height: 6),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;

  const _ReadOnlyRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 140,
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
      Expanded(
        child: Text(
          value.isEmpty ? '-' : value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ),
    ],
  );
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FieldLabel({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) => RichText(
    text: TextSpan(
      text: label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      children: isRequired
          ? const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]
          : [],
    ),
  );
}

class _DatePickerField extends StatelessWidget {
  final String value, hint;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value.isEmpty ? hint : value,
              style: TextStyle(
                fontSize: 14,
                color: value.isEmpty
                    ? const Color(0xFFB0BEC5)
                    : AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    ),
  );
}
