import 'package:flutter/material.dart';
import '../../../app/models/organization_tree_model.dart';
import '../../../app/constants/app_colors.dart';

class OrgTreeCard extends StatefulWidget {
  final bool isSelected;
  final OrgTree tree;
  final bool initiallyExpanded;

  const OrgTreeCard({
    super.key,
    required this.tree,
    this.initiallyExpanded = false,
    this.isSelected = false,
  });

  @override
  State<OrgTreeCard> createState() => _OrgTreeCardState();
}

class _OrgTreeCardState extends State<OrgTreeCard>
    with TickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded && widget.tree.hasVersions;
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    if (_expanded) _rotationController.value = 0.5;
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!widget.tree.hasVersions) return;
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _rotationController.forward();
    } else {
      _rotationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            blurRadius: widget.isSelected ? 12 : 8,
            spreadRadius: widget.isSelected ? 1 : 0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: widget.isSelected
              ? AppColors.primary.withValues(alpha: 0.5)
              : Colors.transparent,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tree.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHeading,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.tree.code} • ${widget.tree.set}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.tree.structure,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.tree.hasVersions)
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: const Icon(Icons.expand_more_rounded),
                    )
                  else
                    const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
          if (_expanded && widget.tree.hasVersions)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                border: Border(
                  top: BorderSide(color: AppColors.divider, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.tree.versions.map((version) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          version.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          version.code,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          version.structure,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        if (version.effectiveStart.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              version.effectiveDateRange,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
