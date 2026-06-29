import 'package:flutter/material.dart';
import '../../app/models/organization_tree_model.dart';
import '../../app/constants/app_colors.dart';
import 'widgets/org_tree_card.dart';
import 'select_tree_screen.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

enum _TreeAction {
  createTree,
  createTreeVersion,
  duplicate,
  edit,
  delete,
  viewTreeVersion,
  setStatus,
  audit,
  flatten,
}

const List<String> _kOperators = [
  'Starts with',
  'Ends with',
  'Equals',
  'Does not equal',
  'Less than',
  'Less than or equal to',
  'Greater than',
  'Greater than or equal to',
  'Between',
  'Not between',
  'Contains',
  'Does not contain',
  'Is blank',
  'Is not blank',
];

const List<String> _kAddFields = [
  'Description',
  'Icon Name',
  'Reference Data Set',
  'Set Name',
  'Tree Code',
  'Tree Name',
  'Tree Structure Code',
];

const List<String> _kSavedSearches = [
  'All Trees',
  'Trees For Given Tree Structure',
];

class OrganizationTreesScreen extends StatefulWidget {
  const OrganizationTreesScreen({super.key});

  @override
  State<OrganizationTreesScreen> createState() =>
      _OrganizationTreesScreenState();
}

class _OrganizationTreesScreenState extends State<OrganizationTreesScreen> {
  bool _isAdvanced = false;
  String _savedSearch = _kSavedSearches[0];

  final _treeCodeController = TextEditingController();
  final _treeNameController = TextEditingController();
  String _codeOperator = _kOperators[0];
  String _nameOperator = _kOperators[0];
  final _advCodeController = TextEditingController();
  final _advNameController = TextEditingController();
  final Set<String> _extraFields = {};
  final Map<String, TextEditingController> _extraControllers = {};

  late List<OrgTree> _filteredTrees;

  @override
  void initState() {
    super.initState();
    _filteredTrees = List.of(sampleOrgTrees);
  }

  @override
  void dispose() {
    _treeCodeController.dispose();
    _treeNameController.dispose();
    _advCodeController.dispose();
    _advNameController.dispose();
    for (final c in _extraControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onSearch() {
    FocusScope.of(context).unfocus();

    // Check if any field has input
    final hasInput = _isAdvanced
        ? _advCodeController.text.trim().isNotEmpty ||
              _advNameController.text.trim().isNotEmpty ||
              _extraControllers.values.any((c) => c.text.trim().isNotEmpty)
        : _treeCodeController.text.trim().isNotEmpty ||
              _treeNameController.text.trim().isNotEmpty;

    if (!hasInput) {
      _showSearchValidation();
      return;
    }

    setState(() {
      _filteredTrees = sampleOrgTrees.where((tree) {
        if (_isAdvanced) {
          return _matchOp(
                tree.code,
                _codeOperator,
                _advCodeController.text.trim(),
              ) &&
              _matchOp(
                tree.name,
                _nameOperator,
                _advNameController.text.trim(),
              );
        } else {
          final code = _treeCodeController.text.trim().toLowerCase();
          final name = _treeNameController.text.trim().toLowerCase();
          return (code.isEmpty || tree.code.toLowerCase().contains(code)) &&
              (name.isEmpty || tree.name.toLowerCase().contains(name));
        }
      }).toList();
    });
  }

  void _showSearchValidation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('Search Required', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: const Text(
          'Please enter at least one search criteria before searching.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _matchOp(String fv, String op, String q) {
    if (q.isEmpty && op != 'Is blank' && op != 'Is not blank') return true;
    final f = fv.toLowerCase();
    final v = q.toLowerCase();
    switch (op) {
      case 'Starts with':
        return f.startsWith(v);
      case 'Ends with':
        return f.endsWith(v);
      case 'Equals':
        return f == v;
      case 'Does not equal':
        return f != v;
      case 'Contains':
        return f.contains(v);
      case 'Does not contain':
        return !f.contains(v);
      case 'Is blank':
        return fv.trim().isEmpty;
      case 'Is not blank':
        return fv.trim().isNotEmpty;
      default:
        return f.contains(v);
    }
  }

  void _onReset() {
    FocusScope.of(context).unfocus();
    _treeCodeController.clear();
    _treeNameController.clear();
    _advCodeController.clear();
    _advNameController.clear();
    for (final c in _extraControllers.values) {
      c.dispose();
    }
    setState(() {
      _codeOperator = _kOperators[0];
      _nameOperator = _kOperators[0];
      _filteredTrees = List.of(sampleOrgTrees);
      _extraFields.clear();
      _extraControllers.clear();
    });
  }

  void _onToggleMode() {
    setState(() {
      _isAdvanced = !_isAdvanced;
      // Clear extra fields when switching back to basic
      if (!_isAdvanced) {
        for (final c in _extraControllers.values) {
          c.dispose();
        }
        _extraFields.clear();
        _extraControllers.clear();
      }
    });
  }

  void _onRemoveField(String field) {
    setState(() {
      _extraFields.remove(field);
      _extraControllers[field]?.dispose();
      _extraControllers.remove(field);
    });
  }

  void _showAddFields(BuildContext ctx) async {
    final box = ctx.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(ctx).overlay!.context.findRenderObject() as RenderBox;
    final pos = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(Offset.zero, ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final sel = await showMenu<String>(
      context: ctx,
      position: pos,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      items: _kAddFields
          .map(
            (f) => PopupMenuItem<String>(
              value: f,
              child: Row(
                children: [
                  Icon(
                    _extraFields.contains(f)
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    size: 18,
                    color: _extraFields.contains(f)
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Text(f, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          )
          .toList(),
    );

    if (sel != null) {
      setState(() {
        if (_extraFields.contains(sel)) {
          _extraFields.remove(sel);
          _extraControllers[sel]?.dispose();
          _extraControllers.remove(sel);
        } else {
          _extraFields.add(sel);
          _extraControllers[sel] = TextEditingController();
        }
      });
    }
  }

  void _handleAction(_TreeAction action) {
    if (action == _TreeAction.createTreeVersion) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SelectTreeScreen()),
      );
      return;
    }
    const labels = {
      _TreeAction.createTree: 'Create Tree',
      _TreeAction.createTreeVersion: 'Create Tree Version',
      _TreeAction.duplicate: 'Duplicate',
      _TreeAction.edit: 'Edit',
      _TreeAction.delete: 'Delete',
      _TreeAction.viewTreeVersion: 'View Tree Version',
      _TreeAction.setStatus: 'Set Status',
      _TreeAction.audit: 'Audit',
      _TreeAction.flatten: 'Flatten',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(labels[action] ?? ''),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppHeaderWidget(
            title: 'Organization Trees',
            showBack: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Color(0xFF1F4E8C), size: 22),
                onPressed: _onSearch,
              ),
              _ActionsMenu(onSelected: _handleAction),
              const SizedBox(width: 4),
            ],
          ),
          _SearchPanel(
            isAdvanced: _isAdvanced,
            savedSearch: _savedSearch,
            savedSearchOptions: _kSavedSearches,
            treeCodeController: _treeCodeController,
            treeNameController: _treeNameController,
            codeOperator: _codeOperator,
            nameOperator: _nameOperator,
            advCodeController: _advCodeController,
            advNameController: _advNameController,
            operators: _kOperators,
            extraFields: _extraFields,
            extraControllers: _extraControllers,
            onToggleMode: _onToggleMode,
            onSavedSearchChanged: (v) =>
                setState(() => _savedSearch = v ?? _savedSearch),
            onCodeOperatorChanged: (v) =>
                setState(() => _codeOperator = v ?? _codeOperator),
            onNameOperatorChanged: (v) =>
                setState(() => _nameOperator = v ?? _nameOperator),
            onSearch: _onSearch,
            onReset: _onReset,
            onAddFields: _showAddFields,
            onRemoveField: _onRemoveField,
          ),
          Expanded(
            child: _filteredTrees.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _filteredTrees.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => OrgTreeCard(
                      key: ValueKey(_filteredTrees[i].id),
                      tree: _filteredTrees[i],
                      initiallyExpanded: false,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Search Panel ─────────────────────────────────────────────────────────────

class _SearchPanel extends StatelessWidget {
  final bool isAdvanced;
  final String savedSearch;
  final List<String> savedSearchOptions;
  final TextEditingController treeCodeController, treeNameController;
  final TextEditingController advCodeController, advNameController;
  final String codeOperator, nameOperator;
  final List<String> operators;
  final Set<String> extraFields;
  final Map<String, TextEditingController> extraControllers;
  final VoidCallback onToggleMode, onSearch, onReset;
  final ValueChanged<String?> onSavedSearchChanged;
  final ValueChanged<String?> onCodeOperatorChanged, onNameOperatorChanged;
  final void Function(BuildContext) onAddFields;
  final void Function(String) onRemoveField;

  const _SearchPanel({
    required this.isAdvanced,
    required this.savedSearch,
    required this.savedSearchOptions,
    required this.treeCodeController,
    required this.treeNameController,
    required this.advCodeController,
    required this.advNameController,
    required this.codeOperator,
    required this.nameOperator,
    required this.operators,
    required this.extraFields,
    required this.extraControllers,
    required this.onToggleMode,
    required this.onSavedSearchChanged,
    required this.onCodeOperatorChanged,
    required this.onNameOperatorChanged,
    required this.onSearch,
    required this.onReset,
    required this.onAddFields,
    required this.onRemoveField,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          // ── Top bar ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                _ModeToggle(isAdvanced: isAdvanced, onToggle: onToggleMode),
                const SizedBox(width: 10),
                const Text(
                  'Saved Search',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: savedSearch,
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        items: savedSearchOptions
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(s, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: onSavedSearchChanged,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Fields ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: isAdvanced
                ? _AdvancedFields(
                    codeOperator: codeOperator,
                    nameOperator: nameOperator,
                    advCodeController: advCodeController,
                    advNameController: advNameController,
                    operators: operators,
                    onCodeOperatorChanged: onCodeOperatorChanged,
                    onNameOperatorChanged: onNameOperatorChanged,
                    extraFields: extraFields,
                    extraControllers: extraControllers,
                    onRemoveField: onRemoveField,
                  )
                : _BasicFields(
                    treeCodeController: treeCodeController,
                    treeNameController: treeNameController,
                    extraFields: extraFields,
                    extraControllers: extraControllers,
                    onRemoveField: onRemoveField,
                  ),
          ),

          // ── Button row ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionBtn(label: 'Search', filled: true, onPressed: onSearch),
                _ActionBtn(label: 'Reset', onPressed: onReset),
                if (isAdvanced) ...[
                  Builder(
                    builder: (ctx) => _ActionBtn(
                      label: 'Add Fields',
                      trailing: Icons.arrow_drop_down_rounded,
                      onPressed: () => onAddFields(ctx),
                    ),
                  ),
                  _ActionBtn(label: 'Reorder', onPressed: () {}),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mode toggle ──────────────────────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final bool isAdvanced;
  final VoidCallback onToggle;

  const _ModeToggle({required this.isAdvanced, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Tab(label: 'Basic', active: !isAdvanced, onTap: onToggle),
          _Tab(label: 'Advanced', active: isAdvanced, onTap: onToggle),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : AppColors.textSecondary,
        ),
      ),
    ),
  );
}

// ─── Basic Fields ─────────────────────────────────────────────────────────────

class _BasicFields extends StatelessWidget {
  final TextEditingController treeCodeController, treeNameController;
  final Set<String> extraFields;
  final Map<String, TextEditingController> extraControllers;
  final void Function(String) onRemoveField;

  const _BasicFields({
    required this.treeCodeController,
    required this.treeNameController,
    required this.extraFields,
    required this.extraControllers,
    required this.onRemoveField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Tree Code'),
        const SizedBox(height: 5),
        _InputField(controller: treeCodeController, hint: 'Enter tree code'),
        const SizedBox(height: 12),
        const _FieldLabel('Tree Name'),
        const SizedBox(height: 5),
        _InputField(controller: treeNameController, hint: 'Enter tree name'),
        ...extraFields.map(
          (f) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _FieldLabelWithRemove(label: f, onRemove: () => onRemoveField(f)),
              const SizedBox(height: 5),
              _InputField(
                controller: extraControllers[f] ?? TextEditingController(),
                hint: 'Enter $f',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Advanced Fields ──────────────────────────────────────────────────────────

class _AdvancedFields extends StatelessWidget {
  final String codeOperator, nameOperator;
  final TextEditingController advCodeController, advNameController;
  final List<String> operators;
  final ValueChanged<String?> onCodeOperatorChanged, onNameOperatorChanged;
  final Set<String> extraFields;
  final Map<String, TextEditingController> extraControllers;
  final void Function(String) onRemoveField;

  const _AdvancedFields({
    required this.codeOperator,
    required this.nameOperator,
    required this.advCodeController,
    required this.advNameController,
    required this.operators,
    required this.onCodeOperatorChanged,
    required this.onNameOperatorChanged,
    required this.extraFields,
    required this.extraControllers,
    required this.onRemoveField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AdvRow(
          label: 'Tree Code',
          operator: codeOperator,
          controller: advCodeController,
          operators: operators,
          onChanged: onCodeOperatorChanged,
        ),
        const SizedBox(height: 12),
        _AdvRow(
          label: 'Tree Name',
          operator: nameOperator,
          controller: advNameController,
          operators: operators,
          onChanged: onNameOperatorChanged,
        ),
        ...extraFields.map(
          (f) => Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _AdvRow(
              label: f,
              operator: operators[0],
              controller: extraControllers[f] ?? TextEditingController(),
              operators: operators,
              onChanged: (_) {},
              onRemove: () => onRemoveField(f),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdvRow extends StatelessWidget {
  final String label, operator;
  final TextEditingController controller;
  final List<String> operators;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onRemove;

  const _AdvRow({
    required this.label,
    required this.operator,
    required this.controller,
    required this.operators,
    required this.onChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hideInput = operator == 'Is blank' || operator == 'Is not blank';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        onRemove != null
            ? _FieldLabelWithRemove(label: label, onRemove: onRemove!)
            : _FieldLabel(label),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: _OperatorDropdown(
                value: operator,
                operators: operators,
                onChanged: onChanged,
              ),
            ),
            if (!hideInput) ...[
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: _InputField(controller: controller, hint: 'Value'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ─── Shared small widgets ─────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
  );
}

class _FieldLabelWithRemove extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FieldLabelWithRemove({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _OperatorDropdown extends StatelessWidget {
  final String value;
  final List<String> operators;
  final ValueChanged<String?> onChanged;

  const _OperatorDropdown({
    required this.value,
    required this.operators,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.border),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 18,
          color: AppColors.textSecondary,
        ),
        items: operators
            .map(
              (op) => DropdownMenuItem(
                value: op,
                child: Text(op, style: const TextStyle(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
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
      ),
    ),
  );
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final bool filled;
  final IconData? trailing;
  final VoidCallback onPressed;

  const _ActionBtn({
    required this.label,
    this.filled = false,
    this.trailing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: filled ? Colors.white : AppColors.primary,
          ),
        ),
        if (trailing != null)
          Icon(
            trailing,
            size: 18,
            color: filled ? Colors.white : AppColors.primary,
          ),
      ],
    );

    return SizedBox(
      height: 36,
      child: filled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: child,
            ),
    );
  }
}

// ─── Actions menu ─────────────────────────────────────────────────────────────

class _ActionsMenu extends StatelessWidget {
  final ValueChanged<_TreeAction> onSelected;

  const _ActionsMenu({required this.onSelected});

  @override
  Widget build(BuildContext context) => PopupMenuButton<_TreeAction>(
    tooltip: 'Actions',
    color: Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onSelected: onSelected,
    itemBuilder: (_) => [
      _item(_TreeAction.createTree, 'Create Tree', Icons.add_rounded),
      _item(
        _TreeAction.createTreeVersion,
        'Create Tree Version',
        Icons.add_box_outlined,
      ),
      _item(_TreeAction.duplicate, 'Duplicate', Icons.copy_outlined),
      const PopupMenuDivider(height: 1),
      _item(_TreeAction.edit, 'Edit', Icons.edit_outlined),
      _item(
        _TreeAction.delete,
        'Delete',
        Icons.delete_outline_rounded,
        d: true,
      ),
      const PopupMenuDivider(height: 1),
      _item(
        _TreeAction.viewTreeVersion,
        'View Tree Version',
        Icons.account_tree_outlined,
      ),
      _item(_TreeAction.setStatus, 'Set Status', Icons.toggle_on_outlined),
      _item(_TreeAction.audit, 'Audit', Icons.history_rounded),
      _item(_TreeAction.flatten, 'Flatten', Icons.format_list_bulleted_rounded),
    ],
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        'Actions',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );

  PopupMenuItem<_TreeAction> _item(
    _TreeAction v,
    String l,
    IconData i, {
    bool d = false,
  }) {
    final c = d ? const Color(0xFFDC2626) : AppColors.textPrimary;
    return PopupMenuItem(
      value: v,
      height: 44,
      child: Row(
        children: [
          Icon(i, size: 18, color: c),
          const SizedBox(width: 12),
          Text(
            l,
            style: TextStyle(
              fontSize: 14,
              color: c,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_tree_outlined, size: 56, color: AppColors.textMuted),
        SizedBox(height: 16),
        Text(
          'No trees found',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Try adjusting your search filters.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    ),
  );
}
