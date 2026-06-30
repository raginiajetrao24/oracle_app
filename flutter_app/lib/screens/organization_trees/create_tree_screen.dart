import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

class _DataSourceParam {
  final String name;
  String baseValue;
  String value;
  bool expanded;

  _DataSourceParam({required this.name})
    : baseValue = '',
      value = '',
      expanded = false;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class CreateTreeScreen extends StatefulWidget {
  const CreateTreeScreen({super.key});

  @override
  State<CreateTreeScreen> createState() => _CreateTreeScreenState();
}

class _CreateTreeScreenState extends State<CreateTreeScreen> {
  int _currentStep = 0; // 0=Definition, 1=Labels, 2=Access Rules

  // Step 1 fields
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descController = TextEditingController();
  String _treeStructure = 'HCM Organization Hierarchy Tree Structure';
  String _iconImage = 'folderopen_ena.png';
  final _formKey = GlobalKey<FormState>();

  // Column visibility for Data Source Parameters table
  bool _showName = true;
  bool _showBaseValue = true;
  bool _showValue = true;

  // Step 1 – Data Source Parameters table
  final List<_DataSourceParam> _dataSourceParams = [
    _DataSourceParam(name: 'Organization Tree Data Source'),
  ];

  // Step 2 – Labels
  // Step 3 – Access Rules (simple toggle for demo)
  bool _step2SummaryExpanded = true;
  bool _step3SummaryExpanded = true;

  final List<String> _iconOptions = ['folderopen_ena.png', 'More...'];

  final List<String> _structureOptions = [
    'HCM Organization Hierarchy Tree Structure',
    'PER_ORG_TREE_STRUCTI',
    'GL Ledger Hierarchy',
    'Cost Center Hierarchy',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus();
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      FocusScope.of(context).unfocus();
      setState(() => _currentStep = 2);
    }
  }

  void _onBack() {
    FocusScope.of(context).unfocus();
    if (_currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _currentStep -= 1);
    }
  }

  void _onSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Organization tree created successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF16A34A),
      ),
    );
    Navigator.pop(context);
  }

  void _onCancel() => Navigator.pop(context);

  // ── Data Source param table actions ──────────────────────────────────────
  void _addDataSourceRow() {
    setState(() {
      _dataSourceParams.add(_DataSourceParam(name: 'New Data Source'));
    });
  }

  void _clearDataSourceRow(int index) {
    setState(() {
      _dataSourceParams[index].baseValue = '';
      _dataSourceParams[index].value = '';
    });
  }

  void _removeDataSourceRow(int index) {
    if (_dataSourceParams.length > 1) {
      setState(() => _dataSourceParams.removeAt(index));
    }
  }

  // ── Label table actions ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Create Organization Tree',
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
          // ── 3-step stepper ──────────────────────────────────────────
          _StepperHeader(currentStep: _currentStep),

          // ── Action bar ──────────────────────────────────────────────
          _ActionBar(
            currentStep: _currentStep,
            onBack: _onBack,
            onNext: _onNext,
            onSubmit: _onSubmit,
          ),

          // ── Content ─────────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _buildStep(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _Step1Definition(
          key: const ValueKey('step0'),
          formKey: _formKey,
          nameController: _nameController,
          codeController: _codeController,
          descController: _descController,
          treeStructure: _treeStructure,
          structureOptions: _structureOptions,
          iconImage: _iconImage,
          iconOptions: _iconOptions,
          dataSourceParams: _dataSourceParams,
          showName: _showName,
          showBaseValue: _showBaseValue,
          showValue: _showValue,
          onStructureChanged: (v) =>
              setState(() => _treeStructure = v ?? _treeStructure),
          onIconChanged: (v) => setState(() => _iconImage = v ?? _iconImage),
          onAddDataSource: _addDataSourceRow,
          onClearDataSource: _clearDataSourceRow,
          onRemoveDataSource: _removeDataSourceRow,
          onParamChanged: (i, base, val) => setState(() {
            _dataSourceParams[i].baseValue = base;
            _dataSourceParams[i].value = val;
          }),
          onToggleExpand: (i) => setState(
            () =>
                _dataSourceParams[i].expanded = !_dataSourceParams[i].expanded,
          ),
          onColumnToggle: (col) => setState(() {
            if (col == 'Name') _showName = !_showName;
            if (col == 'Base Value') _showBaseValue = !_showBaseValue;
            if (col == 'Value') _showValue = !_showValue;
          }),
          onShowAllColumns: () => setState(() {
            _showName = true;
            _showBaseValue = true;
            _showValue = true;
          }),
        );
      case 1:
        return _Step2Labels(
          key: const ValueKey('step1'),
          treeName: _nameController.text,
          treeCode: _codeController.text,
          treeDescription: _descController.text,
          treeStructure: _treeStructure,
          summaryExpanded: _step2SummaryExpanded,
          onToggleSummary: () =>
              setState(() => _step2SummaryExpanded = !_step2SummaryExpanded),
        );
      case 2:
        return _Step3AccessRules(
          key: const ValueKey('step2'),
          treeName: _nameController.text,
          treeCode: _codeController.text,
          treeDescription: _descController.text,
          treeStructure: _treeStructure,
          summaryExpanded: _step3SummaryExpanded,
          onToggleSummary: () =>
              setState(() => _step3SummaryExpanded = !_step3SummaryExpanded),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Stepper Header ───────────────────────────────────────────────────────────

class _StepperHeader extends StatelessWidget {
  final int currentStep;
  const _StepperHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
            label: 'Specify\nLabels',
            currentStep: currentStep,
          ),
          _StepConnector(isCompleted: currentStep > 1),
          _StepCircle(
            index: 2,
            label: 'Specify Access\nRules',
            currentStep: currentStep,
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index, currentStep;
  final String label;

  const _StepCircle({
    required this.index,
    required this.label,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = currentStep > index;
    final isActive = currentStep == index;

    final Color bg = isCompleted
        ? const Color(0xFF16A34A)
        : isActive
        ? AppColors.primary
        : Colors.white;

    final Color border = isCompleted
        ? const Color(0xFF16A34A)
        : isActive
        ? AppColors.primary
        : const Color(0xFFD1D5DB);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 2),
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
          child: isCompleted
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
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
  final VoidCallback onBack, onNext, onSubmit;

  const _ActionBar({
    required this.currentStep,
    required this.onBack,
    required this.onNext,
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
          // Back / Previous
          _OutlineBtn(
            label: currentStep == 0 ? 'Back' : 'Previous',
            icon: Icons.chevron_left_rounded,
            onPressed: onBack,
          ),
          const Spacer(),
          // Submit always visible but faded unless on last step
          if (currentStep == 2)
            _FilledBtn(
              label: 'Submit',
              trailingIcon: Icons.check_rounded,
              onPressed: onSubmit,
              color: const Color(0xFF16A34A),
            )
          else ...[
            Opacity(
              opacity: 0.4,
              child: _FilledBtn(
                label: 'Submit',
                trailingIcon: Icons.check_rounded,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            _FilledBtn(
              label: 'Next',
              trailingIcon: Icons.chevron_right_rounded,
              onPressed: onNext,
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

// ─────────────────────────────────────────────────────────────────────────────
// STEP 1: SPECIFY DEFINITION
// ─────────────────────────────────────────────────────────────────────────────

class _Step1Definition extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController, codeController, descController;
  final String treeStructure, iconImage;
  final List<String> structureOptions, iconOptions;
  final List<_DataSourceParam> dataSourceParams;
  final bool showName, showBaseValue, showValue;
  final ValueChanged<String?> onStructureChanged, onIconChanged;
  final VoidCallback onAddDataSource;
  final void Function(int) onClearDataSource,
      onRemoveDataSource,
      onToggleExpand;
  final void Function(int, String, String) onParamChanged;
  final void Function(String) onColumnToggle;
  final VoidCallback onShowAllColumns;

  const _Step1Definition({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.codeController,
    required this.descController,
    required this.treeStructure,
    required this.structureOptions,
    required this.iconImage,
    required this.iconOptions,
    required this.dataSourceParams,
    required this.showName,
    required this.showBaseValue,
    required this.showValue,
    required this.onStructureChanged,
    required this.onIconChanged,
    required this.onAddDataSource,
    required this.onClearDataSource,
    required this.onRemoveDataSource,
    required this.onParamChanged,
    required this.onToggleExpand,
    required this.onColumnToggle,
    required this.onShowAllColumns,
  });

  InputDecoration _deco(
    String label, {
    bool required = false,
  }) => InputDecoration(
    labelText: required ? '$label *' : label,
    labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
            // ── Section title ────────────────────────────────────────
            _SectionCard(
              title: 'Manage Organization Trees: Specify Definition',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  _FormRow(
                    label: 'Name',
                    isRequired: true,
                    child: TextFormField(
                      controller: nameController,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _deco('Enter tree name'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Code
                  _FormRow(
                    label: 'Code',
                    isRequired: true,
                    child: TextFormField(
                      controller: codeController,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _deco('Enter tree code'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tree Structure (read-only display + info)
                  _FormRow(
                    label: 'Tree Structure',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        treeStructure,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Icon Image
                  _FormRow(
                    label: 'Icon Image',
                    child: _IconImageDropdown(
                      value: iconImage,
                      onChanged: onIconChanged,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Preview
                  _FormRow(
                    label: 'Preview',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.folder_open_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          iconImage,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Description
                  _FormRow(
                    label: 'Description',
                    child: TextFormField(
                      controller: descController,
                      maxLines: 3,
                      decoration: _deco('Enter description'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Data Source Parameters ───────────────────────────────
            _SectionCard(
              title: 'Data Source Parameters',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toolbar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _MiniMenuBtn(
                          label: 'Actions',
                          items: const ['Clear', 'Reset', 'Save'],
                          onSelected: (v) {},
                        ),
                        const SizedBox(width: 6),
                        _ViewMenuBtn(
                          columnVisibility: {
                            'Name': showName,
                            'Base Value': showBaseValue,
                            'Value': showValue,
                          },
                          onColumnToggle: onColumnToggle,
                          onShowAll: onShowAllColumns,
                        ),
                        const SizedBox(width: 6),
                        _MiniMenuBtn(
                          label: 'Format',
                          items: const ['Resize Columns...', 'Wrap'],
                          onSelected: (_) {},
                        ),
                        const SizedBox(width: 8),
                        _SmallBtn(
                          label: 'Clear',
                          onPressed: () => onClearDataSource(0),
                        ),
                        const SizedBox(width: 6),
                        _SmallBtn(label: 'Reset', onPressed: () {}),
                        const SizedBox(width: 6),
                        _SmallBtn(
                          label: 'Save',
                          onPressed: () {},
                          filled: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Container(
                            color: const Color(0xFFEEF2F7),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 28),
                                if (showName)
                                  const SizedBox(
                                    width: 180,
                                    child: _ColHdr('Name'),
                                  ),
                                if (showBaseValue)
                                  const SizedBox(
                                    width: 140,
                                    child: _ColHdr('Base Value'),
                                  ),
                                if (showValue)
                                  const SizedBox(
                                    width: 140,
                                    child: _ColHdr('Value'),
                                  ),
                                const SizedBox(width: 32),
                              ],
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.border),

                          // Rows
                          ...dataSourceParams.asMap().entries.map((entry) {
                            final i = entry.key;
                            final p = entry.value;
                            return Column(
                              children: [
                                Container(
                                  color: i.isEven
                                      ? Colors.white
                                      : const Color(0xFFFAFBFC),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Expand toggle
                                      GestureDetector(
                                        onTap: () => onToggleExpand(i),
                                        child: Icon(
                                          p.expanded
                                              ? Icons
                                                    .keyboard_arrow_down_rounded
                                              : Icons.chevron_right_rounded,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (showName)
                                        SizedBox(
                                          width: 180,
                                          child: Text(
                                            p.name,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      if (showBaseValue)
                                        SizedBox(
                                          width: 140,
                                          child: Text(
                                            p.baseValue.isEmpty
                                                ? '—'
                                                : p.baseValue,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      if (showValue)
                                        SizedBox(
                                          width: 140,
                                          child: Text(
                                            p.value.isEmpty ? '—' : p.value,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      GestureDetector(
                                        onTap: () => onRemoveDataSource(i),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// STEP 2: SPECIFY LABELS
// ─────────────────────────────────────────────────────────────────────────────

class _Step2Labels extends StatelessWidget {
  final String treeName, treeCode, treeDescription, treeStructure;
  final bool summaryExpanded;
  final VoidCallback onToggleSummary;

  const _Step2Labels({
    super.key,
    required this.treeName,
    required this.treeCode,
    required this.treeDescription,
    required this.treeStructure,
    required this.summaryExpanded,
    required this.onToggleSummary,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OracleSummaryPanel(
            title: 'Manage Organization Trees: Specify Labels',
            expanded: summaryExpanded,
            onToggle: onToggleSummary,
            treeName: treeName,
            treeCode: treeCode,
            treeDescription: treeDescription,
            treeStructure: treeStructure,
            trailingRows: const [
              _SummaryValue(label: 'Labeling Scheme', value: 'None'),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 3: SPECIFY ACCESS RULES
// ─────────────────────────────────────────────────────────────────────────────

class _Step3AccessRules extends StatelessWidget {
  final String treeName, treeCode, treeDescription, treeStructure;
  final bool summaryExpanded;
  final VoidCallback onToggleSummary;

  const _Step3AccessRules({
    super.key,
    required this.treeName,
    required this.treeCode,
    required this.treeDescription,
    required this.treeStructure,
    required this.summaryExpanded,
    required this.onToggleSummary,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OracleSummaryPanel(
            title: 'Manage Organization Trees: Specify Access Rules',
            expanded: summaryExpanded,
            onToggle: onToggleSummary,
            treeName: treeName,
            treeCode: treeCode,
            treeDescription: treeDescription,
            treeStructure: treeStructure,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _SummaryValue {
  final String label;
  final String value;

  const _SummaryValue({required this.label, required this.value});
}

class _OracleSummaryPanel extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final String treeName, treeCode, treeDescription, treeStructure;
  final List<_SummaryValue> trailingRows;

  const _OracleSummaryPanel({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.treeName,
    required this.treeCode,
    required this.treeDescription,
    required this.treeStructure,
    this.trailingRows = const [],
  });

  @override
  Widget build(BuildContext context) {
    final detailRows = [
      _SummaryValue(label: 'Name', value: treeName.isEmpty ? '-' : treeName),
      _SummaryValue(label: 'Code', value: treeCode.isEmpty ? '-' : treeCode),
      _SummaryValue(label: 'Tree Structure', value: treeStructure),
      ...trailingRows,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHeading,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.help_outline_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryToggle(expanded: expanded, onTap: onToggle),
            const SizedBox(width: 18),
            Expanded(
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 160),
                crossFadeState: expanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _ExpandedSummaryContent(
                  detailRows: detailRows,
                  description: treeDescription,
                ),
                secondChild: _CollapsedSummaryContent(rows: trailingRows),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryToggle extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const _SummaryToggle({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        width: 18,
        height: 18,
        child: Icon(
          expanded ? Icons.arrow_drop_down : Icons.arrow_right,
          size: 18,
          color: const Color(0xFF7A8793),
        ),
      ),
    );
  }
}

class _ExpandedSummaryContent extends StatelessWidget {
  final List<_SummaryValue> detailRows;
  final String description;

  const _ExpandedSummaryContent({
    required this.detailRows,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 640;
        final details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final row in detailRows) ...[
              _SummaryLine(label: row.label, value: row.value),
              const SizedBox(height: 8),
            ],
          ],
        );
        final descriptionColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description.trim().isEmpty ? '-' : description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [details, const SizedBox(height: 4), descriptionColumn],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 430, child: details),
            const SizedBox(width: 42),
            Expanded(child: descriptionColumn),
          ],
        );
      },
    );
  }
}

class _CollapsedSummaryContent extends StatelessWidget {
  final List<_SummaryValue> rows;

  const _CollapsedSummaryContent({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox(height: 18);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows) ...[
          _SummaryLine(label: row.label, value: row.value),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label, value;

  const _SummaryLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 128,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

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

class _FormRow extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;

  const _FormRow({
    required this.label,
    this.isRequired = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: RichText(
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
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _ColHdr extends StatelessWidget {
  final String text;
  const _ColHdr(this.text);

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

class _IconImageDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _IconImageDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: onChanged,
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'folderopen_ena.png',
          child: Container(
            color: value == 'folderopen_ena.png'
                ? const Color(0xFFEEF5FC)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: const Text(
              'folderopen_ena.png',
              style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        const PopupMenuItem<String>(
          value: 'More...',
          child: Text(
            'More...',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── View menu with Columns submenu ──────────────────────────────────────────

class _ViewMenuBtn extends StatelessWidget {
  final Map<String, bool> columnVisibility;
  final void Function(String) onColumnToggle;
  final VoidCallback onShowAll;

  const _ViewMenuBtn({
    required this.columnVisibility,
    required this.onColumnToggle,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      builder: (context, controller, _) => GestureDetector(
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 14,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      menuChildren: [
        // Columns submenu
        SubmenuButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
            textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 13)),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          menuChildren: [
            MenuItemButton(
              onPressed: onShowAll,
              child: const Text(
                'Show All',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            ...columnVisibility.entries.map((entry) {
              final isVisible = entry.value;
              return MenuItemButton(
                onPressed: () => onColumnToggle(entry.key),
                leadingIcon: isVisible
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: AppColors.textPrimary,
                      )
                    : Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(left: 1, right: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                child: Text(entry.key, style: const TextStyle(fontSize: 13)),
              );
            }),
            const Divider(height: 1, color: AppColors.border),
            MenuItemButton(
              onPressed: () {},
              child: const Text(
                'Manage Columns...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          child: const Row(
            children: [
              Icon(
                Icons.view_column_outlined,
                size: 15,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 8),
              Text('Columns', style: TextStyle(fontSize: 13)),
              Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: 15,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        _viewItem('Freeze', disabled: true),
        _viewItem('Detach'),
        const Divider(height: 1, color: AppColors.border),
        _viewItem('Expand', disabled: true),
        _viewItem('Expand All Below', disabled: true),
        _viewItem('Collapse All Below', disabled: true),
        _viewItem('Expand All'),
        _viewItem('Collapse All'),
        const Divider(height: 1, color: AppColors.border),
        _viewItem('Scroll to First'),
        _viewItem('Scroll to Last'),
        const Divider(height: 1, color: AppColors.border),
        _viewItem('Sort', disabled: true, hasArrow: true),
        _viewItem('Reorder Columns...'),
      ],
    );
  }

  MenuItemButton _viewItem(
    String label, {
    bool disabled = false,
    bool hasArrow = false,
  }) {
    final color = disabled ? const Color(0xFFB0BEC5) : AppColors.textPrimary;
    return MenuItemButton(
      onPressed: disabled ? null : () {},
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: color)),
          if (hasArrow) ...[
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniMenuBtn extends StatelessWidget {
  final String label;
  final List<String> items;
  final void Function(String) onSelected;

  const _MiniMenuBtn({
    required this.label,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: label,
    color: Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    onSelected: onSelected,
    itemBuilder: (_) => items
        .map(
          (i) => PopupMenuItem<String>(
            value: i,
            height: 38,
            child: Text(
              i,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        )
        .toList(),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 14,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool filled;

  const _SmallBtn({
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 30,
    child: filled
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
  );
}
