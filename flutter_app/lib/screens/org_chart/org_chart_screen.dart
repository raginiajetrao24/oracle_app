import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────

class OrgNode {
  final String id;
  final String name;
  final String title;
  final String department;
  final String? avatarInitials;
  final Color avatarColor;
  bool expanded;
  final List<OrgNode> children;

  OrgNode({
    required this.id,
    required this.name,
    required this.title,
    required this.department,
    this.avatarInitials,
    this.avatarColor = AppColors.primary,
    this.expanded = false,
    this.children = const [],
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────

OrgNode _buildOrgTree() => OrgNode(
      id: 'root',
      name: 'William Edward Taylor',
      title: 'Chief Executive Officer',
      department: 'Global Organization',
      avatarInitials: 'WT',
      avatarColor: const Color(0xFF1E40AF),
      expanded: true,
      children: [
        OrgNode(
          id: 'n1',
          name: 'Susan Chen',
          title: 'Chief Executive Officer',
          department: 'Progress US Business Unit',
          avatarInitials: 'SC',
          avatarColor: const Color(0xFF6B21A8),
          children: [
            OrgNode(
              id: 'n1_1',
              name: 'David Park',
              title: 'VP of Operations',
              department: 'Progress US',
              avatarInitials: 'DP',
              avatarColor: const Color(0xFF0F766E),
            ),
            OrgNode(
              id: 'n1_2',
              name: 'Lisa Monroe',
              title: 'Finance Director',
              department: 'Progress US',
              avatarInitials: 'LM',
              avatarColor: const Color(0xFF92400E),
            ),
          ],
        ),
        OrgNode(
          id: 'n2',
          name: 'Ana CEO',
          title: 'Chief Executive Officer',
          department: 'Supremo Org',
          avatarInitials: 'AC',
          avatarColor: const Color(0xFF0E7490),
          children: [
            OrgNode(
              id: 'n2_1',
              name: 'Carlos Rivera',
              title: 'Regional Director',
              department: 'Supremo Org',
              avatarInitials: 'CR',
              avatarColor: const Color(0xFF166534),
            ),
          ],
        ),
        OrgNode(
          id: 'n3',
          name: 'Michelle Shannon',
          title: 'HR Help Desk Manager',
          department: 'Global Human Resource',
          avatarInitials: 'MS',
          avatarColor: const Color(0xFF9D174D),
          children: [
            OrgNode(
              id: 'n3_1',
              name: 'James Okafor',
              title: 'HR Specialist',
              department: 'Global HR',
              avatarInitials: 'JO',
              avatarColor: const Color(0xFF1E40AF),
            ),
            OrgNode(
              id: 'n3_2',
              name: 'Priya Nair',
              title: 'HR Business Partner',
              department: 'Global HR',
              avatarInitials: 'PN',
              avatarColor: const Color(0xFF6B21A8),
            ),
            OrgNode(
              id: 'n3_3',
              name: 'Tom Bailey',
              title: 'Recruitment Lead',
              department: 'Global HR',
              avatarInitials: 'TB',
              avatarColor: const Color(0xFF0F766E),
            ),
          ],
        ),
        OrgNode(
          id: 'n4',
          name: 'Peter Apt',
          title: 'Sales Vice President',
          department: 'Global - High Tech',
          avatarInitials: 'PA',
          avatarColor: const Color(0xFF92400E),
          children: [
            OrgNode(
              id: 'n4_1',
              name: 'Karen Smith',
              title: 'Sales Director',
              department: 'High Tech',
              avatarInitials: 'KS',
              avatarColor: const Color(0xFF0E7490),
            ),
          ],
        ),
        OrgNode(
          id: 'n5',
          name: 'Pat Miller',
          title: 'Marketing Vice President',
          department: 'Marketing Global',
          avatarInitials: 'PM',
          avatarColor: const Color(0xFF166534),
          children: [
            OrgNode(
              id: 'n5_1',
              name: 'Zara Khan',
              title: 'Brand Manager',
              department: 'Marketing Global',
              avatarInitials: 'ZK',
              avatarColor: const Color(0xFF9D174D),
            ),
            OrgNode(
              id: 'n5_2',
              name: 'Liam Johnson',
              title: 'Digital Marketing Lead',
              department: 'Marketing Global',
              avatarInitials: 'LJ',
              avatarColor: const Color(0xFF1E40AF),
            ),
          ],
        ),
      ],
    );

// ─── Screen ───────────────────────────────────────────────────────────────────

class OrgChartScreen extends StatefulWidget {
  const OrgChartScreen({super.key});

  @override
  State<OrgChartScreen> createState() => _OrgChartScreenState();
}

class _OrgChartScreenState extends State<OrgChartScreen> {
  late OrgNode _root;
  final TransformationController _transformController =
      TransformationController();
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _root = _buildOrgTree();
    // Center the chart slightly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transformController.value =
          Matrix4.translationValues(-60.0, 20.0, 0.0);
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _toggleNode(OrgNode node) =>
      setState(() => node.expanded = !node.expanded);

  void _resetView() {
    _transformController.value =
        Matrix4.translationValues(-60.0, 20.0, 0.0);
    setState(() => _scale = 1.0);
  }

  void _zoomIn() {
    _scale = (_scale + 0.15).clamp(0.4, 2.0);
    _transformController.value =
        Matrix4.diagonal3Values(_scale, _scale, 1.0)
          ..setTranslationRaw(
              -60.0 / _scale * _scale,
              20.0 / _scale * _scale,
              0.0);
    setState(() {});
  }

  void _zoomOut() {
    _scale = (_scale - 0.15).clamp(0.4, 2.0);
    _transformController.value =
        Matrix4.diagonal3Values(_scale, _scale, 1.0)
          ..setTranslationRaw(
              -60.0 / _scale * _scale,
              20.0 / _scale * _scale,
              0.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Organization Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset view',
            onPressed: _resetView,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          // ── Chart canvas ──────────────────────────────────────────
          InteractiveViewer(
            transformationController: _transformController,
            boundaryMargin: const EdgeInsets.all(400),
            minScale: 0.3,
            maxScale: 2.5,
            constrained: false,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _TreeNodeWidget(
                node: _root,
                isRoot: true,
                onToggle: _toggleNode,
                onAction: (node, action) =>
                    _handleAction(context, node, action),
              ),
            ),
          ),

          // ── Zoom controls ─────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                _ZoomBtn(
                    icon: Icons.add_rounded,
                    tooltip: 'Zoom in',
                    onTap: _zoomIn),
                const SizedBox(height: 8),
                _ZoomBtn(
                    icon: Icons.remove_rounded,
                    tooltip: 'Zoom out',
                    onTap: _zoomOut),
                const SizedBox(height: 8),
                _ZoomBtn(
                    icon: Icons.fit_screen_rounded,
                    tooltip: 'Reset',
                    onTap: _resetView),
              ],
            ),
          ),

          // ── Legend ────────────────────────────────────────────────
          Positioned(
            left: 16,
            bottom: 16,
            child: _Legend(),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, OrgNode node, String action) {
    String msg = '$action: ${node.name}';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }
}

// ─── Tree Node Widget (recursive) ─────────────────────────────────────────────

class _TreeNodeWidget extends StatelessWidget {
  final OrgNode node;
  final bool isRoot;
  final void Function(OrgNode) onToggle;
  final void Function(OrgNode, String) onAction;

  const _TreeNodeWidget({
    required this.node,
    this.isRoot = false,
    required this.onToggle,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final hasChildren = node.children.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Node card ────────────────────────────────────────────────
        _NodeCard(
          node: node,
          isRoot: isRoot,
          onToggle: hasChildren ? () => onToggle(node) : null,
          onAction: (action) => onAction(node, action),
        ),

        // ── Connector line down + expand button ───────────────────────
        if (hasChildren) ...[
          _VerticalLine(height: 20),
          _ExpandToggle(
            expanded: node.expanded,
            childCount: node.children.length,
            onTap: () => onToggle(node),
          ),
        ],

        // ── Children ─────────────────────────────────────────────────
        if (hasChildren && node.expanded)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _VerticalLine(height: 20),
          ),

        if (hasChildren && node.expanded)
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            child: _ChildrenRow(
              children: node.children,
              onToggle: onToggle,
              onAction: onAction,
            ),
          ),
      ],
    );
  }
}

// ─── Children Row with connector lines ───────────────────────────────────────

class _ChildrenRow extends StatelessWidget {
  final List<OrgNode> children;
  final void Function(OrgNode) onToggle;
  final void Function(OrgNode, String) onAction;

  const _ChildrenRow({
    required this.children,
    required this.onToggle,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Horizontal connector bar across children
        CustomPaint(
          size: Size(children.length * 200.0, 20),
          painter: _HorizontalConnectorPainter(count: children.length),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children.map((child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _VerticalLine(height: 20),
                  _TreeNodeWidget(
                    node: child,
                    onToggle: onToggle,
                    onAction: onAction,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Node Card ────────────────────────────────────────────────────────────────

class _NodeCard extends StatefulWidget {
  final OrgNode node;
  final bool isRoot;
  final VoidCallback? onToggle;
  final void Function(String) onAction;

  const _NodeCard({
    required this.node,
    this.isRoot = false,
    this.onToggle,
    required this.onAction,
  });

  @override
  State<_NodeCard> createState() => _NodeCardState();
}

class _NodeCardState extends State<_NodeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final node = widget.node;

    return GestureDetector(
      onTap: widget.onToggle,
      onLongPress: () => _showActionMenu(context),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 176,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isRoot
                  ? AppColors.primary
                  : _hovered
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : const Color(0xFFE2E8F0),
              width: widget.isRoot ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : const Color(0x0A000000),
                blurRadius: _hovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Top accent bar (root only) ──────────────────────
              if (widget.isRoot)
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // ── Avatar ──────────────────────────────────────
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: node.avatarColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: node.avatarColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: node.avatarInitials != null
                          ? Text(
                              node.avatarInitials!,
                              style: TextStyle(
                                color: node.avatarColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : Icon(Icons.person_rounded,
                              color: node.avatarColor, size: 28),
                    ),
                    const SizedBox(height: 10),

                    // ── Name ────────────────────────────────────────
                    Text(
                      node.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: widget.isRoot
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // ── Title ───────────────────────────────────────
                    Text(
                      node.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // ── Department ──────────────────────────────────
                    Text(
                      node.department,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: node.avatarColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Actions button ──────────────────────────────
                    _ActionsBtn(onAction: widget.onAction),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NodeActionSheet(
        node: widget.node,
        onAction: widget.onAction,
      ),
    );
  }
}

// ─── Actions Button (inline) ──────────────────────────────────────────────────

class _ActionsBtn extends StatelessWidget {
  final void Function(String) onAction;

  const _ActionsBtn({required this.onAction});

  static const _actions = [
    ('View Profile', Icons.person_outlined),
    ('View Direct Reports', Icons.account_tree_outlined),
    ('Send Message', Icons.message_outlined),
    ('View Organization', Icons.corporate_fare_rounded),
    ('Edit', Icons.edit_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: onAction,
      itemBuilder: (_) => _actions
          .map((a) => PopupMenuItem<String>(
                value: a.$1,
                height: 42,
                child: Row(children: [
                  Icon(a.$2, size: 16, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(a.$1,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary)),
                ]),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('Actions',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary)),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 14, color: AppColors.primary),
        ]),
      ),
    );
  }
}

// ─── Expand Toggle ────────────────────────────────────────────────────────────

class _ExpandToggle extends StatelessWidget {
  final bool expanded;
  final int childCount;
  final VoidCallback onTap;

  const _ExpandToggle({
    required this.expanded,
    required this.childCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: expanded ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedRotation(
              duration: const Duration(milliseconds: 250),
              turns: expanded ? 0.25 : 0,
              child: Icon(
                expanded ? Icons.remove_rounded : Icons.add_rounded,
                size: 18,
                color: expanded ? Colors.white : AppColors.primary,
              ),
            ),
            if (!expanded)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$childCount',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Vertical Line ────────────────────────────────────────────────────────────

class _VerticalLine extends StatelessWidget {
  final double height;
  const _VerticalLine({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: height,
      color: const Color(0xFFCBD5E1),
    );
  }
}

// ─── Horizontal Connector Painter ─────────────────────────────────────────────

class _HorizontalConnectorPainter extends CustomPainter {
  final int count;
  _HorizontalConnectorPainter({required this.count});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (count <= 1) return;

    final midY = 0.0;
    final start = size.width / (count * 2);
    final end = size.width - size.width / (count * 2);

    // Horizontal line
    canvas.drawLine(Offset(start, midY), Offset(end, midY), paint);
  }

  @override
  bool shouldRepaint(_HorizontalConnectorPainter old) => old.count != count;
}

// ─── Zoom Button ─────────────────────────────────────────────────────────────

class _ZoomBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ZoomBtn(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}

// ─── Legend ──────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _legendItem(Icons.touch_app_outlined, 'Tap to expand'),
        const SizedBox(width: 12),
        _legendItem(Icons.pan_tool_outlined, 'Drag to pan'),
        const SizedBox(width: 12),
        _legendItem(Icons.pinch_outlined, 'Pinch to zoom'),
      ]),
    );
  }

  Widget _legendItem(IconData icon, String label) {
    return Row(children: [
      Icon(icon, size: 14, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 10, color: AppColors.textSecondary)),
    ]);
  }
}

// ─── Node Action Bottom Sheet ─────────────────────────────────────────────────

class _NodeActionSheet extends StatelessWidget {
  final OrgNode node;
  final void Function(String) onAction;

  const _NodeActionSheet({required this.node, required this.onAction});

  @override
  Widget build(BuildContext context) {
    const actions = [
      ('View Profile', Icons.person_outlined, false),
      ('View Direct Reports', Icons.account_tree_outlined, false),
      ('Send Message', Icons.message_outlined, false),
      ('View Organization', Icons.corporate_fare_rounded, false),
      ('Edit', Icons.edit_outlined, false),
      ('Remove', Icons.person_remove_outlined, true),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        // Node info header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  node.avatarColor.withValues(alpha: 0.12),
              child: Text(
                node.avatarInitials ?? '?',
                style: TextStyle(
                    color: node.avatarColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(node.name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    Text(node.title,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ]),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.border),
        ...actions.map((a) => ListTile(
              leading: Icon(a.$2,
                  size: 20,
                  color: a.$3
                      ? const Color(0xFFDC2626)
                      : AppColors.primary),
              title: Text(a.$1,
                  style: TextStyle(
                      fontSize: 14,
                      color: a.$3
                          ? const Color(0xFFDC2626)
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
                onAction(a.$1);
              },
            )),
        SizedBox(
            height: MediaQuery.of(context).padding.bottom + 12),
      ]),
    );
  }
}