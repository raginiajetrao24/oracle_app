import 'package:flutter/material.dart';

class ExpandableSectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onEdit;
  const ExpandableSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.onEdit,
  });

  @override
  State<ExpandableSectionCard> createState() =>
      _ExpandableSectionCardState();
}

class _ExpandableSectionCardState
    extends State<ExpandableSectionCard> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: ExpansionTile(
        leading: Icon(widget.icon),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: widget.onEdit,
            ),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            )
          ],
        ),

        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },

        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: widget.child,
          )
        ],
      ),
    );
  }
}