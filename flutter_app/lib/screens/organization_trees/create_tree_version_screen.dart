import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/models/organization_tree_model.dart';

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
      // Clear any existing validation state before validating
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
          // ── Stepper ──────────────────────────────────────────────────
          _StepperHeader(currentStep: _currentStep),

          // ── Action Bar ───────────────────────────────────────────────
          _ActionBar(
            currentStep: _currentStep,
            onBack: _onBack,
            onNext: _onNext,
            onPrevious: _onPrevious,
            onSubmit: _onSubmit,
          ),

          // ── Content ──────────────────────────────────────────────────
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
  Widget build(BuildContext context) {
    return Expanded(
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
}

// ─── Action Bar ───────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

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
          // Step 1: Back button | Step 2: hide back, show Previous
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
  Widget build(BuildContext context) {
    return OutlinedButton(
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
  Widget build(BuildContext context) {
    return ElevatedButton(
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
}

// ─── Step 1: Specify Definition ───────────────────────────────────────────────

class _SpecifyDefinitionStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String treeName;
  final String treeCode;
  final String treeStructureCode;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController noteController;
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String status;
  final VoidCallback onPickStartDate;
  final VoidCallback onPickEndDate;
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
            // ── Tree info (read-only) ────────────────────────────────
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

            // ── Version details ──────────────────────────────────────
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

            // ── Dates & Status ───────────────────────────────────────
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
  final String treeName;
  final String treeCode;
  final String treeStructure;
  final String versionName;

  const _SpecifyNodesStep({
    super.key,
    required this.treeName,
    required this.treeCode,
    required this.treeStructure,
    required this.versionName,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tree summary
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

          // Toolbar buttons
          Row(
            children: [
              Expanded(
                child: _ToolbarBtn(
                  label: 'Actions',
                  icon: Icons.bolt_outlined,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ToolbarBtn(
                  label: 'View',
                  icon: Icons.visibility_outlined,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ToolbarBtn(
                  label: 'Format',
                  icon: Icons.tune_rounded,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nodes area
          _SectionCard(
            child: SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF5FC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.account_tree_outlined,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Nodes Added Yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Build your organization hierarchy\nby adding nodes below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_rounded, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Add Node',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ToolbarBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ToolbarBtn({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
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
  final String label;
  final String value;
  final Color? valueColor;

  const _ReadOnlyRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
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
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FieldLabel({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
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
}

class _DatePickerField extends StatelessWidget {
  final String value;
  final String hint;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
}
