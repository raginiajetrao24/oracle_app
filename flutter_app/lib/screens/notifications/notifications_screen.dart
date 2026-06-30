import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _blue = Color(0xFF1F4E8C);
  static const _text = Color(0xFF1F2937);
  static const _muted = Color(0xFF64748B);

  final List<_NotificationItem> _items = [
    const _NotificationItem(
      status: 'APPROVED',
      title:
          'Approval of Contract 7002 for Lee Supplies from Curtis Feitty (4,995.00 USD)',
      owner: 'Curtis Feitty',
      time: 'Yesterday',
      dismissible: true,
    ),
    const _NotificationItem(
      status: 'APPROVED',
      title: 'Approval of Terms Template PC Testing from curtis.feitty',
      owner: 'Curtis Feitty',
      time: 'Yesterday',
      dismissible: true,
    ),
    const _NotificationItem(
      status: 'APPROVED',
      title: 'Approval of Clause PC Testing from CURTIS.FEITTY',
      owner: 'Curtis Feitty',
      time: 'Yesterday',
      dismissible: true,
    ),
    const _NotificationItem(
      status: 'ACTION REQUIRED',
      title: 'Edit for Stephano Horsten, 4775 (2026-06-12): Process Was Saved',
      owner: 'Curtis Feitty',
      time: '2 weeks ago',
    ),
    const _NotificationItem(
      status: 'ACTION REQUIRED',
      title:
          'Task Collect Company Property Allocated for Ketan MD, 7765 Was Assigned to You',
      owner: 'Ketan MD',
      time: '3 weeks ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FC),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const AppHeaderWidget(title: 'Notifications', showBack: true),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              color: _text,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Show All',
                            style: TextStyle(
                              color: _blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  if (_items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No notifications right now.',
                        style: TextStyle(color: _muted),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return _NotificationTile(
                          item: item,
                          onDismiss: item.dismissible
                              ? () => setState(() => _items.removeAt(index))
                              : null,
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback? onDismiss;

  const _NotificationTile({required this.item, this.onDismiss});

  static const _blue = Color(0xFF00759B);
  static const _text = Color(0xFF1F2937);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.status,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                item.time,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(
              color: _blue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.owner,
            style: const TextStyle(
              color: _text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onDismiss,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Dismiss'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationItem {
  final String status;
  final String title;
  final String owner;
  final String time;
  final bool dismissible;

  const _NotificationItem({
    required this.status,
    required this.title,
    required this.owner,
    required this.time,
    this.dismissible = false,
  });
}
