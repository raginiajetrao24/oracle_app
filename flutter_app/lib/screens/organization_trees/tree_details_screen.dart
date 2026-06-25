import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/organization_tree_model.dart';
import 'package:flutter_app/widgets/common/tree_info_row.dart';

class TreeDetailsScreen extends StatelessWidget {
  final OrgTree tree;

  const TreeDetailsScreen({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D4ED8),
        title: const Text('Tree Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tree.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TreeInfoRow(label: 'Tree Code', value: tree.code),
                    TreeInfoRow(label: 'Set', value: tree.set),
                    TreeInfoRow(
                      label: 'Tree Structure',
                      value: tree.structure,
                    ), // ✅ fixed
                    TreeInfoRow(
                      label: 'Effective Start Date',
                      value: tree.effectiveStart,
                    ),
                    TreeInfoRow(
                      label: 'Effective End Date',
                      value: tree.effectiveEnd,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
