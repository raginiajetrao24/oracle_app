import 'package:flutter/material.dart';
import '../../app/models/organization_tree_model.dart';
import '../../app/constants/app_colors.dart';
import 'widgets/org_tree_card.dart'; // ← local widgets folder
import 'widgets/search_filter_card.dart'; // ← local widgets folder
import 'select_tree_screen.dart';

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

class OrganizationTreesScreen extends StatefulWidget {
  const OrganizationTreesScreen({super.key});

  @override
  State<OrganizationTreesScreen> createState() =>
      _OrganizationTreesScreenState();
}

class _OrganizationTreesScreenState extends State<OrganizationTreesScreen> {
  final _treeCodeController = TextEditingController();
  final _treeNameController = TextEditingController();
  OrgTree? _selectedTree;
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
    super.dispose();
  }

  void _onSearch() {
    final code = _treeCodeController.text.trim().toLowerCase();
    final name = _treeNameController.text.trim().toLowerCase();
    setState(() {
      _filteredTrees = sampleOrgTrees.where((tree) {
        final matchesCode =
            code.isEmpty || tree.code.toLowerCase().contains(code);
        final matchesName =
            name.isEmpty || tree.name.toLowerCase().contains(name);
        return matchesCode && matchesName;
      }).toList();
    });
  }

  void _onReset() {
    _treeCodeController.clear();
    _treeNameController.clear();
    setState(() => _filteredTrees = List.of(sampleOrgTrees));
  }

  // Replace _handleAction with this:
  void _handleAction(_TreeAction action) {
    switch (action) {
      case _TreeAction.createTreeVersion:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SelectTreeScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_actionLabel(action)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  String _actionLabel(_TreeAction action) {
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
    return labels[action] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          onPressed: () => Navigator.maybePop(context),
          tooltip: 'Back',
        ),
        title: const Text('Organization Trees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 24),
            onPressed: () {},
            tooltip: 'Search',
            padding: const EdgeInsets.only(right: 4), // ← shift left
          ),
          _TreeActionsMenu(onSelected: _handleAction),
          const SizedBox(width: 4), // ← small right margin for Actions text
        ],
      ),
      body: Column(
        children: [
          SearchFilterCard(
            treeCodeController: _treeCodeController,
            treeNameController: _treeNameController,
            onSearch: _onSearch,
            onReset: _onReset,
          ),
          Expanded(
            child: _filteredTrees.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _filteredTrees.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final tree = _filteredTrees[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTree = tree;
                          });
                        },
                        child: OrgTreeCard(
                          key: ValueKey(tree.id),
                          tree: tree,
                          initiallyExpanded: false,
                          isSelected: _selectedTree == tree,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── 3-dot menu ───────────────────────────────────────────────────────────────

class _TreeActionsMenu extends StatelessWidget {
  final ValueChanged<_TreeAction> onSelected;

  const _TreeActionsMenu({required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_TreeAction>(
      tooltip: 'Actions',
      color: AppColors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: onSelected,
      itemBuilder: (_) => [
        _menuItem(_TreeAction.createTree, 'Create Tree', Icons.add_rounded),
        _menuItem(
          _TreeAction.createTreeVersion,
          'Create Tree Version',
          Icons.add_box_outlined,
        ),
        _menuItem(_TreeAction.duplicate, 'Duplicate', Icons.copy_outlined),
        const PopupMenuDivider(height: 1),
        _menuItem(_TreeAction.edit, 'Edit', Icons.edit_outlined),
        _menuItem(
          _TreeAction.delete,
          'Delete',
          Icons.delete_outline_rounded,
          isDestructive: true,
        ),
        const PopupMenuDivider(height: 1),
        _menuItem(
          _TreeAction.viewTreeVersion,
          'View Tree Version',
          Icons.account_tree_outlined,
        ),
        _menuItem(
          _TreeAction.setStatus,
          'Set Status',
          Icons.toggle_on_outlined,
        ),
        _menuItem(_TreeAction.audit, 'Audit', Icons.history_rounded),
        _menuItem(
          _TreeAction.flatten,
          'Flatten',
          Icons.format_list_bulleted_rounded,
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          'Actions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<_TreeAction> _menuItem(
    _TreeAction value,
    String label,
    IconData icon, {
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? const Color(0xFFDC2626)
        : AppColors.textPrimary;
    return PopupMenuItem<_TreeAction>(
      value: value,
      height: 44,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
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
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.account_tree_outlined,
            size: 56,
            color: AppColors.textMuted,
          ),
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
}
